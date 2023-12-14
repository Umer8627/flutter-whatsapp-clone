

class UserModel {
  final String uid;
  final String name;
  final String profilePic;
  final String phone;
  final bool isOnline;
  final String email;
  final List<String> groupId;
  UserModel({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.phone,
    required this.isOnline,
    required this.email,
    required this.groupId,
  });

 

  UserModel copyWith({
    String? uid,
    String? name,
    String? profilePic,
    String? phone,
    bool? isOnline,
    String? email,
    List<String>? groupId,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      phone: phone ?? this.phone,
      isOnline: isOnline ?? this.isOnline,
      email: email ?? this.email,
      groupId: groupId ?? this.groupId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profilePic': profilePic,
      'phone': phone,
      'isOnline': isOnline,
      'email': email,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      phone: map['phone'] as String,
      isOnline: map['isOnline'] as bool,
      email: map['email'] as String,
      groupId: List<String>.from(map['groupId']),
    );
  }

  
}
