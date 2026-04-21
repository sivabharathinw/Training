import '../services/appwrite_auth_service_impl.dart';
import '../services/appwrite_db_service_impl.dart';
import '../core/services/local_storage_service.dart';
import '../services/local_storage_service_impl.dart';
import '../core/services/auth_service.dart';
import '../services/firebase_auth_service_impl.dart';
import '../services/firestore_service_impl.dart';
import '../core/services/appwrite_service.dart';
import '../core/services/file_storage_service.dart';
import '../services/appwrite_file_storage_service_impl.dart';

class AppRepository {
  final AuthenticationService auth = AppwriteAuthServiceImpl();
  //for db create instace for appwritedbstorage with the type of interface storage
  final StorageService storage = AppwriteStorageServiceImpl();
  final FileStorageService files = AppwriteFileStorageServiceImpl();

  init() async {
    AppwriteService.init();
    await AppwriteAdminSetup.setup();
  }
}