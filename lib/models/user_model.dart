// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String uid;
  final String email;
  final String linkedUid;
  const UserModel({
    required this.uid,
    required this.email,
    required this.linkedUid,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? linkedUid,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      linkedUid: linkedUid ?? this.linkedUid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'linkedUid': linkedUid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['\$id'] as String,
      email: map['email'] as String,
      linkedUid: map['linkedUid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserModel(uid: $uid, email: $email, linkedUid: $linkedUid)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return other.uid == uid &&
        other.email == email &&
        other.linkedUid == linkedUid;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode ^ linkedUid.hashCode;
}
