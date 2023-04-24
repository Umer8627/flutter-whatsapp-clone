import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:whatsapp_clone/models/user_model.dart';

class ContactRepo {
  static final ContactRepo instance = ContactRepo();

  Future<List<Contact>> getContactFromFirebase() async {
    List<Contact> allContacts = [];
    List<Contact> firebaseContact = [];
    List<Future<bool>> futures = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        allContacts = await FlutterContacts.getContacts(
            withPhoto: true, withThumbnail: true, withProperties: true);

        for (var i = 0; i < allContacts.length; i++) {
          futures.add(doesContactExistInFirebase(allContacts[i]));
        }
        List<bool> result = await Future.wait(futures);

        for (var i = 0; i < result.length; i++) {
          if (result[i]) {
            firebaseContact.add(allContacts[i]);
          }
        }
      } else {
        throw Exception("Permission not granted");
      }
    } catch (e) {
      throw Exception(e);
    }
    return firebaseContact;
  }

  Future<bool> doesContactExistInFirebase(Contact contact) async {
    String phone = contact.phones.first.number.replaceAll(' ', '').toString();
    String modifiedNo = phone.startsWith('0')
        ? '+92${phone.substring(1)}' // remove leading 0 and add '+92'
        : phone;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('testing-users')
        .where('phone', isEqualTo: modifiedNo)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<UserModel> selectedContact(Contact contact) async {
    String phone = contact.phones.first.number.replaceAll(' ', '').toString();
    String modifiedNo = phone.startsWith('0')
        ? '+92${phone.substring(1)}' // remove leading 0 and add '+92'
        : phone;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('testing-users')
        .where('phone', isEqualTo: modifiedNo)
        .limit(1)
        .get();

    UserModel userModel =
        UserModel.fromMap(querySnapshot.docs.first.data() as dynamic);
    return userModel;
  }
}
