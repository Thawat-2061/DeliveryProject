import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rider/pages/profile.dart';
import 'package:rider/pages/receiver.dart';
import 'package:rider/pages/sender.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  //--------------------------------------
  final Map<String, String> phoneBook = {
    '0812345678': 'John Doe',
    '0912345678': 'Jane Smith',
    '0612345678': 'Alice Johnson',
    '0811111111': 'Bob Brown',
    '0922222222': 'Charlie Davis'
  };
  String? selectedUserName;
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
  String detail = '';
  String name = '';

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
                Column(
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 150,
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
                SingleChildScrollView(
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.8, // ปรับขนาดตามหน้าจอ
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 60,
                                  child: TextField(
                                    onChanged: (value) => name =
                                        value, // เก็บค่าที่กรอกในตัวแปร username
                
                                    decoration: InputDecoration(
                                      labelText:
                                          "Product Name", // ข้อความ "Username" ภายใน TextField
                                      labelStyle: TextStyle(
                                        color: Colors
                                            .white, // สีของข้อความ "Username"
                                      ),
                                      prefixIcon: Icon(
                                        Icons
                                            .label, // เพิ่มไอคอนสำหรับ Username
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
                                        color:
                                            Colors.white), // สีข้อความที่กรอก
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
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.8, // ปรับขนาดตามหน้าจอ
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (value) => detail =
                                        value, // เก็บค่าที่กรอกในตัวแปร phone
                
                                    decoration: InputDecoration(
                                      labelText:
                                          "Product details", // ข้อความ "Phone Number" ภายใน TextField
                                      labelStyle: TextStyle(
                                        color: Colors
                                            .white, // สีของข้อความ "Phone Number"
                                      ),
                                      prefixIcon: Icon(
                                        Icons
                                            .info, // เพิ่มไอคอนสำหรับ Phone Number
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
                                        color:
                                            Colors.white), // สีข้อความที่กรอก
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
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.8, // ปรับขนาดตามหน้าจอ
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Autocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return const Iterable<String>.empty();
                                    }
                                    return phoneBook.keys
                                        .where((String number) {
                                      return number
                                          .contains(textEditingValue.text);
                                    });
                                  },
                                  onSelected: (String selectedNumber) {
                                    setState(() {
                                      selectedUserName =
                                          phoneBook[selectedNumber];
                                    });
                                  },
                                  fieldViewBuilder: (context, controller,
                                      focusNode, onFieldSubmitted) {
                                    return TextField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        labelText:
                                            "Phone Customer", // ข้อความ "Email" ภายใน TextField
                                        labelStyle: TextStyle(
                                          color: Colors
                                              .white, // สีของข้อความ "Email"
                                        ),
                                        prefixIcon: Icon(
                                          Icons.phone, // เพิ่มไอคอนอีเมล
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
                                      style: TextStyle(color: Colors.white),
                                    );
                                  },
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.8, // ปรับขนาดตามหน้าจอ
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Customer name",
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          // color: Colors.white,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8, // ปรับขนาดตามหน้าจอ
                                          child: selectedUserName != null
                                              ? Text(
                                                  ' $selectedUserName',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                )
                                              : Text(
                                                  "Choose customer number",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ), // กรณีที่ selectedUserName เป็น null
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 1.0,
                                  indent: 20,
                                  endIndent: 20,
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
                                  log('Prduct: $name');
                                  log('Prduct: $phoneBook');
                                  log('Username: $selectedUserName'); // Log ค่า index
                
                                  Get.to(() => const SenderPage());
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
                                      end:
                                          Alignment.centerRight, // ไปจบที่ขวา
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.5), // สีเงา
                                        spreadRadius: 2, // การกระจายของเงา
                                        blurRadius: 5, // ความเบลอของเงา
                                        offset:
                                            Offset(2, 4), // ระยะห่างของเงา
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Create Order",
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
                )
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
}
