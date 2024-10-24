import 'dart:convert';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:rider/config/config.dart';
import 'package:rider/model/response/RiderGetRespons.dart';
import 'package:rider/model/response/RiderPostRes.dart';
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
        Get.offAll(() => const RiProPage());

        break;

      // เพิ่มกรณีอื่นๆ สำหรับการนำทางไปยังหน้าอื่นๆ ที่นี่
    }
  }

//-----------------------------------------------------------
  List<RiderGetResponse> RiderGetResponses = [];
  List<RiderPostResponse> RiderPostResponses = [];

  String url = '';
  var riderID;
  var receiverId;
  var senderId;
  var senderImage;
  var receiverImage;
  var orderId;

  var riderImage;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await GetApiEndpoint();
    await getUserDataFromStorage();

    getRiderMet();
    fetchRider();
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
                                    'Sender',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Center(
                                  child: Text(
                                    'Tel.',
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
                          rows:  RiderGetResponses.isEmpty
                            ? [
                                DataRow(cells: [
                                  DataCell(SizedBox(width: 80, child: Text(''))),
                                  DataCell(SizedBox(width: 40, child: Text(''))),
                                  DataCell(SizedBox(width: 120, child: Center(child: Text('No works.')))),
                                  DataCell(SizedBox(width: 40, child: Text(''))),
                                  DataCell(SizedBox(width: 80, child: Text(''))),
                                ])
                              ]
                            : RiderGetResponses.asMap().entries.map((entry) {
                            var data = entry.value; // ดึงข้อมูลจาก API/database
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        // แสดงข้อมูลสินค้าใน Dialog
                                        showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Colors
                                                  .grey[900], // กำหนดสีพื้นหลัง
                                              title: Text(
                                                'ชื่อสินค้า ${data.name}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // รูปภาพจาก URL พร้อมการโหลด
                                                  Image.network(
                                                    data.image, // เปลี่ยน URL ตามจริง
                                                    height:
                                                        300, // กำหนดขนาดของรูปภาพ
                                                    width: 300,
                                                    fit: BoxFit
                                                        .cover, // กำหนดลักษณะการจัดรูปภาพ
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      } else {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          10), // เว้นระยะห่าง
                                                  // ข้อความรายละเอียด
                                                  Text(
                                                    'รายละเอียด: ${data.detail}',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white), // เปลี่ยนสีข้อความให้เข้ากับพื้นหลัง
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: SizedBox(
                                        width: 50,
                                        child: Text(
                                          data.name,
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
                                        // Get.to(() => const DetailPage());
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
                                          data.status,
                                          style: TextStyle(
                                            color: Colors
                                                .black, // สีข้อความของปุ่ม
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Center(child: Text(data.senderName))),
                                DataCell(Text(data.senderPhone)),
                                DataCell(Center(
                                  child: InkWell(
                                    onTap: () {
                                      // นำทางไปหน้า DetailPage เมื่อกดปุ่ม
                                      setState(() {
                                        this.receiverId =
                                            data.receiverId.toString();
                                        this.senderId =
                                            data.senderId.toString();
                                        this.senderImage =
                                            data.senderImage.toString();
                                        this.receiverImage =
                                            data.customerImage.toString();
                                        this.riderImage = data.image.toString();
                                        this.orderId = data.orderId.toString();

                                        // this.riderID = riderID;

                                        // log('rider: $riderID');
                                      });
                                      riderview();
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
                            );
                          }).toList(),
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

    final riderId = storage.read('RiderID');
    final riderImage = storage.read('RiderImage');
    // final userEmail = storage.read('Email');
    // final userImage = storage.read('Image');

    // log(userUsername);

    setState(() {
      this.riderID = riderId;
      this.riderImage = riderImage;

      // this.userUsername = userUsername;
      // this.userEmail = userEmail;
      // this.userImage = userImage;
      log('riderID: $riderID');
    });
  }
//----------------------------------------------------------------------------------------------------

  Future<void> fetchRider() async {
    _showLoadingDialog();
    try {
      final res = await http.get(
        Uri.parse("$url/rider"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (res.statusCode == 200) {
        // ตรวจสอบว่า API ส่งกลับสถานะ 200 หรือไม่
        setState(() {
          RiderGetResponses = riderGetResponseFromJson(res.body);
        });
        // log('aaaaaaaa: $riderID');
      } else {
        log("Failed to load users: ${res.statusCode}");
      }

      final data = json.decode(res.body);

      // log(res.body);
    } catch (e) {
      log("Error: $e");
    }
    Navigator.of(context).pop();
  }
//----------------------------------------------------------------------------------------------------

  void getRiderMet() async {
    try {
      final response = await http.post(
        Uri.parse("$url/profile/rider"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode({"RiderID": riderID}),
      );
      if (response.statusCode == 200) {
        log(response.body);

        setState(() {
          // แปลง JSON และอัปเดตตัวแปร RiderGetResponses
          RiderPostResponses = riderPostResponseFromJson(response.body);
          RiderPostResponses.asMap().entries.map((entry) async {
            var rider = entry.value;
            final storage = GetStorage();
            await storage.write('RiderImage', rider.image.toString());
            // log(rider.image);
          }).toList();
        });
      } else {
        throw Exception('Failed to load riders');
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }

//----------------------------------------------------------------------------------------------------

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
//----------------------------------------------------------------------------------------------------

  void riderview() async {
    final storage = GetStorage();
    await storage.write('ReceiverID', receiverId.toString());
    await storage.write('SenderID', senderId.toString());
    await storage.write('SenderImage', senderImage.toString());
    await storage.write('ReceiverImage', receiverImage.toString());
    await storage.write('OrderID', orderId.toString());

    // await storage.write('RiderID',riderID.toString());

    await Get.to(() => const RiderviewPage());
  }
}
