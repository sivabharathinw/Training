import '../core/services/local_storage_service.dart';
import '../services/local_storage_service_impl.dart';
import '../core/services/auth_service.dart';
import '../services/auth_service_impl.dart';
import '../services/firestore_service_impl.dart';

class AppRepository {
  final AuthService auth = AuthService();
  final StorageService storage = FirestoreServiceImpl();

  init() async {
    await storage.init();
  }
}