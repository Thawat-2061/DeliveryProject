import 'package:flutter/material.dart';
import 'package:rider/pages/login.dart';
import 'package:rider/pages/sender.dart';
import 'package:toggle_switch/toggle_switch.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _fillIndex = 1; // กำหนดค่าเริ่มต้น

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
          Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
        break;
         case 2:
          Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SenderPage()),
      );
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
        title: Text("data"),
      ),
      backgroundColor: Color(0xFF171716),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToggleSwitch(
              minWidth: 90.0,
              cornerRadius: 20.0,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              initialLabelIndex: _fillIndex,
              totalSwitches: 2,
              labels: ['User', 'Rider'],
              radiusStyle: true,
              activeBgColors: [
                [const Color.fromARGB(115, 238, 14, 14), Colors.black26],
                [Colors.yellow, Colors.orange]
              ],
              animate: true,
              curve: Curves.fastOutSlowIn,
              onToggle: (index) {
                setState(() {
                  _fillIndex = index!;
                });
                print('switched to: $index');
              },
            ),
            SizedBox(height: 20),
            Visibility(
              visible: _fillIndex == 0, // แสดง TextField เมื่อ index = 0
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Input for User',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
      
        bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(96, 250, 250, 250), // สีพื้นหลังของ BottomNavigationBar
        selectedItemColor: const Color.fromARGB(255, 240, 65, 42), // สีของไอคอนที่ถูกเลือก
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
          fontWeight: FontWeight.normal, // ไม่ทำให้ข้อความตัวหนาเมื่อไม่ถูกเลือก
        ),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icon.png', // ระบุพาธของรูปภาพ
              width: 50, // กำหนดความกว้างของรูปภาพ
              height: 50, // กำหนดความสูงของรูปภาพ
            ),
            label: 'หน้าแรก', // ข้อความของรายการ
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.unarchive, size: 50), // ไอคอนของรายการ
            label: 'ส่งสินค้า', // ข้อความของรายการ
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive, size: 50), // ไอคอนของรายการ
            label: 'รับสินค้า', // ข้อความของรายการ
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