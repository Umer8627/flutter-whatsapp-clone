// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  final String name;
  final String profilePic;
  final String phone;
  final bool isonline;
  final String email;
  final List<String> groupId;
  UserModel({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.phone,
    required this.isonline,
    required this.email,
    required this.groupId,
  });

 

  UserModel copyWith({
    String? uid,
    String? name,
    String? profilePic,
    String? phone,
    bool? isonline,
    String? email,
    List<String>? groupId,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      phone: phone ?? this.phone,
      isonline: isonline ?? this.isonline,
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
      'isonline': isonline,
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
      isonline: map['isonline'] as bool,
      email: map['email'] as String,
      groupId: List<String>.from(map['groupId']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, profilePic: $profilePic, phone: $phone, isonline: $isonline, email: $email, groupId: $groupId)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.name == name &&
      other.profilePic == profilePic &&
      other.phone == phone &&
      other.isonline == isonline &&
      other.email == email &&
      listEquals(other.groupId, groupId);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      name.hashCode ^
      profilePic.hashCode ^
      phone.hashCode ^
      isonline.hashCode ^
      email.hashCode ^
      groupId.hashCode;
  }
}
