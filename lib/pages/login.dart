import 'dart:convert';
import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rider/config/config.dart';
import 'package:rider/pages/register.dart';
import 'package:rider/pages/rider.dart';
import 'package:rider/pages/sender.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  int selectedIndex = 0; // ตัวแปรเพื่อเก็บค่า index
  int _fillIndex = 0;
  List<dynamic>? userData;
  var userId;

  TextEditingController inputCtl = TextEditingController();
  TextEditingController passCtl = TextEditingController();

  String url = '';

  @override
  void initState() {
    super.initState();

    Configguration.getConfig().then(
      (value) {
        // log(value['apiEndpoint']);
        log('Api Login');
        setState(() {
          url = value['apiEndpoint'];
        });
      },
    ).catchError((err) {
      log(err.toString());
    });
  }

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
                  width:
                      MediaQuery.of(context).size.width, // ความกว้างเต็มหน้าจอ
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
                              controller: inputCtl, // เก็บค่าที่ผู้ใช้กรอก
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText:
                                    "Username or Email", // ข้อความ "Email" ภายใน TextField
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
                              controller: passCtl,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true, // ซ่อนรหัสผ่าน
                              decoration: InputDecoration(
                                labelText:
                                    "Password", // ข้อความ "Password" ภายใน TextField
                                labelStyle: TextStyle(
                                  color:
                                      Colors.white, // สีของข้อความ "Password"
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
                          initialLabelIndex: _fillIndex,

                          totalSwitches: 2,
                          labels: ['User', 'Rider'],
                          customTextStyles: [
                            TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold, // ตัวหนาสำหรับ 'User'
                              color: Colors.white, // สีของข้อความ
                            ),
                            TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold, // ตัวหนาสำหรับ 'Rider'
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
                          //----------------------------- จะล้างค่าให้เป็น null เมื่อสลับปุ่ม user ไป rider หรือ ไรเดอร์ ไป user --------------------------
                          // onToggle: (index) {
                          //         setState(() {
                          //              // เช็คว่าค่า index เปลี่ยนแปลงหรือไม่
                          //           if (_fillIndex != index) {
                          //             // ล้างค่าที่กรอกเมื่อเปลี่ยน index
                          //             username = '';
                          //             phone = '';
                          //             address = '';
                          //             carreg = '';
                          //             pass = '';
                          //             compass = '';
                          //             email = '';
                          //             _fillIndex = index!; // เปลี่ยน index
                          //           }
                          //         });
                          //         print('switched to: $index');
                          //       },
                          onToggle: (index) {
                            setState(() {
                              _fillIndex = index!;
                            });
                            print('switched to: $index');
                          },
                          //------------------------------------------------------------------------------------------------------------------
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
                              if (_fillIndex == 0) {
                                LoginUser(context, inputCtl, passCtl);
                              } else {
                                LoginRider(context, inputCtl, passCtl);
                              }

                              // Get.to(() => const SenderPage());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    50.0), // มุมโค้งของปุ่ม
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 214, 78, 51),
                                    Color.fromARGB(255, 233, 200, 93)
                                  ], // ไล่เฉดสีจากส้มเข้มไปอ่อน
                                  begin:
                                      Alignment.centerLeft, // เริ่มไล่จากซ้าย
                                  end: Alignment.centerRight, // ไปจบที่ขวา
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withOpacity(0.5), // สีเงา
                                    spreadRadius: 2, // การกระจายของเงา
                                    blurRadius: 5, // ความเบลอของเงา
                                    offset: Offset(2, 4), // ระยะห่างของเงา
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 175, 157, 157),
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

  void LoginUser(BuildContext context, TextEditingController inputCtl,
      TextEditingController passCtl) async {
    // แสดง Dialog ขณะรอการดำเนินการ
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // ส่งข้อมูล POST request ไปยัง API
      final response = await http.post(
        Uri.parse("$url/login/user"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode({"input": inputCtl.text}),
      );

      // ปิด Dialog เมื่อมีการตอบกลับจาก API
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final userList = jsonDecode(response.body) as List<dynamic>;

        // ตรวจสอบว่ามีผู้ใช้ในระบบหรือไม่
        if (userList.isNotEmpty) {
          final user = userList[0] as Map<String, dynamic>;

          // ตรวจสอบว่ามีฟิลด์ password และไม่เป็น null
          if (user.containsKey('Password') && user['Password'] != null) {
            final hashedPassword = user['Password'] as String;

            // ตรวจสอบรหัสผ่าน
            final passwordMatch = BCrypt.checkpw(passCtl.text, hashedPassword);

            if (passwordMatch) {
              // เก็บข้อมูลผู้ใช้ลง GetStorage
              await _storeUserData(user);

              // แสดงข้อความ Login สำเร็จ และนำผู้ใช้ไปยังหน้าหลัก
              _showFlushbar(context, 'Login successful', 'กำลังเข้าสู่ระบบ...');
              _navigateToSenderPage(context);
            } else {
              _showFlushbar(context, 'Login failed', 'Invalid password');
            }
          } else {
            // หากฟิลด์ password ไม่มีหรือเป็น null
            _showFlushbar(context, 'Login failed', 'Password not found');
          }
        } else {
          _showFlushbar(context, 'Login failed', 'User not found');
        }
      } else {
        _showFlushbar(context, 'Error', 'Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      Navigator.of(context).pop(); // ปิด Dialog กรณีเกิดข้อผิดพลาด
      _showFlushbar(context, 'Error', 'Error during login: $e');
    }
  }

  // ฟังก์ชันจัดการการเก็บข้อมูลลง GetStorage
  Future<void> _storeUserData(Map<String, dynamic> user) async {
    final storage = GetStorage();

    // ตรวจสอบว่าค่าเป็น null หรือไม่ก่อนเขียนลง storage
    await storage.write('UserID', user['UserID']?.toString() ?? '');
    await storage.write('Username', user['Username']?.toString() ?? '');
    await storage.write('Email', user['Email']?.toString() ?? '');
    await storage.write('Image', user['Image']?.toString() ?? '');
  }

// ฟังก์ชันนำผู้ใช้ไปยังหน้า SenderPage
  void _navigateToSenderPage(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SenderPage()),
      );
    });
  }

  void LoginRider(BuildContext context, TextEditingController inputCtl,
      TextEditingController passCtl) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final response = await http.post(
        Uri.parse("$url/login/rider"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode({"input": inputCtl.text}),
      );

      if (response.statusCode == 200) {
        final riderList = jsonDecode(response.body) as List<dynamic>;

        if (riderList.isNotEmpty) {
          final rider = riderList[0] as Map<String, dynamic>;
          final hashedPassword = rider['Password'] as String;

          final passwordMatch = BCrypt.checkpw(passCtl.text, hashedPassword);

          if (passwordMatch) {
            final storage = GetStorage();
            await storage.write('RiderID', rider['RiderID'].toString());
            await storage.write('Username', rider['Username'].toString());
            await storage.write('Email', rider['Email'].toString());

            Navigator.of(context).pop();

            _showFlushbar(context, 'Login successful', 'กำลังเข้าสู่ระบบ...');

            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const RiderPage()),
              );
            });
          } else {
            print('Login failed: invalid password');
            Navigator.of(context).pop();
            _showFlushbar(context, 'Login failed', 'Invalid password');
          }
        } else {
          print('Login failed: user not found');
          Navigator.of(context).pop();
          _showFlushbar(context, 'Login failed', 'Rider not found');
        }
      } else if (response.statusCode == 404) {
        print('Login failed: user not found');
        Navigator.of(context).pop();
        _showFlushbar(context, 'Login failed', 'Rider not found');
      } else {
        print('Error: ${response.reasonPhrase}');
        Navigator.of(context).pop();
        _showFlushbar(context, 'Error', 'Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      Navigator.of(context).pop();
      print('Error during login: $e');
      _showFlushbar(context, 'Error', 'Error: $e');
    }
  }

  void _showFlushbar(BuildContext context, String title, String message) {
    Flushbar(
      title: title,
      message: message,
      backgroundGradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 124, 209, 145),
          Color.fromARGB(255, 4, 169, 152)
        ],
      ),
      backgroundColor: Colors.red,
      boxShadows: const [
        BoxShadow(
            color: Color.fromRGBO(25, 105, 196, 1),
            offset: Offset(0.0, 2.0),
            blurRadius: 5.0)
      ],
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8.0),
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
        size: 28.0,
      ),
    ).show(context);
  }
}
