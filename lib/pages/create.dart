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
  String? selectedUserAddress;
  double? selectedUserLatitude;
  double? selectedUserLongitude;
  LatLng get latLng =>
      LatLng(selectedUserLatitude ?? 0.0, selectedUserLongitude ?? 0.0);
  MapController mapController = MapController();
  bool _showMap = false;
  var userID;
//-----------------------------------------------------------

  final ImagePicker picker = ImagePicker();
  XFile? image;
//-----------------------------------------------------------

  List<UserGetRespon> UserGetResponses = [];

  String detail = '';
  String name = '';
  String url = '';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await GetApiEndpoint();
    await getUserDataFromStorage();
    fetchUsers();
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
                        _pickImage();
                      },
                      child: Icon(
                        Icons.add_photo_alternate,
                        size: 150,
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
                                    selectedUserName = selectedUser.username;
                                    selectedUserAddress =
                                        selectedUser.address; // เพิ่ม Address
                                    selectedUserLatitude = selectedUser
                                        .gpsLatitude; // เพิ่ม Latitude
                                    selectedUserLongitude = selectedUser
                                        .gpsLongitude; // เพิ่ม Longitude

                                    mapController.move(
                                        latLng, mapController.camera.zoom);
                                  });
                                },
                                fieldViewBuilder: (context, controller,
                                    focusNode, onFieldSubmitted) {
                                  return TextField(
                                    controller: phoneController,
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
                                log('Product n: $name');
                                log('Product d: $detail');
                                log('Username: $selectedUserName');
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
                Column(
                  children: UserGetResponses.asMap().entries.map((entry) {
                    int index = entry.key; // ดึงลำดับ index ของแต่ละรายการ
                    var user = entry.value; // ดึงข้อมูลของ user

                    return SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.9, // ปรับขนาดตามหน้าจอ
                      child: GestureDetector(
                        onTap: () {
                          // ฟังก์ชันที่เรียกใช้เมื่อมีการกด
                          log('User: ${user.username}');
                          log('Phone: ${user.phone}');
                          log('Address: ${user.address}');
                          // คุณสามารถเพิ่มฟังก์ชันเพิ่มเติมที่นี่ เช่น เปิดหน้าจอรายละเอียด
                          setState(() {
                            usernameController.text = user
                                .username; // กรอกข้อมูลอัตโนมัติในช่อง username
                            phoneController.text =
                                user.phone; // กรอกข้อมูลอัตโนมัติในช่อง phone
                            addressController.text = user
                                .address; // กรอกข้อมูลอัตโนมัติในช่อง address
                            customerId = user.userId;
                          });
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // ชิดซ้าย
                              children: [
                                // รูปภาพแบบวงกลมอยู่ทางซ้าย
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
                                // ข้อความอยู่ทางขวา
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
                  // await _selectImage(ImageSource.camera); // เลือกภาพจากกล้อง
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(modalContext).pop(); // ปิด modal
                  // await _selectImage(ImageSource.gallery); // เลือกภาพจากแกลอรี่
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
    // final userImage = storage.read('Image');

    // log(userUsername);

    setState(() {
      this.userID = userId;
      // this.userUsername = userUsername;
      // this.userEmail = userEmail;
      // this.userImage = userImage;
      // log(userId);
    });
  }

  Future<void> createOrder(
      BuildContext context,
      TextEditingController productnameController,
      TextEditingController detailController) async {
    Map<String, dynamic> userData = {
      'SenderID': userID,
      'ReceiverID': customerId,
      'Name': productnameController.text,
      'Detail': detailController.text,
      // 'Status': imageUrl,
      // 'Image': carregCtl.text,
    };
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
    } catch (e) {
      // ปิด progress dialog

      log('Error: $e');
      log('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์');
    }
  }
}
