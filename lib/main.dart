import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rider/pages/create.dart';
import 'package:rider/pages/editpro.dart';
import 'package:rider/pages/firebase.dart';
import 'package:rider/pages/login.dart';
import 'package:rider/pages/profile.dart';
import 'package:rider/pages/register.dart';
import 'package:rider/pages/rider.dart';
import 'package:rider/pages/sender.dart';
import 'package:rider/pages/user.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rider/shared/appdata.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize GetStorage
  await initializeDateFormatting('th_TH');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Connnect to FireStore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => Appdata())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.promptTextTheme(
          Theme.of(context).textTheme.copyWith(
                bodyLarge: TextStyle(
                    color: Colors.white), // เปลี่ยน bodyText1 เป็น bodyLarge
                bodyMedium: TextStyle(
                    color: Colors.white), // เปลี่ยน bodyText2 เป็น bodyMedium
                displayLarge: TextStyle(
                    color: Colors.white), // เปลี่ยน headline1 เป็น displayLarge
                displayMedium: TextStyle(
                    color:
                        Colors.white), // เปลี่ยน headline2 เป็น displayMedium
                // เพิ่มเติมตามความต้องการของคุณ
              ),
        ), // ใช้ฟอนต์ Roboto
        bottomNavigationBarTheme: BottomNavigationBarTheme.of(context).copyWith(
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.black,
        ),
      ),
      home: LoginPage(),
    );
  }
}
