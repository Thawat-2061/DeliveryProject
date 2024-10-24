import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rider/config/config.dart';
import 'package:rider/pages/profile.dart';
import 'package:rider/pages/receiver.dart';
import 'package:rider/pages/riprofile.dart';
import 'package:rider/pages/sender.dart';
import 'package:http/http.dart' as http;

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
  String? ridername;
  String? email;
  String? phone;
  String? address;
  final ImagePicker picker = ImagePicker();
  File? image; // ตัวแปรเพื่อเก็บภาพที่เลือก

  String url = '';
  var riderId;
  var riderImage;
  var riderName;
  var riderEmail;
  var riderPhone;

  TextEditingController ridernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await GetApiEndpoint();
    await getUserDataFromStorage();
    ridernameController.text = riderName;
    emailController.text = riderEmail;
    phoneController.text = riderPhone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Expanded(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap:
                            _pickImage, // เรียกใช้งานฟังก์ชันนี้เมื่อผู้ใช้แตะที่ GestureDetector
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipOval(
                              child: image != null
                                  ? Image.file(
                                      image!,
                                      width: 180.0,
                                      height: 180.0,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      '$riderImage',
                                      width: 180.0,
                                      height: 180.0,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 1, bottom: 20),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 242, 179, 83),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
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
                                  controller:
                                      ridernameController, // ใช้ controller สำหรับคุมค่าใน TextField
                                  onChanged: (value) {
                                    // หากต้องการอัปเดตค่า ridername ขณะพิมพ์
                                    setState(() {
                                      ridername = value;
                                    });
                                  },

                                  decoration: InputDecoration(
                                    labelText:
                                        "Ridername", // ข้อความ "Ridername" ภายใน TextField
                                    labelStyle: TextStyle(
                                      color: Colors
                                          .white, // สีของข้อความ "Ridername"
                                    ),
                                    prefixIcon: Icon(
                                      Icons
                                          .person, // เพิ่มไอคอนสำหรับ Ridername
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
                                  controller:
                                      phoneController, // ใช้ controller สำหรับคุมค่าใน TextField
                                  onChanged: (value) {
                                    // หากต้องการอัปเดตค่า ridername ขณะพิมพ์
                                    setState(() {
                                      phone = value;
                                    });
                                  },
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
                                  controller:
                                      emailController, // ใช้ controller สำหรับคุมค่าใน TextField
                                  onChanged: (value) {
                                    // หากต้องการอัปเดตค่า ridername ขณะพิมพ์
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText:
                                        "Email", // ข้อความ "Email" ภายใน TextField
                                    labelStyle: TextStyle(
                                      color:
                                          Colors.white, // สีของข้อความ "Email"
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
                    ],
                  ),
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('ยืนยันการแก้ไข'),
                              content: Text(
                                  'คุณแน่ใจหรือไม่ว่าต้องการแก้ไขข้อมูลนี้?'),
                              actions: [
                                TextButton(
                                  child: Text('ยกเลิก'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // ปิดกล่องโต้ตอบเมื่อผู้ใช้ยกเลิก
                                  },
                                ),
                                TextButton(
                                  child: Text('ยืนยัน'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // ปิดกล่องโต้ตอบเมื่อผู้ใช้ยืนยัน
                                    String updatedRidername =
                                        ridername ?? ridernameController.text;
                                    String updatedPhone =
                                        phone ?? phoneController.text;
                                    String updatedEmail =
                                        email ?? emailController.text;

                                    // เรียกฟังก์ชันแก้ไขข้อมูล
                                    editPro(updatedRidername, updatedPhone,
                                        updatedEmail);
                                    // แสดงข้อมูลที่ต้องการ log
                                    // log('Ridername: $ridername');
                                    // log('Email: $email');
                                    // log('Phone: $phone');
                                    // log('Address: $address');

                                    // หากต้องการไปหน้าอื่นหลังจากยืนยัน
                                    // Get.to(() => const RiProPage());
                                  },
                                ),
                              ],
                            );
                          },
                        );
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
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ],
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

// ฟังก์ชันสำหรับเลือกภาพจากแหล่งต่าง ๆ
  Future<void> _selectImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      // เรียกใช้งานฟังก์ชันอัปโหลดไฟล์หลังเลือกภาพ
    }
  }

  Future<void> _uploadFile() async {
    if (image == null) {
      print('No file selected!');
      return;
    }

    try {
      // สร้าง MultipartRequest โดยใช้ $url
      var request = http.MultipartRequest('POST', Uri.parse("$url/upload/"));
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

        // ตรวจสอบว่า 'url' มีอยู่ใน data หรือไม่
        if (data.containsKey('url')) {
          final res = await http.post(
            Uri.parse("$url/upload/updateRider"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: jsonEncode(
                {"RiderID": riderId, "Image": data['url'].toString()}),
          );

          if (res.statusCode == 200) {
            log("Upload Firebase");
            final storage = GetStorage();
            await storage.write('RiderImage', data['url'].toString());

            Get.offAll(const RiProPage());
          }
        } else {
          print('Error: URL not found in response');
        }

        print('File uploaded successfully: $data');
      } else {
        print('Error uploading file: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred while uploading file: $e');
    }
  }

  Future<void> GetApiEndpoint() async {
    Configguration.getConfig().then(
      (value) {
        log('MainRiderGet API ');
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

    final riderId = storage.read('RiderID');
    final riderName = storage.read('RiderUsername');
    final riderEmail = storage.read('Email');
    final riderImage = storage.read('RiderImage');
    final riderPhone = storage.read('RiderPhone');

    // log(riderRidername);

    setState(() {
      this.riderId = riderId;
      this.riderName = riderName;
      this.riderEmail = riderEmail;
      this.riderImage = riderImage;
      this.riderPhone = riderPhone;

      // log(riderId);
    });
  }

  void editPro(String ridername, String phone, String email) async {
    await _uploadFile();

    final resp = await http.put(
      Uri.parse("$url/profile/editRider"),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: jsonEncode({
        "RiderID": riderId,
        "Username": ridername,
        "Phone": phone,
        "Email": email
      }),
    );
    if (resp.statusCode == 200) {
      log("Upload Firebase");
      final storage = GetStorage();
      // await storage.write('Image', data['url'].toString() ?? '');
      await storage.write('RiderUsername', ridername.toString());
      await storage.write('Email', email.toString());
      await storage.write('RiderPhone', phone.toString());
      await getUserDataFromStorage();
      // Get.offAll(const ProfilePage());
    }
  }

  @override
  void dispose() {
    // ทำลาย controller เมื่อไม่ได้ใช้งานแล้ว
    ridernameController.dispose();
    super.dispose();
  }
}
