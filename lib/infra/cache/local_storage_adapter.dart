import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:meta/meta.dart';

class LocalStorageAdapter
    implements SaveSecureCacheStorage, FetchSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({@required this.secureStorage});

  @override
  Future<void> saveSecure({String key, String value}) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String> fetchSecure(String key) async {
    try {
      final value = await secureStorage.read(key: key);
      return value;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
