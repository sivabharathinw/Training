import '../core/services/local_storage_service.dart';
import '../services/local_storage_service_impl.dart';

class AppRepository {
  final localStorageServiceProvider = LocalStorageServiceImpl();
  init() async {
    await localStorageServiceProvider.init();
  }
}