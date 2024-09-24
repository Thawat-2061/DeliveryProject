import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rider/pages/register.dart';
import 'package:rider/pages/sender.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  int selectedIndex = 0; // ตัวแปรเพื่อเก็บค่า index

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async {
        // คืนค่า false เพื่อป้องกันการย้อนกลับ
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFF171716),
        body: Center(
          child: SingleChildScrollView(
            // ทำให้เลื่อนแนวตั้งได้ในกรณีที่หน้าจอเล็ก
            child: Column(
              children: [
                Image.asset(
                  'assets/images/newlo.png',
                  width: MediaQuery.of(context).size.width, // ความกว้างเต็มหน้าจอ
                  height: 350, // กำหนดขนาดความสูงของรูป
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, // ปรับขนาดตามหน้าจอ
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (value) =>
                                  email = value, // เก็บค่าที่ผู้ใช้กรอก
                              decoration: InputDecoration(
                                labelText:
                                    "Email", // ข้อความ "Email" ภายใน TextField
                                labelStyle: TextStyle(
                                  color: Colors.white, // สีของข้อความ "Email"
                                ),
                                prefixIcon: Icon(
                                  Icons.email_outlined, // เพิ่มไอคอน Gmail
                                  color: Colors.white, // สีของไอคอน
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: Colors.white, // สีขอบ
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: Colors.white, // สีขอบเมื่อ focus
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                  color: Colors.white), // สีข้อความที่กรอก
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16), // ระยะห่างระหว่างช่อง
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, // ปรับขนาดตามหน้าจอ
                        child: Column(
                          children: [
                            TextField(
                              obscureText: true, // ซ่อนรหัสผ่าน
                              decoration: InputDecoration(
                                labelText:
                                    "Password", // ข้อความ "Password" ภายใน TextField
                                labelStyle: TextStyle(
                                  color: Colors.white, // สีของข้อความ "Password"
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline, // เพิ่มไอคอนแม่กุญแจ
                                  color: Colors.white, // สีของไอคอน
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: Colors.white, // สีขอบเมื่อไม่ focus
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: Colors.white, // สีขอบเมื่อ focus
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                  color: Colors.white), // สีของข้อความที่กรอก
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        ToggleSwitch(
                          minWidth: 90.0,
                          cornerRadius: 20.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          initialLabelIndex: 0,
                          totalSwitches: 2,
                          labels: ['User', 'Rider'],
                          customTextStyles: [
                            TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold, // ตัวหนาสำหรับ 'User'
                              color: Colors.white, // สีของข้อความ
                            ),
                            TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold, // ตัวหนาสำหรับ 'Rider'
                              color: Colors.white, // สีของข้อความ
                            ),
                          ],
                          radiusStyle: true,
                          activeBgColors: [
                            [Colors.orange, Colors.yellow],
                            [Colors.orange, Colors.yellow],
                          ],
                          animate: true,
                          curve: Curves.fastOutSlowIn,
                          onToggle: (index) {
                            if (index != null) {
                              selectedIndex = index; // เก็บค่า index ที่เลือก
                            }
                            // log('switched to: $index');
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.7, // ปรับความกว้างตามขนาดหน้าจอ
                          height: 50,
                          child: GestureDetector(
                            onTap: () {
                              log('Email: $email');
                              log('Selected Index: $selectedIndex'); // Log ค่า index
      
                              Get.to(() => const SenderPage());
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
                                  "LOGIN",
                                  style: TextStyle(
                                    color: Colors.white,
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
                    SizedBox(height: 20),
      
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Get.to(() => const RegisterPage());
                                  },
                                  icon: SizedBox(
                                    width: 40, // กำหนดความกว้าง
                                    height: 40, // กำหนดความสูง
                                    child: Image.asset(
                                        'assets/images/add.png'), // รูป add.png
                                  ),
                                ),
                                Text("Register"),
                              ],
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: SizedBox(
                                    width: 40, // กำหนดความกว้าง
                                    height: 40, // กำหนดความสูง
                                    child: Image.asset(
                                        'assets/images/google.png'), // รูป google.png
                                  ),
                                ),
                                Text("Google"),
                              ],
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: SizedBox(
                                    width: 40, // กำหนดความกว้าง
                                    height: 40, // กำหนดความสูง
                                    child: Image.asset(
                                        'assets/images/facebook.png'), // รูป facebook.png
                                  ),
                                ),
                                Text("Facebook"),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
