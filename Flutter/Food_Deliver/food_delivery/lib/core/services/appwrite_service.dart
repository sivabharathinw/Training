import 'package:appwrite/appwrite.dart';
import '../appwrite_config.dart';

class AppwriteService {
  //client connects to appwrite,send requst,recieve response
   static  Client client = Client();
   //account used for authenticaation like sighnu,login,logout
  static Account account = Account(client);
  //database for storing the data
    static Databases databases = Databases(client);
    //storeage for storing yhe files (imagges,pdf)
  static  Storage storage = Storage(client);

  static void init() {
    //client must be initialized before using it
    client
        .setEndpoint(AppwriteConfig.endpoint)//setEndpoint where the appwrite server is located
        .setProject(AppwriteConfig.projectId);//project id of the appwrite project
  }
}