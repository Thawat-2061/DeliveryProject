import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:rider/config/config.dart';
import 'package:rider/pages/editpro.dart';
import 'package:rider/pages/login.dart';
import 'package:rider/pages/receiver.dart';
import 'package:rider/pages/sender.dart';
import 'dart:developer' as developer;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProdilePageState();
}

class _ProdilePageState extends State<ProfilePage> {
  //-----------------------------------------------------------
  List<dynamic>? userData;
  int _selectedIndex = 2;
  String url = '';
  var userId;
  var userUsername;
  var userEmail;
  var userImage;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Get.to(() => const SenderPage());

        break;
      case 1:
        Get.to(() => const ReceiverPage());
        break;
      case 2:
        Get.to(() => const ProfilePage());
        break;

      // เพิ่มกรณีอื่นๆ สำหรับการนำทางไปยังหน้าอื่นๆ ที่นี่
    }
  }

//-----------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await GetApiEndpoint();
    await getUserDataFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    ClipOval(
                      child: Image.network(
                        '$userImage',
                        width: 180.0, // กำหนดความกว้างของวงกลม
                        height: 180.0, // กำหนดความสูงของวงกลม
                        fit: BoxFit.cover, // ปรับขนาดภาพให้พอดีกับวงกลม
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              userUsername,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              userEmail,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.7, // ปรับความกว้างตามขนาดหน้าจอ
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const EditproPage());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(50.0), // มุมโค้งของปุ่ม
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 214, 78, 51),
                                Color.fromARGB(255, 233, 200, 93)
                              ], // ไล่เฉดสีจากส้มเข้มไปอ่อน
                              begin: Alignment.centerLeft, // เริ่มไล่จากซ้าย
                              end: Alignment.centerRight, // ไปจบที่ขวา
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5), // สีเงา
                                spreadRadius: 2, // การกระจายของเงา
                                blurRadius: 5, // ความเบลอของเงา
                                offset: Offset(2, 4), // ระยะห่างของเงา
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      indent: 20,
                      endIndent: 20,
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        // เมื่อกดปุ่มนี้ให้ไปที่หน้า LoginPage
                        // Get.to(() => const LoginPage());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  size: 50.0,
                                  color: const Color.fromARGB(255, 244, 89, 54),
                                ),
                              ],
                            ),
                            Text(
                              'Password',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 50.0,
                              color: const Color.fromARGB(255, 244, 89, 54),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      indent: 20,
                      endIndent: 20,
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        // เมื่อกดปุ่มนี้ให้ไปที่หน้า LoginPage
                        // Get.to(() => const LoginPage());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.settings,
                              size: 50.0,
                              color: const Color.fromARGB(255, 244, 89, 54),
                            ),
                            Text(
                              'Setting',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 50.0,
                              color: const Color.fromARGB(255, 244, 89, 54),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      indent: 20,
                      endIndent: 20,
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        // เมื่อกดปุ่มนี้ให้ไปที่หน้า LoginPage
                        GetStorage().erase().then((_) {
                          developer.log(
                              'Data cleared from GetStorage'); // เพิ่มการแจ้งเตือนใน log
                        }).catchError((error) {
                          developer.log(
                              'Error clearing data from GetStorage: $error'); // เพิ่มการแจ้งเตือนใน log
                        });
                        Get.to(() => const LoginPage());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              size: 50.0,
                              color: const Color.fromARGB(255, 244, 89, 54),
                            ),
                            Text(
                              'Logout',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 50.0,
                              color: const Color.fromARGB(255, 244, 89, 54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            const Color(0xFF171716), // สีพื้นหลังของ BottomNavigationBar
        selectedItemColor:
            const Color.fromARGB(255, 240, 65, 42), // สีของไอคอนที่ถูกเลือก
        unselectedItemColor: Colors.grey, // สีของไอคอนที่ไม่ถูกเลือก
        currentIndex: _selectedIndex, // กำหนด index ของไอคอนที่ถูกเลือก
        onTap: _onItemTapped,
        showSelectedLabels: true, // แสดงข้อความของไอคอนที่เลือก
        showUnselectedLabels: true, // แสดงข้อความของไอคอนที่ไม่เลือก
        selectedLabelStyle: TextStyle(
          fontSize: 14, // กำหนดขนาดตัวอักษรเมื่อเลือก
          fontWeight: FontWeight.bold, // ทำให้ข้อความตัวหนาเมื่อถูกเลือก
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14, // กำหนดขนาดตัวอักษรเมื่อไม่เลือกให้เท่ากัน
          fontWeight:
              FontWeight.normal, // ไม่ทำให้ข้อความตัวหนาเมื่อไม่ถูกเลือก
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.unarchive, size: 30), // ไอคอนของรายการ
            label: 'Sender', // ข้อความของรายการ
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive, size: 30), // ไอคอนของรายการ
            label: 'Receiver', // ข้อความของรายการ
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/profile.png', // ระบุพาธของรูปภาพ
              width: 30, // กำหนดความกว้างของรูปภาพ
              height: 30, // กำหนดความสูงของรูปภาพ
            ),
            label: 'Profile', // ข้อความของรายการ
          ),
        ],
      ),
    );
  }

  Future<void> GetApiEndpoint() async {
    Configguration.getConfig().then(
      (value) {
        log('MainUserGet API ');
        // log(value['apiEndpoint']);
        setState(() {
          url = value['apiEndpoint'];
        });
      },
    ).catchError((err) {
      log(err.toString());
    });
  }

  Future<void> getUserDataFromStorage() async {
    final storage = GetStorage();

    final userId = storage.read('UserID');
    final userUsername = storage.read('Username');
    final userEmail = storage.read('Email');
    final userImage = storage.read('Image');

    // log(userUsername);

    setState(() {
      this.userId = userId;
      this.userUsername = userUsername;
      this.userEmail = userEmail;
      this.userImage = userImage;
      // log(userId);
    });
  }
}
