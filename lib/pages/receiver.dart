import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marquee/marquee.dart';
import 'package:rider/config/config.dart';
import 'package:rider/model/response/GetResponseUser.dart';
import 'package:rider/model/response/ReceiverGetRespones.dart';
import 'package:rider/model/response/SenderGetResponse.dart';
import 'package:rider/pages/detail.dart';
import 'package:rider/pages/profile.dart';
import 'package:rider/pages/sender.dart';

class ReceiverPage extends StatefulWidget {
  const ReceiverPage({super.key});

  @override
  State<ReceiverPage> createState() => _ReceiverPageState();
}

class _ReceiverPageState extends State<ReceiverPage> {
  //-----------------------------------------------------------
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Get.to(() => const SenderPage());

        break;
      case 1:
        break;
      case 2:
        Get.to(() => const ProfilePage());
        break;

      // เพิ่มกรณีอื่นๆ สำหรับการนำทางไปยังหน้าอื่นๆ ที่นี่
    }
  }

//-----------------------------------------------------------
  List<ReceiverGetResponse> ReceiverGetResponses = [];
  List<GetResponseUser> GetResponsesUser = [];

  String url = '';
  var senderId;
  var riderId;
  var orderId;

  var senderImage;
  var receiverImage;
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await GetApiEndpoint();
    await getUserDataFromStorage();

    fetchSender();
    fetchUsers();
  }

//-----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Receiver",
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
                children: GetResponsesUser.asMap().entries.map((entry) {
                  var user = entry
                      .value; // ข้อมูลแต่ละ entry ที่ได้จากฐานข้อมูลหรือ API

                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 60,
                    child: Card(
                      color:
                          const Color.fromARGB(212, 23, 23, 22), // พื้นหลังสีดำ
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.white, width: 2), // ขอบสีขาว
                        borderRadius: BorderRadius.circular(20), // รัศมีขอบมน
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/mark.png', // เส้นทางรูปภาพของคุณ
                            width: 40, // ขนาดไอคอน
                            height: 40,
                          ),
                          const SizedBox(
                              width: 8), // ระยะห่างระหว่างไอคอนกับข้อความ
                          Expanded(
                            // ใช้ Expanded เพื่อให้ Text สามารถยืดหยุ่นตามขนาดของ Row
                            child: user.address.length >
                                    30 // ตรวจสอบความยาวของข้อความ
                                ? Marquee(
                                    // ใช้ Marquee เมื่อข้อความยาว
                                    text: user
                                        .address, // ข้อความที่ดึงจากฐานข้อมูล
                                    style: const TextStyle(
                                      color: Colors.white, // สีข้อความเป็นสีขาว
                                    ),
                                    scrollAxis:
                                        Axis.horizontal, // เลื่อนในแนวนอน
                                    blankSpace:
                                        20.0, // ระยะห่างเมื่อข้อความเลื่อนไปจนสุด
                                    velocity: 30.0, // ความเร็วในการเลื่อน
                                    pauseAfterRound: Duration(
                                        seconds:
                                            1), // หยุดหลังจากเลื่อนจบแต่ละรอบ
                                    startPadding:
                                        10.0, // ระยะห่างจากจุดเริ่มต้น
                                    accelerationDuration: Duration(
                                        seconds: 1), // ความเร็วเพิ่มขึ้นเรื่อยๆ
                                    decelerationDuration: Duration(
                                        milliseconds:
                                            500), // ลดความเร็วเมื่อใกล้จบ
                                  )
                                : Text(
                                    // ถ้าข้อความสั้นให้แสดงเป็น Text ธรรมดา
                                    user.address,
                                    style: const TextStyle(
                                      color: Colors.white, // สีข้อความเป็นสีขาว
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // ตัดข้อความเมื่อยาวเกิน
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
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
                                  'Imge',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                        rows: ReceiverGetResponses.asMap().entries.map((entry) {
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
                                            title: Text(
                                              'ชื่อสินค้า ${data.name}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Text('ชื่อ: ${data.name}'),
                                                Text(
                                                    'รายละเอียด: ${data.detail}'),
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
                                      // นำทางไปยังหน้า DetailPage พร้อมส่งค่า productId
                                      if (data.status != 'รอไรเดอร์') {
                                        setState(() {
                                          this.riderId =
                                              data.riderId.toString();
                                          this.orderId =
                                              data.orderId.toString();
                                          this.senderImage =
                                              data.senderImage.toString();
                                          this.receiverImage =
                                              data.receiverImage.toString();
                                        });
                                        seeDetail();
                                      } else {
                                        log('กำลังรอไรเดอร์มารับออเดอร์ของคุณอยู่');
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(data
                                            .status), // ฟังก์ชันกำหนดสีพื้นหลังตามสถานะ
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        data.status,
                                        style: const TextStyle(
                                          color: Colors.black, // สีข้อความ
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Center(child: Text(data.senderName))),
                              DataCell(Text(data.phone)),
                              DataCell(
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.transparent,
                                            content: SizedBox(
                                              width: 300, // กำหนดขนาดของ dialog
                                              height: 300,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  // CircularProgressIndicator สำหรับแสดงการโหลดหมุนๆ
                                                  const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  // ภาพที่โหลดจาก network
                                                  Image.network(
                                                    data.image,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child; // หากโหลดเสร็จแล้ว ให้แสดงภาพ
                                                      } else {
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(), // แสดงการโหลดหมุนๆ จนกว่าจะโหลดเสร็จ
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Center(
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
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

    final senderId = storage.read('UserID');
    // final userUsername = storage.read('Username');
    // final userEmail = storage.read('Email');
    // final userImage = storage.read('Image');

    // log(userUsername);

    setState(() {
      this.senderId = senderId;
      // this.userUsername = userUsername;
      // this.userEmail = userEmail;
      // this.userImage = userImage;
      // log(userId);
    });
  }

  Future<void> fetchSender() async {
    _showLoadingDialog();
    try {
      final res = await http.get(
        Uri.parse("$url/user/showme/$senderId"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (res.statusCode == 200) {
        // ตรวจสอบว่า API ส่งกลับสถานะ 200 หรือไม่
        setState(() {
          ReceiverGetResponses = receiverGetResponseFromJson(res.body);
        });
        log('aaaaaaaa: $senderId');
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

  Future<void> fetchUsers() async {
    // แสดง dialog โหลดข้อมูล

    try {
      final res = await http.get(
        Uri.parse("$url/profile/user/$senderId"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (res.statusCode == 200) {
        // ตรวจสอบว่า API ส่งกลับสถานะ 200 หรือไม่
        setState(() {
          GetResponsesUser = getResponseUserFromJson(res.body);
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
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'รอไรเดอร์':
        return Colors.grey; // สีเทาสำหรับสถานะ "รอไรเดอร์"
      case 'ไรเดอร์รับงาน':
        return Colors
            .deepOrangeAccent; // สีส้มสำหรับสถานะ "ไรเดอร์รับงาน" และ "กำลังเดินทาง"
      case 'กำลังเดินทาง':
        return Colors
            .yellowAccent; // สีส้มสำหรับสถานะ "ไรเดอร์รับงาน" และ "กำลังเดินทาง"
      case 'ส่งสำเร็จ':
        return Color.fromARGB(255, 67, 233, 78); // สีเขียวสำหรับสถานะ "สำเร็จ"
      default:
        return Colors.white; // สีขาวสำหรับสถานะอื่น ๆ (ถ้ามี)
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

  void seeDetail() async {
    final storage = GetStorage();
    await storage.write('RiderID', riderId.toString());
    await storage.write('SenderID', senderId.toString());
    await storage.write('OrderID', orderId.toString());

    await storage.write('SenderImage', senderImage.toString());
    await storage.write('ReceiverImage', receiverImage.toString());
    // try {
    //   final response = await http.post(
    //     Uri.parse("$url/login/rider"),
    //     headers: {"Content-Type": "application/json; charset=utf-8"},
    //     body: jsonEncode({"RiderID": }),
    //   );
    //   } catch (e) {
    //   print('Error during login: $e');
    // }

    Get.to(() => DetailPage());
  }
}
