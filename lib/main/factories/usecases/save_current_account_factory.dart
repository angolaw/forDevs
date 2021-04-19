import 'package:fordev/data/usecases/save_current_account/local_save_current_account.dart';
import 'package:fordev/domain/usecases/save_current_account.dart';

import '../factories.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() {
  return LocalSaveCurrentAccount(
      saveSecureCacheStorage: makeLocalStorageAdapter());
}
