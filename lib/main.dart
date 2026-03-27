import 'package:flutter/material.dart';
import 'package:project01/screens/cars.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(Project01());
}

class Project01 extends StatelessWidget {
  const Project01({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color.fromRGBO(219, 226, 12, 0.922), 
          centerTitle: true,
        ),
      ),
      home: CarShop(),
    );
  }
}

class CarShop extends StatefulWidget {
  const CarShop({super.key});

  @override
  State<CarShop> createState() => _CarShopState();
}

class _CarShopState extends State<CarShop> {
  bool hindPassword = true;
  String rwLogin = '';

  TextEditingController us = TextEditingController();
  TextEditingController pw = TextEditingController();

  var resultLogin = '', login = '';
  final IP = '192.168.1.147';

  void checkLogin(String username, String password) async {
    try {
      String url = "http://${IP}/mobile/checkLogin.php?us=$username&pw=$password";
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8',
      });

      if (response.statusCode == 200) {
        var rs = response.body.replaceAll('ï»¿', '');
        var rsLogin = convert.jsonDecode(rs);

        setState(() {
          login = rsLogin['login'];
          if (login.contains('OK')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Cars(user_name: username),
              ),
            );
          } else {
            showAlert(
              context,
              'Login ล้มเหลว',
              'USERNAME หรือ PASSWORD ไม่ถูกต้อง',
            );
          }
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      print(e);
    }
  }

  void showAlert(BuildContext context, String textAlert, String tt) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$tt'),
          content: Text('$textAlert'),
          actions: [
            Card(
              color: Color.fromARGB(255, 224, 205, 33),
              child: ListTile(
                title: Center(child: Text('OK')),
                onTap: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.car_crash,
          color: Color.fromARGB(255, 129, 84, 42),
        ),
        title: Text(
          'Car Center',
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
      body: SingleChildScrollView( // เพิ่ม SingleChildScrollView ที่นี่
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10), // ปรับ padding
                child: TextField(
                  controller: us,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    suffixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10), // ปรับ padding
                child: TextField(
                  controller: pw,
                  obscureText: hindPassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hindPassword = !hindPassword;
                        });
                      },
                      icon: Icon(hindPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100), // ปรับ padding
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: Colors.cyan,
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        if (us.text.isEmpty || pw.text.isEmpty) {
                          showAlert(
                            context,
                            'ป้อนข้อมูล',
                            'กรุณาป้อน USERNAME หรือ PASSWORD',
                          );
                        } else {
                          checkLogin(us.text, pw.text);
                        }
                      });
                    },
                    title: Center(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
