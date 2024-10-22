import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:rider/config/config.dart';
// import 'package:rider/model/respon/UserGetRespon.dart';
import 'package:rider/model/response/UserGetRes.dart';

import 'package:rider/pages/profile.dart';
import 'package:rider/pages/receiver.dart';
import 'package:rider/pages/sender.dart';
import 'package:http/http.dart' as http;

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  //-----------------------------------------------------------
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
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
  TextEditingController productnameController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  var customerId;

  String? selectedUserName;
  String? selectedUserPhone;
  String? selectedUserAddress;
  double? selectedUserLatitude;
  double? selectedUserLongitude;
  LatLng get latLng =>
      LatLng(selectedUserLatitude ?? 0.0, selectedUserLongitude ?? 0.0);
  MapController mapController = MapController();
  bool _showMap = false;
  var userID;
  var userImage;
  var orderImage;
//-----------------------------------------------------------

  final ImagePicker picker = ImagePicker();
  File? image;
//-----------------------------------------------------------

  List<UserGetRespon> UserGetResponses = [];

  TextEditingController searchController = TextEditingController();
  List<UserGetRespon> filteredUsers =
      []; // สร้าง List สำหรับเก็บข้อมูลที่กรองแล้ว
  // List<UserGetRespon> allUsers = UserGetResponses;

  String detail = '';
  String name = '';
  String url = '';

  @override
  void initState() {
    super.initState();
    _initialize();
    filteredUsers = UserGetResponses;
    phoneController.addListener(() {
      filterUsers(phoneController
          .text); // เรียกฟังก์ชันกรองเมื่อมีการเปลี่ยนแปลงใน TextField
    });
  }

  Future<void> _initialize() async {
    await GetApiEndpoint();

    await getUserDataFromStorage();
  }

  void filterUsers(String searchQuery) {
    setState(() {
      // กรองเฉพาะเมื่อมีข้อความในช่องค้นหา
      if (searchQuery.isEmpty) {
        filteredUsers =
            UserGetResponses; // ถ้าไม่มีการค้นหา ให้แสดงผู้ใช้ทั้งหมด
      } else {
        filteredUsers = UserGetResponses.where((user) =>
                user.phone.contains(searchQuery)) // กรองข้อมูลตามเบอร์โทรศัพท์
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Order',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF171716),
      ),
      backgroundColor: Color(0xFFD67A33),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/moto.png'),
              fit: BoxFit.cover, // ปรับขนาดของภาพให้พอดีกับ Container
            ),
          ),
          child: Center(
            child: Column(
              children: [
                //-----------------------------------------camera--------------------------------
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (image != null) {
                          // ถ้ามีรูปภาพแล้ว ให้แสดงตัวเลือกว่าจะดูภาพเต็มหรือเปลี่ยนภาพ
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Wrap(
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.fullscreen),
                                    title: Text('ดูภาพเต็ม'),
                                    onTap: () {
                                      Navigator.pop(
                                          context); // ปิด Bottom Sheet
                                      _showFullImage(
                                          context, image!); // แสดงภาพเต็ม
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.image),
                                    title: Text('เปลี่ยนรูป'),
                                    onTap: () {
                                      Navigator.pop(
                                          context); // ปิด Bottom Sheet
                                      _pickImage(); // เลือกรูปภาพใหม่
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // ถ้าไม่มีรูปภาพ ให้เปิดฟังก์ชันเลือกภาพ
                          _pickImage();
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10.0), // แสดงเป็นสี่เหลี่ยมมุมโค้ง
                        child: image != null
                            ? Image.file(
                                image!,
                                width: 180.0,
                                height: 180.0,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.add_photo_alternate,
                                size: 150,
                              ),
                      ),
                    ),
                    Text(
                      "Add Photo",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
                //-----------------------------------------camera--------------------------------
                Card(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25,
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
                                  controller:
                                      productnameController, // เก็บค่าที่กรอกในตัวแปร username
                                  decoration: InputDecoration(
                                    labelText: "Product Name",
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.label,
                                      color: Colors.white,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: detailController,
                                  decoration: InputDecoration(
                                    labelText: "Product details",
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.info,
                                      color: Colors.white,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<String>.empty();
                                  }
                                  // ใช้หมายเลขโทรศัพท์จาก UserGetResponses
                                  return UserGetResponses.where((user) => user
                                          .phone
                                          .contains(textEditingValue.text))
                                      .map((user) => user.phone);
                                },
                                onSelected: (String selectedNumber) {
                                  setState(() {
                                    // ค้นหาชื่อผู้ใช้ที่ตรงกับหมายเลขโทรศัพท์ที่เลือก
                                    final selectedUser =
                                        UserGetResponses.firstWhere((user) =>
                                            user.phone == selectedNumber);

                                    // ตั้งค่าฟิลด์ต่าง ๆ หลังจากเลือกเบอร์
                                    usernameController.text =
                                        selectedUser.username;
                                    addressController.text =
                                        selectedUser.address; // เพิ่ม Address
                                    selectedUserLatitude = selectedUser
                                        .gpsLatitude; // เพิ่ม Latitude
                                    selectedUserLongitude = selectedUser
                                        .gpsLongitude; // เพิ่ม Longitude

                                    // อัปเดตตำแหน่งบนแผนที่ (ถ้ามี)
                                    mapController.move(
                                        LatLng(selectedUserLatitude!,
                                            selectedUserLongitude!),
                                        mapController.camera.zoom);
                                  });
                                },
                                fieldViewBuilder: (context, controller,
                                    focusNode, onFieldSubmitted) {
                                  TextEditingController controllerToUse =
                                      selectedUserPhone != null &&
                                              selectedUserPhone!.isNotEmpty
                                          ? controller
                                          : phoneController; // ใช้ controllerToUse ตามเงื่อนไขที่ต้องการ

                                  return TextField(
                                    controller:
                                        controllerToUse, // ใช้ controllerToUse
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      labelText: "Phone Customer",
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Customer name",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.deepOrangeAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Text(
                                          selectedUserName != null &&
                                                  selectedUserName!.isNotEmpty
                                              ? ' $selectedUserName' // ถ้ามีชื่อผู้ใช้
                                              : usernameController
                                                      .text.isNotEmpty
                                                  ? usernameController
                                                      .text // ถ้าไม่มี ให้ใช้ค่าจาก controller
                                                  : 'Choose customer number', // ถ้า controller ว่างก็แสดงข้อความนี้
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: selectedUserName != null &&
                                                    selectedUserName!.isNotEmpty
                                                ? Colors
                                                    .white // สีเมื่อมีชื่อผู้ใช้
                                                : Colors
                                                    .grey, // สีเมื่อไม่มีผู้ใช้
                                          ),
                                        ),
                                      ),

                                      const Divider(
                                        color: Colors.grey,
                                        thickness: 1.0,
                                      ),

                                      SizedBox(height: 5),

                                      Row(
                                        children: [
                                          Text(
                                            "Customer address",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.deepOrangeAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Text(
                                          selectedUserAddress != null &&
                                                  selectedUserAddress!
                                                      .isNotEmpty
                                              ? ' $selectedUserAddress' // ถ้ามีที่อยู่
                                              : addressController
                                                      .text.isNotEmpty
                                                  ? addressController
                                                      .text // ถ้าไม่มี ให้ใช้ค่าจาก controller
                                                  : 'No address available', // ถ้า controller ว่างก็แสดงข้อความนี้
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: selectedUserAddress !=
                                                        null &&
                                                    selectedUserAddress!
                                                        .isNotEmpty
                                                ? Colors
                                                    .white // สีเมื่อมีที่อยู่
                                                : Colors
                                                    .grey, // สีเมื่อไม่มีที่อยู่
                                          ),
                                        ),
                                      ),

                                      const Divider(
                                        color: Colors.grey,
                                        thickness: 1.0,
                                      ),
                                      SizedBox(height: 10),
//--------------------------------------------------------MAP---------------------------------------
                                      Column(
                                        children: [
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
                                                  : 'Address Receiver',
                                              style: TextStyle(
                                                color: Colors
                                                    .white, // สีของข้อความ
                                                decoration: TextDecoration
                                                    .underline, // ใส่เส้นใต้ข้อความ
                                                decorationThickness:
                                                    2.0, // ความหนาของเส้นใต้
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          _showMap // ตรวจสอบว่าจะแสดงแผนที่หรือไม่
                                              ? Container(
                                                  width: double.infinity,
                                                  height: 400,
                                                  child: FlutterMap(
                                                    mapController:
                                                        mapController,
                                                    options: MapOptions(
                                                      initialCenter: latLng,
                                                      initialZoom: 15.0,
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
                                                            child: SizedBox(
                                                              width: 40,
                                                              height: 40,
                                                              child: Icon(
                                                                  Icons
                                                                      .motorcycle_sharp,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(), // ถ้าไม่ต้องการแสดงแผนที่ให้แสดง Container ว่าง
                                        ],
                                      ),
//--------------------------------------------------------MAP---------------------------------------
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 50,
                            child: GestureDetector(
                              onTap: () {
                                log('Product n: $productnameController');
                                log('Product d: $detailController');
                                log('Username: $usernameController');
                                createOrder(context, productnameController,
                                    detailController);
                                // Get.to(() => const SenderPage());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 214, 78, 51),
                                      Color.fromARGB(255, 233, 200, 93),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(2, 4),
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
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight, // จัดชิดขวา
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.5, // ขนาดความกว้าง 50% ของหน้าจอ
                    child: Padding(
                      padding: const EdgeInsets.only(right: 22),
                      child: TextField(
                        controller:
                            phoneController, // ตัวควบคุมสำหรับ TextField
                        decoration: InputDecoration(
                          labelText: "ค้นหาด้วยเบอร์", // ตั้งชื่อช่องค้นหา
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          prefixIcon: Icon(
                            Icons.search, // ใช้ไอคอนค้นหา
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        style: TextStyle(color: Colors.white), // สีของข้อความ
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10), // เว้นช่องว่างเล็กน้อย
                // แสดงข้อมูลผู้ใช้ที่กรองแล้ว
                Column(
                  children: filteredUsers.asMap().entries.map((entry) {
                    int index = entry.key; // ดึงลำดับ index ของแต่ละรายการ
                    var user = entry.value; // ดึงข้อมูลของ user

                    return SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.9, // ปรับขนาดตามหน้าจอ
                      child: GestureDetector(
                        onTap: () {
                          log('User: ${user.username}');
                          log('Phone: ${user.phone}');
                          log('Address: ${user.address}');
                          setState(() {
                            usernameController.text = user
                                .username; // กรอกข้อมูลอัตโนมัติในช่อง username
                            phoneController.text =
                                user.phone; // กรอกข้อมูลอัตโนมัติในช่อง phone
                            addressController.text = user
                                .address; // กรอกข้อมูลอัตโนมัติในช่อง address
                            customerId = user.userId;
                            selectedUserLatitude = user.gpsLatitude;
                            selectedUserLongitude = user.gpsLongitude;
                          });
                          mapController.move(latLng, mapController.camera.zoom);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // ชิดซ้าย
                              children: [
                                Container(
                                  child: CircleAvatar(
                                    radius: 30.0, // ขนาดของรูปภาพ
                                    backgroundImage: NetworkImage(
                                        user.image), // URL ของรูปภาพ
                                    backgroundColor: Colors
                                        .grey[200], // สีพื้นหลังถ้าไม่มีรูปภาพ
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        10), // เว้นช่องว่างระหว่างรูปภาพกับข้อความ
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // ชิดซ้าย
                                    children: [
                                      Text('Name: ${user.username}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          height: 5), // เว้นช่องว่างเล็กน้อย
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Phone: ${user.phone}',
                                              style: TextStyle(fontSize: 14)),
                                          Text('${index + 1}',
                                              style: TextStyle(
                                                  fontSize:
                                                      14)), // แสดงหมายเลขลำดับ
                                        ],
                                      ),
                                      SizedBox(
                                          height: 5), // เว้นช่องว่างเล็กน้อย
                                      Text('Address: ${user.address}',
                                          style: TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
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

  Future<void> _pickImage() async {
    // แสดงตัวเลือกให้ผู้ใช้เลือกระหว่างกล้องและแกลอรี่
    showModalBottomSheet(
      context: context, // ใช้ BuildContext ที่ถูกต้องจาก Flutter
      builder: (BuildContext modalContext) {
        // เปลี่ยนชื่อที่นี่
        return Container(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(modalContext).pop(); // ปิด modal
                  await _selectImage(ImageSource.camera); // เลือกภาพจากกล้อง
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(modalContext).pop(); // ปิด modal
                  await _selectImage(ImageSource.gallery); // เลือกภาพจากแกลอรี่
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> fetchUsers() async {
    // แสดง dialog โหลดข้อมูล
    _showLoadingDialog();

    try {
      final res = await http.get(
        Uri.parse("$url/user/$userID"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (res.statusCode == 200) {
        // ตรวจสอบว่า API ส่งกลับสถานะ 200 หรือไม่
        setState(() {
          UserGetResponses = userGetResponFromJson(res.body);
        });
      } else {
        log("Failed to load users: ${res.statusCode}");
      }

      final data = json.decode(res.body);
      // log(res.body);
    } catch (e) {
      log("Error: $e");
    } finally {
      // ปิด Dialog หลังจากโหลดข้อมูลเสร็จ
      Navigator.of(context).pop();
    }
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

  void _showImageDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // สามารถกดที่พื้นหลังเพื่อปิด dialog ได้
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent, // ตั้งค่าพื้นหลังให้โปร่งใส
          contentPadding: EdgeInsets.all(10),
          content: (image != null)
              ? Image.file(File(image!.path))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No image selected!!!",
                      style:
                          TextStyle(fontSize: 20, color: Colors.orangeAccent),
                    ),
                  ],
                ),
          actions: [],
        );
      },
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
    // final userUsername = storage.read('Username');
    // final userEmail = storage.read('Email');
    final userImage = storage.read('Image');
    final orderImage = storage.read('orderImage');

    // log(userUsername);

    setState(() {
      this.userID = userId;
      // this.userUsername = userUsername;
      // this.userEmail = userEmail;
      this.userImage = userImage;
      this.orderImage = orderImage;
      // log(userId);
    });
    await fetchUsers();
  }

  Future<void> createOrder(
      BuildContext context,
      TextEditingController productnameController,
      TextEditingController detailController) async {
    await _uploadFile();

    Map<String, dynamic> orderData = {
      'SenderID': userID,
      'ReceiverID': customerId,
      'Name': productnameController.text,
      'Detail': detailController.text,
      'Status': 'รอไรเดอร์',
      'Image': orderImage,
    };
    try {
      // ทำการส่ง POST request ไปยัง API
      final response = await http.post(
        Uri.parse('$url/order'),
        headers: {
          'Content-Type': 'application/json', // กำหนด headers ให้เป็น JSON
        },
        body: jsonEncode(orderData), // แปลงข้อมูลเป็น JSON ก่อนส่ง
      );

      Navigator.of(context).pop();
    } catch (e) {
      // ปิด progress dialog

      log('Error: $e');
      log('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์');
    }
  }

  Future<void> _uploadFile() async {
    if (image == null) {
      print('No file selected!');
      return;
    }

    try {
      // สร้าง MultipartRequest โดยใช้ $url
      var request =
          http.MultipartRequest('POST', Uri.parse("$url/upload/order"));
      // String fileName = path.basename(image!.path);

      // เพิ่มไฟล์ไปยัง request
      request.files.add(await http.MultipartFile.fromPath(
        'file', // ชื่อฟิลด์ที่เซิร์ฟเวอร์คาดหวัง
        image!.path,
        // filename: fileName, // ตั้งชื่อไฟล์ตามที่เซิร์ฟเวอร์ต้องการ
      ));

      // ส่ง request
      final response = await request.send();

      // รับข้อมูลที่ตอบกลับ
      final responseData = await http.Response.fromStream(response);
      print('Response body: ${responseData.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData.body);
        log(data.toString()); // แสดงข้อมูลที่ได้รับ
        final storage = GetStorage();
        await storage.write('orderImage', data['url'].toString() ?? '');
        await getUserDataFromStorage();
        // setState(() {});

        // // ตรวจสอบว่า 'url' มีอยู่ใน data หรือไม่
        // if (data.containsKey('url')) {
        //   final res = await http.post(
        //     Uri.parse("$url/upload/update"),
        //     headers: {"Content-Type": "application/json; charset=utf-8"},
        //     body:
        //         jsonEncode({"UserID": userId, "Image": data['url'].toString()}),
        //   );

        //   if (res.statusCode == 200) {
        //     log("Upload Firebase");
        //     final storage = GetStorage();
        //     await storage.write('Image', data['url'].toString() ?? '');
        //   }
        // } else {
        //   print('Error: URL not found in response');
        // }

        // print('File uploaded successfully: $data');
      } else {
        print('Error uploading file: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred while uploading file: $e');
    }
  }

  Future<void> _selectImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      // เรียกใช้งานฟังก์ชันอัปโหลดไฟล์หลังเลือกภาพ
    }
  }

  void _showFullImage(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            child: Image.file(imageFile, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
