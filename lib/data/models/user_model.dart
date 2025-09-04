import 'package:receipes_app_02/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required String id, required String name, required String email})
    : super(id: id, name: name, email: email);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(id: user.id, name: user.name, email: user.email);
  }
}
