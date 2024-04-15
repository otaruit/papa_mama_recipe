// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Menu {
  final String id;
  final int dayOfTheWeek;
  final String mainDish;
  final String sideDish;
  final String soup;
  final String others;
  final String uid;

  const Menu({
    required this.id,
    required this.dayOfTheWeek,
    required this.mainDish,
    required this.sideDish,
    required this.soup,
    required this.others,
    required this.uid,
  });

  Menu copyWith({
    String? id,
    int? dayOfTheWeek,
    String? mainMenu,
    String? sideMenu,
    String? soup,
    String? others,
    String? uid,
  }) {
    return Menu(
      id: id ?? this.id,
      dayOfTheWeek: dayOfTheWeek ?? this.dayOfTheWeek,
      mainDish: mainMenu ?? this.mainDish,
      sideDish: sideMenu ?? this.sideDish,
      soup: soup ?? this.soup,
      others: others ?? this.others,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dayOfTheWeek': dayOfTheWeek,
      'mainMenu': mainDish,
      'sideMenu': sideDish,
      'soup': soup,
      'others': others,
      'uid': uid,
    };
  }

  factory Menu.fromMap(Map<String, dynamic> map) {
    return Menu(
      id: map['\$id'] ?? '',
      dayOfTheWeek: map['dayOfTheWeek'] ?? 0,
      mainDish: map['mainMenu'] ?? '',
      sideDish: map['sideMenu'] ?? '',
      soup: map['soup'] ?? '',
      others: map['others'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Menu.fromJson(String source) => Menu.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Menu(id: $id, dayOfTheWeek: $dayOfTheWeek, mainMenu: $mainDish, sideMenu: $sideDish, soup: $soup, others: $others, uid: $uid)';
  }

  @override
  bool operator ==(covariant Menu other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.dayOfTheWeek == dayOfTheWeek &&
      other.mainDish == mainDish &&
      other.sideDish == sideDish &&
      other.soup == soup &&
      other.others == others &&
      other.uid == uid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      dayOfTheWeek.hashCode ^
      mainDish.hashCode ^
      sideDish.hashCode ^
      soup.hashCode ^
      others.hashCode ^
      uid.hashCode;
  }
}
