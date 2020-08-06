import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:payminderapp/ui/add_field_page.dart';
import 'package:payminderapp/ui/details_page.dart';
import 'package:payminderapp/ui/home_page.dart';
import 'package:payminderapp/ui/login_screen.dart';
import 'package:payminderapp/ui/paid_page.dart';
import 'package:payminderapp/ui/registration_screen.dart';
import 'package:payminderapp/ui/settings_page.dart';
import 'package:payminderapp/ui/tab_bar_view.dart';
import 'package:payminderapp/ui/loading_screen.dart';
import 'package:payminderapp/ui/welcome_screen.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid=AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
      });
  runApp(PayminderApp());
}

class PayminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoadingScreen.id,
      routes: {
        LoadingScreen.id:(context)=>LoadingScreen(),
        TabBarViews.id:(context)=>TabBarViews(),
        RegistrationScreen.id:(context)=>RegistrationScreen(),
        DetailsPage.id:(context)=>DetailsPage(),
        LoginScreen.id:(context)=>LoginScreen(),
        HomePage.id:(context)=>HomePage(),
        PaidPage.id:(context)=>PaidPage(),
        SettingsPage.id:(context)=>SettingsPage(),
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        AddFieldPage.id:(context)=>AddFieldPage(),
      },
    );
  }
}
