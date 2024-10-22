import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rider/config/config.dart';
import 'package:rider/pages/login.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

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

  TextEditingController usernameCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController passCtl = TextEditingController();
  TextEditingController conpassCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController addressCtl = TextEditingController();
  TextEditingController carregCtl = TextEditingController();
  TextEditingController positionCtl = TextEditingController();
  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  MapController mapController = MapController();

  String url = '';
  bool _showMap = false;

  void initState() {
    super.initState();
    //Configguration config = Configguration();

    Configguration.getConfig().then(
      (value) {
        log(value['apiEndpoint']);
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
                                          controller:
                                              usernameCtl, // เก็บค่าที่กรอกในตัวแปร username
                                          keyboardType: TextInputType.name,

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
                                          controller:
                                              phoneCtl, // เก็บค่าที่กรอกในตัวแปร phone
                                          keyboardType: TextInputType.phone,

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
                                                controller:
                                                    addressCtl, // เก็บค่าที่กรอกในตัวแปร address
                                                keyboardType:
                                                    TextInputType.streetAddress,

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
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8, // ปรับขนาดตามหน้าจอ
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 50,
                                                      child: TextField(
                                                        controller: positionCtl,
                                                        readOnly:
                                                            true, // Read-only เพื่อให้ผู้ใช้คลิกเลือกตำแหน่งจากแผนที่เท่านั้น
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Selected Position",
                                                          labelStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                          prefixIcon:
                                                              const Icon(
                                                                  Icons.map,
                                                                  color: Colors
                                                                      .white),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
//---------------------------------------------------------- M A P -------------------------------------
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _showMap =
                                                              !_showMap; // สลับการแสดง/ซ่อนแผนที่
                                                        });
                                                      },
                                                      child: Text(
                                                        _showMap
                                                            ? 'แสดงน้อยลง'
                                                            : 'เลือกที่อยู่ของคุณ',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .white, // สีของข้อความ
                                                          decoration: TextDecoration
                                                              .underline, // ใส่เส้นใต้ข้อความ
                                                          decorationThickness:
                                                              2.0, // ความหนาของเส้นใต้ (ปรับเปลี่ยนได้)
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    // การแสดงแผนที่ (แสดงเมื่อ _showMap == true)
                                                    Visibility(
                                                      visible: _showMap,
                                                      child: SizedBox(
                                                        height:
                                                            300, // ขนาดความสูงของแผนที่
                                                        child: FlutterMap(
                                                          mapController:
                                                              mapController,
                                                          options: MapOptions(
                                                            initialCenter:
                                                                latLng,
                                                            initialZoom: 15.0,
                                                            onTap: (tapPosition,
                                                                point) {
                                                              setState(() {
                                                                latLng =
                                                                    point; // อัปเดตตำแหน่งที่เลือก
                                                                positionCtl
                                                                        .text =
                                                                    'Lat: ${point.latitude}, Lng: ${point.longitude}'; // แสดงค่าตำแหน่งใน TextField
                                                                mapController.move(
                                                                    latLng,
                                                                    mapController
                                                                        .camera
                                                                        .zoom);
                                                              });
                                                            },
                                                          ),
                                                          children: [
                                                            TileLayer(
                                                              urlTemplate:
                                                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                              userAgentPackageName:
                                                                  'com.example.app',
                                                              maxNativeZoom: 19,
                                                            ),
                                                            MarkerLayer(
                                                              markers: [
                                                                Marker(
                                                                  point: latLng,
                                                                  width: 40,
                                                                  height: 40,
                                                                  child: const Icon(
                                                                      Icons
                                                                          .location_pin,
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
//---------------------------------------------------------- M A P -------------------------------------
                                                  ],
                                                ),
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
                                                controller:
                                                    carregCtl, // เก็บค่าที่กรอกในตัวแปร carreg
                                                keyboardType:
                                                    TextInputType.text,

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
                                          controller:
                                              emailCtl, // เก็บค่าที่กรอกในตัวแปร email
                                          keyboardType:
                                              TextInputType.emailAddress,

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
                                          controller:
                                              passCtl, // เก็บค่าที่กรอกในตัวแปร pass
                                          keyboardType:
                                              TextInputType.visiblePassword,
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
                                          controller:
                                              conpassCtl, // เก็บค่าที่กรอกในตัวแปร compass
                                          keyboardType:
                                              TextInputType.visiblePassword,
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
                                        if (_fillIndex == 0) {
                                          RegisterUser(
                                            context,
                                            usernameCtl,
                                            emailCtl,
                                            phoneCtl,
                                            addressCtl,
                                            passCtl,
                                            conpassCtl,
                                          );
                                        } else {
                                          RegisterRider(
                                              context,
                                              usernameCtl,
                                              emailCtl,
                                              phoneCtl,
                                              carregCtl,
                                              passCtl,
                                              conpassCtl);
                                        }
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

  void RegisterUser(
      BuildContext context,
      TextEditingController usernameCtl,
      TextEditingController emailCtl,
      TextEditingController phoneCtl,
      TextEditingController addressCtl,
      TextEditingController passCtl,
      TextEditingController conpassCtl) async {
    // Validate if all fields are filled
    if (usernameCtl.text.isEmpty ||
        phoneCtl.text.isEmpty ||
        addressCtl.text.isEmpty ||
        emailCtl.text.isEmpty ||
        passCtl.text.isEmpty ||
        conpassCtl.text.isEmpty) {
      log('Please fill all the fields');
      _showFlushbar(
          context, 'กรุณากรอกข้อมูลให้ครบ', 'Please fill all the fields');
      return;
    }

    // Validate passwords match
    if (passCtl.text != conpassCtl.text) {
      log('Passwords do not match');
      _showFlushbar(context, 'รหัสผ่านไม่ตรงกัน', 'Passwords do not match');
      return;
    }

    // เรียกใช้ getCoordinates เพื่อแปลงที่อยู่เป็นละติจูดและลองจิจูด
    // final coordinates = await getCoordinates(addressCtl.text);
    // log('Latitude: ${coordinates['latitude']}, Longitude: ${coordinates['longitude']}');

    // สร้างข้อมูลผู้ใช้
    Map<String, dynamic> userData = {
      'Username': usernameCtl.text,
      'Email': emailCtl.text,
      'Password': passCtl.text,
      'Phone': phoneCtl.text,
      'Image':
          "https://i.pinimg.com/736x/0d/b5/da/0db5da143c7bf4ace9d3635bd4e35fcc.jpg",
      'Address': addressCtl.text,
      'GPS_Latitude': latLng.latitude, // ใช้ค่าละติจูดที่ได้
      'GPS_Longitude': latLng.longitude, // ใช้ค่าลองจิจูดที่ได้
    };

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
      // ทำการส่ง POST request ไปยัง API
      final response = await http.post(
        Uri.parse('$url/register/user'),
        headers: {
          'Content-Type': 'application/json', // กำหนด headers ให้เป็น JSON
        },
        body: jsonEncode(userData), // แปลงข้อมูลเป็น JSON ก่อนส่ง
      );

      Navigator.of(context).pop();

      if (response.statusCode == 201) {
        log('Registration successful');
        _showFlushbar(
          context,
          'Registration Successful',
          'สมัครสมาชิคสำเร็จ!!!',
          onOkPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
        );
      } else if (response.statusCode == 409) {
        log('Username already exists');
        _showFlushbar(
            context,
            'ชื่อผู้ใช้ หรือ เบอร์มือถือ หรือ Email มีอยู่แล้ว',
            'Username already exists');
      } else {
        log('Registration failed');
        _showFlushbar(context, 'การลงทะเบียนล้มเหลว', 'Registration failed');
      }
    } catch (e) {
      // ปิด progress dialog
      Navigator.of(context).pop();
      log('Error: $e');
      _showFlushbar(
          context, 'เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์', 'Error: $e');
    }
  }

  void RegisterRider(
      BuildContext context,
      TextEditingController usernameCtl,
      TextEditingController emailCtl,
      TextEditingController phoneCtl,
      TextEditingController carregCtl,
      TextEditingController passCtl,
      TextEditingController conpassCtl) async {
    if (usernameCtl.text.isEmpty ||
        phoneCtl.text.isEmpty ||
        emailCtl.text.isEmpty ||
        carregCtl.text.isEmpty ||
        passCtl.text.isEmpty ||
        conpassCtl.text.isEmpty) {
      log('Please fill all the fields');
      _showFlushbar(
          context, 'กรุณากรอกข้อมูลให้ครบ', 'Please fill all the fields');
      return;
    }

    // Validate passwords match
    if (passCtl.text != conpassCtl.text) {
      log('Passwords do not match');
      _showFlushbar(context, 'รหัสผ่านไม่ตรงกัน', 'Passwords do not match');
      return;
    }
    Map<String, dynamic> userData = {
      'Username': usernameCtl.text,
      'Email': emailCtl.text,
      'Password': passCtl.text,
      'Phone': phoneCtl.text,
      'Image':
          "https://i.pinimg.com/736x/0d/b5/da/0db5da143c7bf4ace9d3635bd4e35fcc.jpg",
      'VehicleRegistration': carregCtl.text,
    };
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
      // ทำการส่ง POST request ไปยัง API
      final response = await http.post(
        Uri.parse('$url/register/rider'),
        headers: {
          'Content-Type': 'application/json', // กำหนด headers ให้เป็น JSON
        },
        body: jsonEncode(userData), // แปลงข้อมูลเป็น JSON ก่อนส่ง
      );

      Navigator.of(context).pop();

      if (response.statusCode == 201) {
        log('Registration successful');
        _showFlushbar(
          context,
          'Registration Successful',
          'สมัครสมาชิคสำเร็จ!!!',
          onOkPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
        );
      } else if (response.statusCode == 409) {
        log('Username already exists');
        _showFlushbar(
            context, 'ชื่อผู้ใช้นี้มีอยู่แล้ว', 'Username already exists');
      } else {
        log('Registration failed');
        _showFlushbar(context, 'การลงทะเบียนล้มเหลว', 'Registration failed');
      }
    } catch (e) {
      // ปิด progress dialog
      Navigator.of(context).pop();
      log('Error: $e');
      _showFlushbar(
          context, 'เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์', 'Error: $e');
    }
  }

  void _showFlushbar(BuildContext context, String title, String message,
      {VoidCallback? onOkPressed}) {
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
    ).show(context).then((_) {
      if (onOkPressed != null) {
        onOkPressed();
      }
    });
  }

  // Future<Map<String, double>> getCoordinates(String address) async {
  //   try {
  //     // แทนที่ช่องว่างในที่อยู่ด้วย '%20'
  //     String encodedAddress = address.replaceAll(' ', '%20');

  //     // ใช้ encoded address ในการค้นหาพิกัด
  //     List<Location> locations = await locationFromAddress(encodedAddress);
  //     return {
  //       'latitude': locations.first.latitude,
  //       'longitude': locations.first.longitude,
  //     };
  //   } catch (e) {
  //     log('Error getting coordinates: $e');
  //     return {
  //       'latitude': 0.0,
  //       'longitude': 0.0
  //     }; // ส่งค่าพิกัดผิดเมื่อเกิดข้อผิดพลาด
  //   }
  // }
}
