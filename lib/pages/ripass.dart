import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:rider/pages/rider.dart';
import 'package:rider/pages/ridergps.dart';
import 'package:rider/pages/riprofile.dart';

class RiPassPage extends StatefulWidget {
  const RiPassPage({super.key});

  @override
  State<RiPassPage> createState() => _RiPassPageState();
}

class _RiPassPageState extends State<RiPassPage> {
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
        Get.to(() => const RiProPage());
        break;
      // เพิ่มกรณีอื่นๆ สำหรับการนำทางไปยังหน้าอื่นๆ ที่นี่
    }
  }

//-----------------------------------------------------------
  TextEditingController passCtl = TextEditingController();
  TextEditingController compassCtl = TextEditingController();
  bool _isObscured = true; // สถานะซ่อนรหัสผ่าน

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back'),
      ),
      body: Container(
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
                      style: TextStyle(color: Colors.white), // สีข้อความที่กรอก
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
                      controller: compassCtl, // เก็บค่าที่กรอกในตัวแปร pass
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
                      style: TextStyle(color: Colors.white), // สีข้อความที่กรอก
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
                    onPressed: () {
                      // ปิด dialog และไปที่หน้าถัดไป
                      Navigator.of(context).pop(); // ปิด dialog
                      Get.to(() => const RiProPage()); // เปลี่ยนไปที่หน้าถัดไป
                      log('Password: ' + passCtl.text);
                      log('Comfirmppass ' + compassCtl.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Password changed successfully!')),
                      );
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
}
