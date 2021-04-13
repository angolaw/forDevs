import 'package:fordev/domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel({this.accessToken});

  factory RemoteAccountModel.fromJson(Map json) =>
      RemoteAccountModel(accessToken: json['accessToken']);
  AccountEntity toEntity() => AccountEntity(token: accessToken);
}
