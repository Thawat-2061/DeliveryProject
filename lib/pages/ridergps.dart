import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';

class RiderGPSPage extends StatefulWidget {
  const RiderGPSPage({super.key});

  @override
  State<RiderGPSPage> createState() => _RiderGPSPageState();
}

class _RiderGPSPageState extends State<RiderGPSPage> {
  MapController mapController = MapController();

  LatLng latLng = LatLng(13.7378, 100.5504); // พิกัดเริ่มต้น (กรุงเทพฯ)
  LatLng destinationLatLng = LatLng(
      16.246825669508297, 103.25199289277295); // จุดปลายทาง (ตัวอย่างพิกัด)
  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return WillPopScope(
       onWillPop: () async {
        // คืนค่า false เพื่อป้องกันการย้อนกลับ
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.deepOrangeAccent,
        body: Column(
          children: [
            Expanded(
              child: SlidingUpPanel(
                controller: _panelController,
                maxHeight: 300, // ความสูงสูงสุดตอนดึงขึ้น
                panel: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF171716), borderRadius: radius),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Container(
                            width: 50,
                            height: 7,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  144, 158, 158, 158), // สีพื้นหลังของ Container
                              borderRadius:
                                  BorderRadius.circular(10), // ทำให้ขอบโค้ง
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Address receiver:',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, top: 5, right: 30),
                              child: Row(
                                children: [
                                  Flexible(
                                    // Use Flexible to wrap long text
                                    child: Text(
                                      '199/96 ขามเรียง มหาวิทยาลัย มหาสารคาม 44150', // Fixed typo 'มหาวิทยาลับ' to 'มหาวิทยาลัย'
                                      style: TextStyle(fontSize: 16),
                                      softWrap:
                                          true, // Allows text to wrap to the next line
                                      overflow: TextOverflow
                                          .visible, // Ensures the text doesn't overflow
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1.0,
                                indent: 20,
                                endIndent: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly, // จัดเรียงกลาง
                                children: [
                                  Card(
                                    color: Colors.white,
                                    elevation: 4, // เพิ่มเงาให้กับการ์ด
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // มุมโค้งของการ์ด
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        // เพิ่มฟังก์ชันเมื่อกดที่การ์ด
                                        log('Contact Center tapped');
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 20), // ระยะห่างภายใน
                                        child: Row(
                                          children: [
                                            Icon(Icons.headset_mic,
                                                color: Colors.grey), // ไอคอน
                                            SizedBox(
                                                width:
                                                    8), // ระยะห่างระหว่างไอคอนและข้อความ
                                            Text(
                                              'ติดต่อศูนย์', // ข้อความ
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        log('Chat tapped');
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: Row(
                                          children: [
                                            Icon(Icons.chat, color: Colors.grey),
                                            SizedBox(width: 8),
                                            Text(
                                              'แชท',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        log('Call tapped');
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: Row(
                                          children: [
                                            Icon(Icons.phone, color: Colors.grey),
                                            SizedBox(width: 8),
                                            Text(
                                              'โทร',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly, // จัดเรียงกลาง
                                children: [
                                  Card(
                                    color: Colors.white,
                                    elevation: 4, // เพิ่มเงาให้กับการ์ด
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // มุมโค้งของการ์ด
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        // เพิ่มฟังก์ชันเมื่อกดที่การ์ด
                                        log('status');
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1,
                                            horizontal: 30), // ระยะห่างภายใน
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey,
                                              size: 50,
                                            ), // ไอคอน
                                            SizedBox(
                                                width:
                                                    8), // ระยะห่างระหว่างไอคอนและข้อความ
                                            Text(
                                              'สถาณะตอนนี้', // ข้อความ
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                collapsed: GestureDetector(
                  onTap: () {
                    if (_panelController.isPanelOpen) {
                      _panelController.close();
                    } else {
                      _panelController.open();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 32, 32, 31),
                        borderRadius: radius),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Container(
                            width: 50,
                            height: 7,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  144, 158, 158, 158), // สีพื้นหลังของ Container
                              borderRadius:
                                  BorderRadius.circular(10), // ทำให้ขอบโค้ง
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Rider Detail",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                minHeight:
                    40, // ความสูงตอนที่ยังไม่ดึงขึ้น (สามารถปรับเป็นค่าที่ต้องการได้)
                body: Column(
                  children: [
                    FilledButton(
                        onPressed: () async {
                          var postion = await _determinePosition();
                          log('${postion.latitude} ${postion.longitude}');
      
                          latLng = LatLng(postion.latitude, postion.longitude);
                          mapController.move(latLng, mapController.camera.zoom);
      
                          setState(() {});
                        },
                        child: const Text('Get Location')),
                    Expanded(
                      child: Container(
                        width: double.infinity, // ขนาดความกว้างที่ต้องการ
                        child: FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            initialCenter: latLng,
                            initialZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                              maxNativeZoom: 19,
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: latLng,
                                  width: 40,
                                  height: 40,
                                  child: Icon(Icons.motorcycle_sharp,
                                      color: Colors.red),
                                ),
                                Marker(
                                  point: destinationLatLng, // จุดปลายทาง
                                  width: 40,
                                  height: 40,
                                  child: Icon(Icons.location_pin,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: [
                                    latLng,
                                    destinationLatLng
                                  ], // ลิสต์ของจุดเส้นทาง
                                  color: Colors.blue,
                                  strokeWidth: 4.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                borderRadius: radius,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0,right: 40,top: 10,bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8), // สีของเงา
                      blurRadius: 7, // ความเบลอของเงา
                      offset: Offset(0, 3), // ตำแหน่งของเงา (x, y)
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Define your button's onPressed action
                    log('Button tapped');
                  },
                  child: Text(
                    'ไรเดอร์รับสินค้าและกำลังส่งสินค้า',
                    style: TextStyle(
                      fontSize: 18, // ขนาดตัวอักษร
                      color: Colors.white, // สีตัวอักษร
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF67B562), // สีพื้นหลัง
                    minimumSize: Size(double.infinity, 50), // ขนาดขั้นต่ำ
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14), // ความโค้งของมุม
                      // ไม่มีขอบสี
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
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

  void locationNow() async {
    var postion = await _determinePosition();
    log('${postion.latitude} ${postion.longitude}');
    latLng = LatLng(postion.latitude, postion.longitude);
    mapController.move(latLng, mapController.camera.zoom);
    setState(() {});
  }
}
