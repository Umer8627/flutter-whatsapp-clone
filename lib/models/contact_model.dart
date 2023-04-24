class ContactModel {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;
  final bool isSenderIsCurrentUser;
  final String lastMessageSentId;
  ContactModel({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
    required this.isSenderIsCurrentUser,
    required this.lastMessageSentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
      'isSenderIsCurrentUser': isSenderIsCurrentUser ,
      'lastMessageSentId': lastMessageSentId,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      contactId: map['contactId'] ?? '',
      isSenderIsCurrentUser: map['isSenderIsCurrentUser'],
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageSentId: map['lastMessageSentId'],
    );
  }
}
