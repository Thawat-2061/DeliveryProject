import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rider/pages/profile.dart';
import 'package:rider/pages/receiver.dart';
import 'package:rider/pages/sender.dart';


class RiEditPage extends StatefulWidget {
  const RiEditPage({super.key});

  @override
  State<RiEditPage> createState() => _RiEditPageState();
}

class _RiEditPageState extends State<RiEditPage> {
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

//-----------------------------------------------------------
  String username = 'AAAA';
  String email = '';
  String phone = '';
  String carregCtl = '';
  final ImagePicker picker = ImagePicker();
  XFile? image; // ตัวแปรเพื่อเก็บภาพที่เลือก

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Expanded(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          log(image!.path.toString());
                          setState(() {});
                        } else {
                          log('No Image');
                        }
                      },
                      child: Stack(
                        alignment: Alignment
                            .bottomRight, // จัดตำแหน่งให้ไอคอนอยู่มุมขวาล่าง
                        children: [
                          ClipOval(
                            child: (() {
                              if (image != null) {
                                // แสดงภาพที่ถูกเลือก
                                return Image.file(
                                  File(image!.path),
                                  width: 180.0, // กำหนดความกว้างของวงกลม
                                  height: 180.0, // กำหนดความสูงของวงกลม
                                  fit: BoxFit
                                      .cover, // ปรับขนาดภาพให้พอดีกับวงกลม
                                );
                              } else {
                                // แสดงภาพเริ่มต้น
                                return Image.asset(
                                  'assets/images/icon.png',
                                  width: 180.0, // กำหนดความกว้างของวงกลม
                                  height: 180.0, // กำหนดความสูงของวงกลม
                                  fit: BoxFit
                                      .cover, // ปรับขนาดภาพให้พอดีกับวงกลม
                                );
                              }
                            }()), // เรียกใช้ฟังก์ชันที่ส่งกลับ widget
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 1, bottom: 20), // ปรับระยะห่างของไอคอน
                            child: Container(
                              width: 40, // ปรับขนาดพื้นหลังให้ใหญ่ขึ้น
                              height: 40, // ปรับขนาดพื้นหลังให้ใหญ่ขึ้น
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, // ทำให้เป็นวงกลม
                                color: const Color.fromARGB(
                                    255, 242, 179, 83), // สีพื้นหลังของไอคอน
                              ),
                              child: Icon(
                                Icons.camera_alt, // ไอคอนกล้อง
                                size: 20, // ปรับขนาดของไอคอนให้เล็กลง
                                color: Colors.white, // สีของไอคอน
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      indent: 20,
                      endIndent: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, // ปรับขนาดตามหน้าจอ
                        child: Column(
                          children: [
                            SizedBox(
                              height: 60,
                              child: TextField(
                                onChanged: (value) => username =
                                    value, // เก็บค่าที่กรอกในตัวแปร username
                
                                decoration: InputDecoration(
                                  labelText:
                                      "Username", // ข้อความ "Username" ภายใน TextField
                                  labelStyle: TextStyle(
                                    color:
                                        Colors.white, // สีของข้อความ "Username"
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person, // เพิ่มไอคอนสำหรับ Username
                                    color: Colors.white, // สีของไอคอน
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                      color:
                                          Colors.white, // สีขอบเมื่อไม่ focus
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, // ปรับขนาดตามหน้าจอ
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: TextField(
                                onChanged: (value) => phone =
                                    value, // เก็บค่าที่กรอกในตัวแปร phone
                
                                decoration: InputDecoration(
                                  labelText:
                                      "Phone Number", // ข้อความ "Phone Number" ภายใน TextField
                                  labelStyle: TextStyle(
                                    color: Colors
                                        .white, // สีของข้อความ "Phone Number"
                                  ),
                                  prefixIcon: Icon(
                                    Icons
                                        .phone, // เพิ่มไอคอนสำหรับ Phone Number
                                    color: Colors.white, // สีของไอคอน
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                      color:
                                          Colors.white, // สีขอบเมื่อไม่ focus
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, // ปรับขนาดตามหน้าจอ
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: TextField(
                                onChanged: (value) => email =
                                    value, // เก็บค่าที่กรอกในตัวแปร email
                
                                decoration: InputDecoration(
                                  labelText:
                                      "Email", // ข้อความ "Email" ภายใน TextField
                                  labelStyle: TextStyle(
                                    color: Colors.white, // สีของข้อความ "Email"
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email, // เพิ่มไอคอนอีเมล
                                    color: Colors.white, // สีของไอคอน
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                      color:
                                          Colors.white, // สีขอบเมื่อไม่ focus
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, // ปรับขนาดตามหน้าจอ
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: TextField(
                                onChanged: (value) => carregCtl =
                                    value, // เก็บค่าที่กรอกในตัวแปร carregCtl
                
                                decoration: InputDecoration(
                                  labelText:
                                      "Car Registration", // ข้อความ "Your carregCtl" ภายใน TextField
                                  labelStyle: TextStyle(
                                    color: Colors
                                        .white, // สีของข้อความ "Your carregCtl"
                                  ),
                                  prefixIcon: Icon(
                                    Icons
                                        .directions_car, // เพิ่มไอคอนสำหรับที่อยู่
                                    color: Colors.white, // สีของไอคอน
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                      color:
                                          Colors.white, // สีขอบเมื่อไม่ focus
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.7, // ปรับความกว้างตามขนาดหน้าจอ
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        log('Username: $username');
                        log('Email: $email');
                        log('Phone: $phone');
                        log('Address: $carregCtl');

                        // Get.to(() => const SenderPage());
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
                            "Comfirm",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}