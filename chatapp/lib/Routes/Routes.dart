import 'package:chatapp/Presentation/Pages/AuthPages/LoginPage.dart';
import 'package:chatapp/Presentation/Pages/AuthPages/SignUpPage.dart';
import 'package:chatapp/Presentation/Pages/ProfilePicture/ProfilePicture.dart';
import 'package:chatapp/Presentation/Pages/Screens/ChatRoom.dart';
import 'package:chatapp/Presentation/Pages/Screens/FriendRequests.dart';
import 'package:chatapp/Presentation/Pages/Screens/HomePage.dart';
import 'package:chatapp/Presentation/Pages/Screens/ProfilePage.dart';
import 'package:chatapp/Presentation/Pages/Screens/SearchUserPage.dart';
// import 'package:chatapp/Presentation/Pages/Screens/UserProfileScreen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => LoginPage());

      case "/signup":
        return MaterialPageRoute(builder: (_) => SignUpPage());

      case "/home":
        return MaterialPageRoute(builder: (_) => HomePageScreen());

      case "/profilepicture":
        return MaterialPageRoute(builder: (_) => ProfilePicture());
      // case "/userprofile":
      //   final email = settings.arguments as String;
      //   return MaterialPageRoute(
      //       builder: (_) => UserProfileScreen(email: email));
      case "/search":
        return MaterialPageRoute(builder: (_) => SearchPage());

      case "/profile":
        return MaterialPageRoute(builder: (_) => ProfilePage());

      case "/chatroom":
        final args = settings.arguments as Map<String, dynamic>;
        final id = args['id'] as int;
        final name = args['name'] as String;
        return MaterialPageRoute(
            builder: (_) => ChatRoom(
                  id: id,
                  name: name,
                ));

      case "/friendrequest":
        return MaterialPageRoute(builder: (_) => FriendRequestPage());
      default:
        return MaterialPageRoute(builder: (_) => Error());
    }
  }
}

class Error extends StatelessWidget {
  const Error({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Error!"),
      ),
    );
  }
}
