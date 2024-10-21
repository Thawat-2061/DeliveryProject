import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rider/pages/login.dart';
import 'package:rider/pages/rider.dart';
import 'package:rider/pages/editpro.dart';
import 'dart:developer' as developer;

import 'package:rider/pages/ridergps.dart';
import 'package:rider/pages/rieditprofile.dart';
import 'package:rider/pages/ripass.dart';

class RiProPage extends StatefulWidget {
  const RiProPage({super.key});

  @override
  State<RiProPage> createState() => _RiProPageState();
}

class _RiProPageState extends State<RiProPage> {
  //-----------------------------------------------------------
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Get.to(() => const RiderPage());

        break;
      case 1:
        break;
      // เพิ่มกรณีอื่นๆ สำหรับการนำทางไปยังหน้าอื่นๆ ที่นี่
    }
  }
//-----------------------------------------------------------

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/icon.png',
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
                            'Triple Superdick',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'mrdick5555@gmail.com',
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
                        Get.to(() => const RiEditPage());
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
                      Get.to(() => const RiPassPage());
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(
            95, 46, 45, 45), // สีพื้นหลังของ BottomNavigationBar
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
            icon: Image.asset(
              'assets/images/cyc.png', // ระบุพาธของรูปภาพ
              width: 100, // กำหนดความกว้างของรูปภาพ
              height: 50, // กำหนดความสูงของรูปภาพ
            ),
            label: 'รับออเดอร์', // ข้อความของรายการ
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/profile.png', // ระบุพาธของรูปภาพ
              width: 50, // กำหนดความกว้างของรูปภาพ
              height: 50, // กำหนดความสูงของรูปภาพ
            ),
            label: 'ข้อมูลส่วนตัว', // ข้อความของรายการ
          ),
        ],
      ),
    );
  }
}
