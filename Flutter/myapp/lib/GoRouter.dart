import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _router = GoRouter(
    routes: [
      GoRoute(path: "/", builder: (context, state) => Home()),
   GoRoute(path:"/login",builder :(context,state)=>Login()),

   GoRoute(path:"/dashboard",redirect:(context,state){
   bool isLoggedin=true;
   return isLoggedin?null:"/login";},  builder:(context,state)=>Dashboard()),


  //path parameter
  GoRoute(
  path: "/details/:userId",
  builder: (context, state) {
  final userId = state.pathParameters['userId'];
  return Details(userId: userId);}
  ),]);

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      routerConfig: _router,
      title: "GoRouter Example",
    );
  }
}
class Login extends StatelessWidget{
  const Login({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(title: Text("Login  Page",
          style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.grey,
      ),
      body:Center(
        child: Column(
          mainAxisSize:MainAxisSize.min,
          children: [
            SizedBox(
              width: 300, // fixed width
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height:30),
            ElevatedButton(
                onPressed: () {
                  context.push("/dashboard");
                },
                child: Text("Go to Dashboard")),
            SizedBox(height:40),],


        ),
    )
    );
  }
}
class Dashboard extends StatelessWidget{
  const Dashboard({super.key});
  Widget build(BuildContext context){
    return Scaffold(
      appBar:  AppBar(
      title: Text(
        "Dashboard",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      backgroundColor: Colors.grey,
    ),
      body:Center(
        child:Padding(padding: EdgeInsets.all(50),
        child:Column(
          children:[Text("This your Dashboard"),Text("your working days 28 out of 30"),Text("You ara absent for 2 days")],
        )

      )
    ));
  }
}
class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("welcome to home page",
                  style: TextStyle(color: Colors.blue, fontSize: 20)),
              Text("You can move pages by clicking buttons"
                  "]");

              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => context.push("/details/1"),
                child: Text("Go to Details page by pushing"),
              ),

              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => context.go("/details/1"),
                child: Text("Go to Details page"),
              ),

              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => context.push("/login"),
                child: Text("Go to Login"),
              ),

              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => context.go("/dashboard"),
                child: Text("Go to Dashboard"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Details extends StatelessWidget {
  final String? userId;


  Details({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details Page",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("All Users",style:TextStyle(decorationColor: Colors.red,fontSize: 20)),SizedBox(height:30),Text("user 1"),Text("user 2"),Text("user 3"),
            Text(userId!=null&&int.parse(userId!)<3? "User Id : $userId":"UserId exceeds",style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go("/"),
              child: Text("Back to Home"),
            ),
            SizedBox(height:40),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: Text("Back to Home using pop"),
            ),
          ],
        ),
      ),
    );
  }
}