import 'dart:io';
import 'package:appwrite/appwrite.dart';
import '../core/appwrite_config.dart';
import '../core/services/appwrite_service.dart';
import '../core/services/file_storage_service.dart';

class AppwriteFileStorageServiceImpl implements FileStorageService {
  Storage get _storage => AppwriteService.storage;
  final String _bucketId = AppwriteConfig.bucketId;

  @override
  Future<void> init() async {

  }

  @override
  Future<String?> uploadFile(File file) async {
    try {
      print('Starting Appwrite file upload: ${file.path}');
      final result = await _storage.createFile(
        bucketId: _bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
        permissions: [
          Permission.read(Role.any()),
        ],
      );
      print('Appwrite file upload successful: ${result.$id}');
      return result.$id;
    } catch (e) {
      print('Appwrite file upload failed: $e');
      return null;
    }
  }

  @override
  Future<String?> downloadFile(String fileId) async {
    try {
      final result = await _storage.getFile(
        bucketId: _bucketId,
        fileId: fileId,
      );
      return result.$id;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<void> deleteFile(String fileId) async {
    try {
      await _storage.deleteFile(
        bucketId: _bucketId,
        fileId: fileId,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  String getFilePreviewUrl(String fileId) {
    return '${AppwriteConfig.endpoint}/storage/buckets/$_bucketId/files/$fileId/preview?project=${AppwriteConfig.projectId}';
  }
}
