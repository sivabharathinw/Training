import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
class Users{
Future<void> fetchUser() async{
  var url=Uri.parse("http://localhost:3000/Students");
  var res=await http.get(url);
  print(res);
  if(res.statusCode==200){
    var data=jsonDecode(res.body);
    print(data);
  

  }
else{
  print("unable to fetch the data");
}
}
Future <void> addUser() async{
  var url=Uri.parse("http://localhost:3000/Students");
   var res = await http.post(
    url,
    headers: {
      "Content-Type": "application/json"
    },
    body: jsonEncode({
      "id": 3,
      "name": "siva"
    }),
  );
  if(res.statusCode==201){
    print("student added successfuly");
    print(res.body);
  }
  else{
    print("unable to add user");
  }
}
Future<void> UpdateUser() async{
  var url=Uri.parse("http://localhost:3000/Students/1");
  var res=await http.put(url,headers:{
    "Content-Type":"application/json"
  },body: jsonEncode({
    "id":1,
    "name":"ananya"
  })
  );
  if(res.statusCode==200){
    print("updated succesfully");
    print(res.body);
  }
  else{
    print("unable to upadte");
  }

}
}


void main()async{
  Users u=Users();
  await u.fetchUser();
  await u.addUser();
  await u.UpdateUser();
}
