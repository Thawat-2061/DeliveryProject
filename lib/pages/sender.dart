import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rider/pages/addOrder.dart';
import 'package:rider/pages/create.dart';
import 'package:rider/pages/detail.dart';
import 'package:rider/pages/receiver.dart';
import 'package:rider/pages/profile.dart';

class SenderPage extends StatefulWidget {
  const SenderPage({super.key});

  @override
  State<SenderPage> createState() => _SenderPageState();
}

class _SenderPageState extends State<SenderPage> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Sender",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 60,
                    child: Card(
                      color:
                          Color.fromARGB(212, 23, 23, 22), // พื้นหลังเป็นสีดำ
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.white, width: 2), // ขอบสีขาว
                        borderRadius:
                            BorderRadius.circular(20), // รัศมีขอบที่มน
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/mark.png', // เส้นทางรูปภาพของคุณ
                            width: 40, // ขนาดไอคอน
                            height: 40,
                          ),
                          SizedBox(
                              width: 8), // ระยะห่างระหว่างไอคอนกับข้อความ
                          Text(
                            "data",
                            style: TextStyle(
                                color: Colors
                                    .white), // เปลี่ยนสีข้อความเป็นสีขาว
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 20), // ระยะห่างระหว่างไอคอนกับข้อความ
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Get.to(() => const CreatePage());
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 48, 48, 48), // สีปุ่มเป็นสีเทา
                            side: BorderSide(
                                color: Colors.white), // ขอบปุ่มเป็นสีขาว
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/iadd.png', // เส้นทางรูปภาพของคุณ
                                width: 20, // ขนาดไอคอน
                                height: 20,
                              ),
                              Text(
                                "Create Order",
                                style: TextStyle(
                                  color:
                                      Colors.white, // สีตัวหนังสือเป็นสีขาว
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20), // ระยะห่างระหว่างปุ่มสองปุ่ม
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Get.to(() => const AddOrderPage());
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.grey, // สีปุ่มเป็นสีเทา
                            side: BorderSide(
                                color: Colors.white), // ขอบปุ่มเป็นสีขาว
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/sh.png', // เส้นทางรูปภาพของคุณ
                                width: 20, // ขนาดไอคอน
                                height: 20,
                              ),
                              Text(
                                "Find Order",
                                style: TextStyle(
                                  color:
                                      Colors.white, // สีตัวหนังสือเป็นสีขาว
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20), // ระยะห่างระหว่างไอคอนกับข้อความ
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Card(
                  child: Column(
                    children: [
                      DataTable(
                        horizontalMargin: 5,
                        columnSpacing: 0,
                        columns: [
                          DataColumn(
                            label: Expanded(
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Order',
                                      style: TextStyle(
                                          color: Colors.white)),
                                  Icon(
                                    Icons.info,
                                    size: 20,
                                  ) // ใช้สีที่คุณต้องการ
                                ],
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Center(
                                child: Text('Status',
                                    style:
                                        TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Center(
                                child: Text('Customer',
                                    style:
                                        TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Center(
                                child: Text('Tel.',
                                    style:
                                        TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Center(
                                child: Text('Imge',
                                    style:
                                        TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                        rows: [
                          DataRow(
                            cells: <DataCell>[
                              DataCell(
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      // เมื่อกดที่ชื่อให้แสดงข้อมูลทั้งหมดใน dialog
                                      showDialog(
                                        context: context,
                                        barrierDismissible:
                                            true, // สามารถกดที่พื้นหลังเพื่อปิด dialog ได้
                                        builder: (BuildContext context) {
                                          return const AlertDialog(
                                            title: Text(
                                                'ข้อมูลของ Barret M82A1'),
                                            content: Column(
                                              mainAxisSize:
                                                  MainAxisSize.min,
                                              children: [
                                                Text(
                                                    'ชื่อ: Barret M82A1'),
                                                Text(
                                                    'รายละเอียด: ...'), // เพิ่มรายละเอียดที่ต้องการแสดง
                                                // สามารถเพิ่ม Text widget อื่น ๆ ได้ตามต้องการ
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const SizedBox(
                                      width: 50,
                                      child: Text(
                                        'Barret M82A1',
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      // นำทางไปหน้า DetailPage เมื่อกดปุ่ม
                                      Get.to(() => const DetailPage());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical:
                                              8), // กำหนดขนาด padding ให้ปุ่ม
                                      decoration: BoxDecoration(
                                        color: Colors.deepOrangeAccent, // สีพื้นหลังปุ่ม
                                        borderRadius:
                                            BorderRadius.circular(
                                                20), // ทำให้มุมปุ่มโค้งมน
                                      ),
                                      child: const Text(
                                        'กำลังส่งสินค้า',
                                        style: TextStyle(
                                          color: Colors
                                              .black, // สีข้อความของปุ่ม
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Center(child: Text('สมชาย'))),
                              DataCell(Text('0812345678')),
                              DataCell(
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      // เมื่อกดไอคอน จะแสดง dialog ที่มีรูปภาพ
                                      showDialog(
                                        context: context,
                                        barrierDismissible:
                                            true, // สามารถกดที่พื้นหลังเพื่อปิด dialog ได้
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors
                                                .transparent, // ตั้งค่าพื้นหลังให้โปร่งใส
                                            content: Image.asset(
                                                'assets/images/newlo.png'), // แสดงรูปภาพใน dialog
                                          );
                                        },
                                      );
                                    },
                                    child: const Center(
                                        child: Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                      size: 40,
                                    )), // ไอคอนรูปภาพ
                                  ),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      // เมื่อกดที่ชื่อให้แสดงข้อมูลทั้งหมดใน dialog
                                      showDialog(
                                        context: context,
                                        barrierDismissible:
                                            true, // สามารถกดที่พื้นหลังเพื่อปิด dialog ได้
                                        builder: (BuildContext context) {
                                          return const AlertDialog(
                                            title: Text('ข้อมูลของ RPG'),
                                            content: Column(
                                              mainAxisSize:
                                                  MainAxisSize.min,
                                              children: [
                                                Text(
                                                    'ชื่อ: Barret M82A1'),
                                                Text(
                                                    'รายละเอียด: ...'), // เพิ่มรายละเอียดที่ต้องการแสดง
                                                // สามารถเพิ่ม Text widget อื่น ๆ ได้ตามต้องการ
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const SizedBox(
                                      width: 50,
                                      child: Text(
                                        'RPG',
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      // นำทางไปหน้า DetailPage เมื่อกดปุ่ม
                                      Get.to(() => const DetailPage());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical:
                                              8), // กำหนดขนาด padding ให้ปุ่ม
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 67, 233, 78), // สีพื้นหลังปุ่ม
                                        borderRadius:
                                            BorderRadius.circular(
                                                20), // ทำให้มุมปุ่มโค้งมน
                                      ),
                                      child: Text(
                                        'ส่งสินค้าสำเร็จ',
                                        style: TextStyle(
                                          color: Colors
                                              .black, // สีข้อความของปุ่ม
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Center(child: Text('สมชาย'))),
                              DataCell(Center(child: Text('0812345678'))),
                              DataCell(
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      // เมื่อกดไอคอน จะแสดง dialog ที่มีรูปภาพ
                                      showDialog(
                                        context: context,
                                        barrierDismissible:
                                            true, // สามารถกดที่พื้นหลังเพื่อปิด dialog ได้
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors
                                                .transparent, // ตั้งค่าพื้นหลังให้โปร่งใส
                                            content: Image.asset(
                                                'assets/images/icon.png'), // แสดงรูปภาพใน dialog
                                          );
                                        },
                                      );
                                    },
                                    child: Center(
                                        child: Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                      size: 40,
                                    )), // ไอคอนรูปภาพ
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
              )
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
}
