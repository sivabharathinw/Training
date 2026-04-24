import 'dart:typed_data';

abstract class FileStorageService {
  Future<void> init();
  
  Future<String?> uploadFile(Uint8List bytes, String fileName);
  Future<String?> downloadFile(String fileId);

  Future<void> deleteFile(String fileId);
  String getFilePreviewUrl(String fileId);
}
