import '../core/services/local_storage_service.dart';
import '../services/local_storage_service_impl.dart';
import '../core/services/auth_service.dart';
import '../services/auth_service_impl.dart';
class AppRepository {
  final localStorageServiceProvider = LocalStorageServiceImpl();
  final AuthService auth=AuthService();

  init() async {
    await localStorageServiceProvider.init();
  }


}
