import 'package:flutter/material.dart';
import 'package:guam_community_client/screens/app/splash/splash_screen.dart';
import 'package:guam_community_client/screens/login/login_page.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/styles/fonts.dart';
import 'package:provider/provider.dart';
import 'providers/user_auth/authenticate.dart';
import 'screens/app/app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // future: Future.delayed(Duration(milliseconds: 1500)),
      // 개발시에 주석처리하면 hot reload 시 초기화 안시킬 수 있음.
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            initialRoute: '/',
            debugShowCheckedModeBanner: false,
            routes: {
              '/': (context) => SplashScreen(),
            },
          ); // 초기 로딩 시 Splash Screen
        } else if (snapshot.hasError) {
          return MaterialApp(home: ErrorScreen()); // 초기 로딩 에러 시 Error Screen
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<Authenticate>(create: (_) => Authenticate()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: '/main',
              routes: {
                // 소셜로그인 TOKEN 가지고 있으면 /main 으로 Redirect
                '/signup': (context) => LoginPage(),
                '/main': (context) => App(),
              },
              theme: ThemeData(
                primaryColor: GuamColorFamily.purpleCore,
                fontFamily: GuamFontFamily.SpoqaHanSansNeoMedium,
              ),
            )
          );
        }
      },
    );
  }
}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Error Page");
  }
}
