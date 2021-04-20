import 'package:fordev/data/usecases/load_current_account/local_load_current_account.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import '../factories.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(
      fetchSecureCacheStorage: makeLocalStorageAdapter());
}
