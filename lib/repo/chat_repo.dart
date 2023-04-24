import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/enums/message_enum.dart';
import 'package:whatsapp_clone/models/contact_model.dart';
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';

class ChatRepo {
  static final instance = ChatRepo();
  String userCollection = 'testing-users';
  String chatCollection = 'chats';
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<ContactModel>> getContactedChats() {
    return firestore
        .collection('testing-users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ContactModel> contacts = [];
      for (var document in event.docs) {
        final chatContact = ContactModel.fromMap(document.data());
        var userData = await firestore
            .collection('testing-users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ContactModel(
              name: user.name,
              profilePic: user.profilePic,
              contactId: chatContact.contactId,
              timeSent: chatContact.timeSent,
              lastMessage: chatContact.lastMessage,
              isSenderIsCurrentUser: chatContact.isSenderIsCurrentUser,
              lastMessageSentId: chatContact.lastMessageSentId),
        );
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactsSubcollection({
    required UserModel senderUserData,
    required UserModel recieverUserData,
    required String text,
    required DateTime timeSent,
    required String recieverUserId,
    required String lastMessageSentId,
  }) async {
    var receiverChatContact = ContactModel(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
      isSenderIsCurrentUser: false,
      lastMessageSentId: lastMessageSentId,
    );
    await firestore
        .collection(userCollection)
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          receiverChatContact.toMap(),
        );
    // users -> current user id  => chats -> reciever user id -> set data
    var senderChatContact = ContactModel(
        name: recieverUserData.name,
        profilePic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        timeSent: timeSent,
        isSenderIsCurrentUser: true,
        lastMessage: text,
        lastMessageSentId: lastMessageSentId);
    await firestore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  Future<void> _saveMessageToMessageSubcollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String username,
    required MessageEnum messageType,
    required String senderUsername,
    required String? recieverUserName,
    required String lastMessageSentId,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: lastMessageSentId,
      isSeen: false,
      senderIsCurrentUser: false,
    );
    // users -> sender id -> reciever id -> messages -> message id -> store message
    await firestore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(lastMessageSentId)
        .set(
          message.toMap(),
        );
    // users -> eciever id  -> sender id -> messages -> message id -> store message
    await firestore
        .collection(userCollection)
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(lastMessageSentId)
        .set(
          message.toMap(),
        );
  }

  Future<void> sendTextMessage(
      {required String text,
      required UserModel receiverUserModel,
      required UserModel senderUser}) async {
    try {
      var timeSent = DateTime.now();
      //  UserModel receiverUser = await firestore.collection(userCollection).doc(recieverUserId).get().then((value) => UserModel.fromMap(value.data()!));
      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
        recieverUserData: receiverUserModel,
        recieverUserId: receiverUserModel.uid,
        senderUserData: senderUser,
        text: text,
        timeSent: timeSent,
        lastMessageSentId: messageId,
      );

      _saveMessageToMessageSubcollection(
        receiverUserId: receiverUserModel.uid,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        lastMessageSentId: messageId,
        username: senderUser.name,
        recieverUserName: receiverUserModel.name,
        senderUsername: senderUser.name,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<int> getUnseenMessagesCount(ContactModel contact) {
    return firestore
        .collection(userCollection)
        .doc(contact.contactId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .where('receiverId', isEqualTo: auth.currentUser!.uid)
        .where('isSeen', isEqualTo: false)
        .snapshots()
        .map((event) {
      return event.docs.length;
    });
  }

  Stream<bool> isMessageRead({required String contactId,required String messageId}) {
    return firestore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(contactId)
        .collection('messages')
        .doc(messageId)
        .snapshots()
        .map((doc) => doc.exists && doc.get('isSeen'));
  }

  void setChatMessageSeen(
      {required Message message, required UserModel receiverModel}) async {
    log('ReceiverId ${message.receiverId}');
    log('CurrentUser/SenderId ${message.senderId}');
    log('MessageId ${message.messageId}');
    try {
      await firestore
          .collection(userCollection)
          .doc(receiverModel.uid)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(message.messageId)
          .update({'isSeen': true});
      await firestore
          .collection(userCollection)
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverModel.uid)
          .collection('messages')
          .doc(message.messageId)
          .update({'isSeen': true});
    } catch (e) {
      throw Exception(e);
    }
  }
}
