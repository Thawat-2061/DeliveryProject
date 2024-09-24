import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rider/pages/login.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:geolocator/geolocator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String username = '';
  String phone = '';
  String address = '';
  String carreg = '';
  String pass = '';
  String compass = '';
  String email = '';
  int selectedIndex = 0; // ตัวแปรเพื่อเก็บค่า index
  int _fillIndex = 0; // กำหนดค่าเริ่มต้น
  final ImagePicker picker = ImagePicker();
  XFile? image; // ตัวแปรเพื่อเก็บภาพที่เลือก

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF171716),
      ),
      backgroundColor: Color(0xFF171716),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/moto.png'),
              fit: BoxFit.cover, // ปรับขนาดของภาพให้พอดีกับ Container
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // วงกลมที่มีไอคอนกล้องถ่ายรูปตรงกลาง
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
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(100.0), // กำหนดความโค้งของมุม
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFFA726),
                            Color(0xFFD67A33),
                          ], // สีที่ต้องการไล่เฉด
                          begin: Alignment.topLeft, // เริ่มจากมุมซ้ายบน
                          end: Alignment.bottomRight, // จบที่มุมขวาล่าง
                        ),
                      ),
                      child: (image != null)
                          ? ClipOval(
                              child: Image.file(
                                File(image!.path),
                                width: 150.0, // กำหนดความกว้างของวงกลม
                                height: 150.0, // กำหนดความสูงของวงกลม
                                fit: BoxFit.cover, // ปรับขนาดภาพให้พอดีกับวงกลม
                              ),
                            )
                          : Icon(
                              Icons.camera_alt_outlined, // ไอคอนกล้องถ่ายรูป
                              size: 80, // ขนาดของไอคอน
                              color: Colors.black, // สีของไอคอน
                            ),
                    ),
                  ),

                  SizedBox(height: 16), // เว้นระยะห่างระหว่างวงกลมกับการ์ด

                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(30.0), // กำหนดความโค้งของมุม
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFFA726),
                          Color(0xFFD67A33),
                        ], // สีที่ต้องการไล่เฉด
                        begin: Alignment.topLeft, // เริ่มจากมุมซ้ายบน
                        end: Alignment.bottomRight, // จบที่มุมขวาล่าง
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                          16.0), // กำหนดระยะ padding ของการ์ด
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: Colors.white, width: 2.0), // กำหนดกรอบสีขาวและความหนา
                                      borderRadius: BorderRadius.circular(
                                          35.0), // มุมโค้งให้เข้ากับ ToggleSwitch
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(0.8), // สีเงา
                                          blurRadius: 5.0, // ความเบลอของเงา
                                          spreadRadius: 0.2, // ความกว้างของเงา
                                          offset: Offset(
                                              1, 3), // การเลื่อนเงาในแนวแกน Y
                                        ),
                                      ],
                                    ),
                                    child: ToggleSwitch(
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
                                          fontWeight: FontWeight
                                              .bold, // ตัวหนาสำหรับ 'User'
                                          color: Colors.white, // สีของข้อความ
                                        ),
                                        TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight
                                              .bold, // ตัวหนาสำหรับ 'Rider'
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
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.8, // ปรับขนาดตามหน้าจอ
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: TextField(
                                          onChanged: (value) => username =
                                              value, // เก็บค่าที่กรอกในตัวแปร username

                                          decoration: InputDecoration(
                                            labelText:
                                                "Username", // ข้อความ "Username" ภายใน TextField
                                            labelStyle: TextStyle(
                                              color: Colors
                                                  .white, // สีของข้อความ "Username"
                                            ),
                                            prefixIcon: Icon(
                                              Icons
                                                  .person, // เพิ่มไอคอนสำหรับ Username
                                              color: Colors.white, // สีของไอคอน
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .white, // สีขอบเมื่อไม่ focus
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .white, // สีขอบเมื่อ focus
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                              color: Colors
                                                  .white), // สีข้อความที่กรอก
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
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
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .white, // สีขอบเมื่อไม่ focus
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .white, // สีขอบเมื่อ focus
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                              color: Colors
                                                  .white), // สีข้อความที่กรอก
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.8, // ปรับขนาดตามหน้าจอ
                                  //-------------------------------------------------------------------------------------------------
                                  child: Column(
                                    children: [
                                      Visibility(
                                        visible: _fillIndex == 0,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              child: TextField(
                                                onChanged: (value) => address =
                                                    value, // เก็บค่าที่กรอกในตัวแปร address

                                                decoration: InputDecoration(
                                                  labelText:
                                                      "Your Address", // ข้อความ "Your Address" ภายใน TextField
                                                  labelStyle: TextStyle(
                                                    color: Colors
                                                        .white, // สีของข้อความ "Your Address"
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons
                                                        .location_on, // เพิ่มไอคอนสำหรับที่อยู่
                                                    color: Colors
                                                        .white, // สีของไอคอน
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    borderSide: BorderSide(
                                                      color: Colors
                                                          .white, // สีขอบเมื่อไม่ focus
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    borderSide: BorderSide(
                                                      color: Colors
                                                          .white, // สีขอบเมื่อ focus
                                                    ),
                                                  ),
                                                ),
                                                style: TextStyle(
                                                    color: Colors
                                                        .white), // สีข้อความที่กรอก
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //-------------------------------------------------------------------------------------------------
                                      Visibility(
                                        visible: _fillIndex == 1,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              child: TextField(
                                                onChanged: (value) => carreg =
                                                    value, // เก็บค่าที่กรอกในตัวแปร carreg

                                                decoration: InputDecoration(
                                                  labelText:
                                                      "Car Registration", // ข้อความ "Car Registration" ภายใน TextField
                                                  labelStyle: TextStyle(
                                                    color: Colors
                                                        .white, // สีของข้อความ "Car Registration"
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons
                                                        .directions_car, // เพิ่มไอคอนรถยนต์
                                                    color: Colors
                                                        .white, // สีของไอคอน
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    borderSide: BorderSide(
                                                      color: Colors
                                                          .white, // สีขอบเมื่อไม่ focus
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    borderSide: BorderSide(
                                                      color: Colors
                                                          .white, // สีขอบเมื่อ focus
                                                    ),
                                                  ),
                                                ),
                                                style: TextStyle(
                                                    color: Colors
                                                        .white), // สีข้อความที่กรอก
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //-------------------------------------------------------------------------------------------------
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
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
                                              color: Colors
                                                  .white, // สีของข้อความ "Email"
                                            ),
                                            prefixIcon: Icon(
                                              Icons.email, // เพิ่มไอคอนอีเมล
                                              color: Colors.white, // สีของไอคอน
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .white, // สีขอบเมื่อไม่ focus
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .white, // สีขอบเมื่อ focus
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                              color: Colors
                                                  .white), // สีข้อความที่กรอก
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.8, // ปรับขนาดตามหน้าจอ
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: TextField(
                                          onChanged: (value) => pass =
                                              value, // เก็บค่าที่กรอกในตัวแปร pass
                                          obscureText:
                                              true, // ซ่อนข้อความที่กรอก
                                          decoration: InputDecoration(
                                            labelText:
                                                "Password", // ข้อความ "Password" ภายใน TextField
                                            labelStyle: TextStyle(
                                              color: Colors
                                                  .white, // สีของข้อความ "Password"
                                            ),
                                            prefixIcon: Icon(
                                              Icons.lock, // เพิ่มไอคอนแม่กุญแจ
                                              color: Colors.white, // สีของไอคอน
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .white, // สีขอบเมื่อไม่ focus
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .white, // สีขอบเมื่อ focus
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                              color: Colors
                                                  .white), // สีข้อความที่กรอก
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.8, // ปรับขนาดตามหน้าจอ
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: TextField(
                                          onChanged: (value) => compass =
                                              value, // เก็บค่าที่กรอกในตัวแปร compass
                                          obscureText:
                                              true, // ซ่อนข้อความที่กรอก
                                          decoration: InputDecoration(
                                            labelText:
                                                "Confirm Password", // ข้อความ "Confirm Password" ภายใน TextField
                                            labelStyle: TextStyle(
                                              color: Colors
                                                  .white, // สีของข้อความ "Confirm Password"
                                            ),
                                            prefixIcon: Icon(
                                              Icons.lock, // เพิ่มไอคอนแม่กุญแจ
                                              color: Colors.white, // สีของไอคอน
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .white, // สีขอบเมื่อไม่ focus
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .white, // สีขอบเมื่อ focus
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                              color: Colors
                                                  .white), // สีข้อความที่กรอก
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.3, // ปรับความกว้างตามขนาดหน้าจอ
                                    height: 50,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => const LoginPage());
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              50.0), // มุมโค้งของปุ่ม
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 88, 77, 77),
                                              Color.fromARGB(255, 125, 90, 78)
                                            ], // ไล่เฉดสีจากส้มเข้มไปอ่อน
                                            begin: Alignment
                                                .centerLeft, // เริ่มไล่จากซ้าย
                                            end: Alignment
                                                .centerRight, // ไปจบที่ขวา
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.5), // สีเงา
                                              spreadRadius:
                                                  1, // การกระจายของเงา
                                              blurRadius: 5, // ความเบลอของเงา
                                              offset: Offset(
                                                  2, 2), // ระยะห่างของเงา
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Back",
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
                              SizedBox(
                                width: 0,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.4, // ปรับความกว้างตามขนาดหน้าจอ
                                    height: 50,
                                    child: GestureDetector(
                                      onTap: () {
                                        log('---------------------------------------');
                                        log('Username: $username');
                                        log('Phone: $phone');
                                        log('Address: $address');
                                        log('Car Registration: $carreg');
                                        log('Email: $email');
                                        log('pass: $pass');
                                        log('compass: $compass');
                                        log('Selected Index: $selectedIndex'); // Log ค่า index

                                        Register();
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
                                            begin: Alignment
                                                .centerLeft, // เริ่มไล่จากซ้าย
                                            end: Alignment
                                                .centerRight, // ไปจบที่ขวา
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.5), // สีเงา
                                              spreadRadius:
                                                  1, // การกระจายของเงา
                                              blurRadius: 5, // ความเบลอของเงา
                                              offset: Offset(
                                                  2, 2), // ระยะห่างของเงา
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void Register() async {
    var postion = await _determinePosition();
    log('${postion.latitude} ${postion.longitude}');
    log('${postion}');
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
