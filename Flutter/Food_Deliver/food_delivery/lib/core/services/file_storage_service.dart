import 'dart:io';

abstract class FileStorageService {
  Future<void> init();
  

  Future<String?> uploadFile(File file)
  Future<String?> downloadFile(String fileId);

  // Deletes a file from the storage bucket.
  Future<void> deleteFile(String fileId);

  //Gets the preview URL for a file.
  String getFilePreviewUrl(String fileId);
}
