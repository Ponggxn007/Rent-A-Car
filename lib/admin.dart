import 'package:flutter/material.dart';
import 'package:project01/screens/member.dart';
import 'package:project01/screens/reserve.dart';
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int id = 0;

final List<Widget> screenInAdminPage=[
  Reserve(),
  Member()
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.directions_car,color: Color.fromARGB(200, 255, 254, 253),),
        title: Text(
          "Minert ShowRoom",
          style: TextStyle(color: Color.fromARGB(183, 255, 255, 255)),
        ),
        backgroundColor: Color.fromARGB(183, 16, 175, 180),
      ),
      body: screenInAdminPage[id],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(183, 16, 175, 180),
          unselectedItemColor: Color.fromARGB(183, 222, 254, 255),
          selectedItemColor: Color.fromARGB(183, 8, 58, 59),
          currentIndex: id,
          onTap: (value) {
            setState(() {
              id = value;
            });
          },
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.line_style), label: 'รถที่ถูกจอง'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person_3_sharp), label: 'ลูกค้าสมาชิก')
          ]),
    );
  }
}