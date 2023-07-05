import 'dart:typed_data';
import 'package:whatsapp_clone/enums/message_enum.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final bool senderIsCurrentUser;
  final String? caption;
  final Uint8List? file;
  final bool? isuploaded;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.senderIsCurrentUser,
    required this.caption,
    this.file,
    this.isuploaded,
  });

Message copyWith({
    String? senderId,
    String? receiverId,
    String? text,
    MessageEnum? type,
    DateTime? timeSent,
    String? messageId,
    bool? isSeen,
    bool? senderIsCurrentUser,
    String? caption,
    Uint8List? file,
    bool? isuploaded,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      type: type ?? this.type,
      timeSent: timeSent ?? this.timeSent,
      messageId: messageId ?? this.messageId,
      isSeen: isSeen ?? this.isSeen,
      senderIsCurrentUser: senderIsCurrentUser ?? this.senderIsCurrentUser,
      caption: caption ?? this.caption,
      file: file ?? this.file,
      isuploaded: isuploaded ?? this.isuploaded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'senderIsCurrentUser': senderIsCurrentUser,
      'caption': caption,
      'isuploaded':isuploaded,
    };
  }

  Map<String, dynamic> toHive() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'senderIsCurrentUser': senderIsCurrentUser,
      'caption': caption,
      'file': file,
      'isuploaded': isuploaded,
    };
  }

  factory Message.fromMap(Map<dynamic, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
      senderIsCurrentUser: map['senderIsCurrentUser'],
      caption: map['caption'],
      isuploaded: map['isuploaded'],
    );
  }
}
