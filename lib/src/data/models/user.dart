import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String profilePic;
  const User({
    required this.id,
    required this.name,
    required this.profilePic,
  });

  User copyWith({
    String? id,
    String? name,
    String? profilePic,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'profilePic': profilePic,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, profilePic];
}
