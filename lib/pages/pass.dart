import 'dart:convert';
import 'dart:developer';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rider/config/config.dart';
import 'package:rider/pages/profile.dart';
import 'package:rider/pages/receiver.dart';
import 'package:rider/pages/riprofile.dart';
import 'package:rider/pages/sender.dart';
import 'package:http/http.dart' as http;

class PassPage extends StatefulWidget {
  const PassPage({super.key});

  @override
  State<PassPage> createState() => _PassPageState();
}

class _PassPageState extends State<PassPage> {
  //-----------------------------------------------------------
  int _selectedIndex = 2;
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

//-----------------------------------------------------------\

  TextEditingController oldpassCtl = TextEditingController();
  TextEditingController passCtl = TextEditingController();
  TextEditingController conpassCtl = TextEditingController();
  bool _isObscured = true; // สถานะซ่อนรหัสผ่าน
  var userId;
  var userPass;
  String url = '';

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
        title: Text('Back'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create new password',
                  style: TextStyle(fontSize: 30),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Your new password must be different from previous used passwords.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: oldpassCtl, // เก็บค่าที่กรอกในตัวแปร pass
                        keyboardType: TextInputType.visiblePassword,
                        obscureText:
                            _isObscured, // ซ่อนข้อความที่กรอกตามสถานะ _isObscured
                        decoration: InputDecoration(
                          labelText:
                              "Old Password", // ข้อความ "Password" ภายใน TextField
                          labelStyle: TextStyle(
                            color: Colors.white, // สีของข้อความ "Password"
                          ),
                          prefixIcon: Icon(
                            Icons.lock, // เพิ่มไอคอนแม่กุญแจ
                            color: Colors.white, // สีของไอคอน
                          ),
                          //------------------ซ่อนรหัส----------------------------------------------------
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured
                                  ? Icons
                                      .visibility_off // ไอคอนปิดตาเมื่อซ่อนรหัสผ่าน
                                  : Icons
                                      .visibility, // ไอคอนเปิดตาเมื่อแสดงรหัสผ่าน
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured =
                                    !_isObscured; // เปลี่ยนสถานะซ่อน/แสดงรหัสผ่าน
                              });
                            },
                          ),
                          //----------------------------------------------------------------------
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                        style:
                            TextStyle(color: Colors.white), // สีข้อความที่กรอก
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Confirm Your Older Password',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: passCtl, // เก็บค่าที่กรอกในตัวแปร pass
                        keyboardType: TextInputType.visiblePassword,
                        obscureText:
                            _isObscured, // ซ่อนข้อความที่กรอกตามสถานะ _isObscured
                        decoration: InputDecoration(
                          labelText:
                              "Password", // ข้อความ "Password" ภายใน TextField
                          labelStyle: TextStyle(
                            color: Colors.white, // สีของข้อความ "Password"
                          ),
                          prefixIcon: Icon(
                            Icons.lock, // เพิ่มไอคอนแม่กุญแจ
                            color: Colors.white, // สีของไอคอน
                          ),
                          //------------------ซ่อนรหัส----------------------------------------------------
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured
                                  ? Icons
                                      .visibility_off // ไอคอนปิดตาเมื่อซ่อนรหัสผ่าน
                                  : Icons
                                      .visibility, // ไอคอนเปิดตาเมื่อแสดงรหัสผ่าน
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured =
                                    !_isObscured; // เปลี่ยนสถานะซ่อน/แสดงรหัสผ่าน
                              });
                            },
                          ),
                          //----------------------------------------------------------------------
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                        style:
                            TextStyle(color: Colors.white), // สีข้อความที่กรอก
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Must be at least 999 Characters.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: conpassCtl, // เก็บค่าที่กรอกในตัวแปร pass
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true, // ซ่อนข้อความที่กรอก
                        decoration: InputDecoration(
                          labelText:
                              "Comfirm password", // ข้อความ "Password" ภายใน TextField
                          labelStyle: TextStyle(
                            color: Colors.white, // สีของข้อความ "Password"
                          ),
                          prefixIcon: Icon(
                            Icons.lock, // เพิ่มไอคอนแม่กุญแจ
                            color: Colors.white, // สีของไอคอน
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                        style:
                            TextStyle(color: Colors.white), // สีข้อความที่กรอก
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Bath passwords must match.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            _showConfirmationDialog(context);
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
                                  spreadRadius: 1, // การกระจายของเงา
                                  blurRadius: 5, // ความเบลอของเงา
                                  offset: Offset(2, 2), // ระยะห่างของเงา
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Confirm",
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16), // ทำให้มุมของ dialog โค้งมน
          ),
          title: Text(
            'Confirm Password Change',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20, // ขนาดตัวอักษร
                color: Colors.white),
          ),
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.amber), // เพิ่มไอคอนเตือน
              SizedBox(width: 10), // ช่องว่างระหว่างไอคอนและข้อความ
              Expanded(
                child: Text(
                  'Are you sure you want to change your password?',
                  style: TextStyle(
                      fontSize: 16, color: Colors.grey), // ขนาดตัวอักษร
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // ปิด dialog
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white), // สีข้อความเป็นสีแดง
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      passChange(context, oldpassCtl, passCtl, conpassCtl);

                      // ปิด dialog และไปที่หน้าถัดไป
                      Navigator.of(context).pop(); // ปิด dialog
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.deepOrangeAccent, // สีพื้นหลังของ Container
                        borderRadius: BorderRadius.circular(
                            24.0), // กำหนดความโค้งของ Container
                      ),
                      padding: const EdgeInsets.all(
                          16.0), // เพิ่มระยะห่างภายใน Container
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                            color: Colors.white), // สีข้อความเป็นสีขาว
                      ),
                    )),
              ],
            ),
          ],
        );
      },
    );
  }

  void passChange(BuildContext context, TextEditingController oldpassCtl,
      TextEditingController passCtl, TextEditingController conpassCtl) async {
    // Validate if all fields are filled
    if (oldpassCtl.text.isEmpty ||
        passCtl.text.isEmpty ||
        conpassCtl.text.isEmpty) {
      log('Please fill all the fields');
      return; // Exit if any field is empty
    }

    // Check if the old password matches the stored password
    final passwordMatch = BCrypt.checkpw(oldpassCtl.text, userPass);
    log('Password match: $passwordMatch');
    if (!passwordMatch) {
      log("Old password does not match the stored password");
      return; // Exit if the password does not match
    }

    // Validate if new passwords match
    if (passCtl.text != conpassCtl.text) {
      log("New passwords do not match");
      return; // Exit if new passwords do not match
    }
    _showLoadingDialog();

    try {
      // Send PUT request to the API
      log('Sending PUT request...');
      final response = await http.put(
        Uri.parse("$url/login/passUser"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode({"UserID": userId, "Password": passCtl.text}),
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        log('Password changed successfully!');
        // final storage = GetStorage();
        // await storage.write('UserPassword', passCtl.text.toString());
        // await getUserDataFromStorage();
        await Get.to(() => const ProfilePage()); // Navigate to the next page

        // Check if the widget is still mounted before navigating
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully!')),
        );
      } else if (response.statusCode == 409) {
        log('Username already exists');
      } else {
        log('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('An error occurred: $e'); // Log any errors that occur during the request
    }
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
    final userPass = storage.read('UserPassword');
    // final userEmail = storage.read('Email');
    // final userImage = storage.read('Image');

    // log(userUsername);

    setState(() {
      this.userId = userId;
      this.userPass = userPass;
      // this.userEmail = userEmail;
      // this.userImage = userImage;
      // log(userId);
    });
  }

  void _showLoadingDialog() {
    // โลหด
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิด dialog โดยคลิกที่ด้านนอก
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // พื้นหลังโปร่งใส
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // แสดงวงกลมหมุน
              SizedBox(height: 15),
              Text("Loading...", style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );
  }
}
