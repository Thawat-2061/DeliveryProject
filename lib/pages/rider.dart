import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:rider/pages/detail.dart';
import 'package:rider/pages/riderview.dart';
import 'package:rider/pages/riprofile.dart';

class RiderPage extends StatefulWidget {
  const RiderPage({super.key});

  @override
  State<RiderPage> createState() => _RiderPageState();
}

class _RiderPageState extends State<RiderPage> {
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
        Get.to(() => const RiProPage());

        break;

      // เพิ่มกรณีอื่นๆ สำหรับการนำทางไปยังหน้าอื่นๆ ที่นี่
    }
  }
//-----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF171716),
        title: Text("Rider"),
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        FilledButton(
                          onPressed: () {
                            // Get.to(() => const AddOrderPage());
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.grey, // สีปุ่มเป็นสีเทา
                            side: BorderSide(
                                color: Colors.white), // ขอบปุ่มเป็นสีขาว
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/sh.png', // เส้นทางรูปภาพของคุณ
                                width: 20, // ขนาดไอคอน
                                height: 20,
                              ),
                              SizedBox(
                                  width: 2), // ระยะห่างระหว่างไอคอนกับข้อความ
                              Text(
                                "Find Order",
                                style: TextStyle(
                                  color: Colors.white, // สีตัวหนังสือเป็นสีขาว
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Card(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          horizontalMargin: 5,
                          columnSpacing: 0,
                          columns: [
                            DataColumn(
                              label: Expanded(
                                child: Container(
                                  width: 70,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Order',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.info,
                                        size: 20,
                                      ) // ใช้สีที่คุณต้องการ
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Center(
                                  child: Text(
                                    'Status',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Center(
                                  child: Text(
                                    'View',
                                    style: TextStyle(color: Colors.white),
                                  ),
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
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('ชื่อ: Barret M82A1'),
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
                                          color: Colors.grey, // สีพื้นหลังปุ่ม
                                          borderRadius: BorderRadius.circular(
                                              20), // ทำให้มุมปุ่มโค้งมน
                                        ),
                                        child: const Text(
                                          'รอไรเดอร์มารับสินค้า',
                                          style: TextStyle(
                                            color: Colors
                                                .black, // สีข้อความของปุ่ม
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Center(
                                  child: InkWell(
                                    onTap: () {
                                      // นำทางไปหน้า DetailPage เมื่อกดปุ่ม
                                      Get.to(() => const RiderviewPage());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical:
                                              8), // กำหนดขนาด padding ให้ปุ่ม
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xFF67B562), // สีพื้นหลังปุ่ม
                                        borderRadius: BorderRadius.circular(
                                            20), // ทำให้มุมปุ่มโค้งมน
                                      ),
                                      child: Text(
                                        'รับงาน',
                                        style: TextStyle(
                                          color:
                                              Colors.black, // สีข้อความของปุ่ม
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
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
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('ชื่อ: Barret M82A1'),
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
                                          color: Colors.grey, // สีพื้นหลังปุ่ม
                                          borderRadius: BorderRadius.circular(
                                              20), // ทำให้มุมปุ่มโค้งมน
                                        ),
                                        child: Text(
                                          'รอไรเดอร์มารับสินค้า',
                                          style: TextStyle(
                                            color: Colors
                                                .black, // สีข้อความของปุ่ม
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Center(
                                  child: InkWell(
                                    onTap: () {
                                      // นำทางไปหน้า DetailPage เมื่อกดปุ่ม
                                      Get.to(() => const RiderviewPage());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical:
                                              8), // กำหนดขนาด padding ให้ปุ่ม
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xFF67B562), // สีพื้นหลังปุ่ม
                                        borderRadius: BorderRadius.circular(
                                            20), // ทำให้มุมปุ่มโค้งมน
                                      ),
                                      child: Text(
                                        'รับงาน',
                                        style: TextStyle(
                                          color:
                                              Colors.black, // สีข้อความของปุ่ม
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ],
                        ),
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
}
