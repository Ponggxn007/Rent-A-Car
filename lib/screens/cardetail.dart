import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CarDetail extends StatefulWidget {
  const CarDetail({super.key, required this.user_name,
  required this.product_id,
  required this.product_name,
  required this.product_image,
  required this.product_price});

  final String user_name;
  final String product_id;
  final String product_image;
  final String product_price;
  final String product_name;

  @override
  State<CarDetail> createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {

  final IP = '192.168.1.147';

  int reserve_num=1;

  void insertReserve(String username, String product_id, int reserve_num) async {
    try {
      String url = "http://${IP}/mobile/insertReserve.php?user_name=$username&product_id=$product_id&reserve_num=$reserve_num";

      print(url);
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      });
      if (response.statusCode == 200) {
        var rs = response.body.replaceAll('ï»¿', '');
        var rsInsert = convert.jsonDecode(rs);

        setState(() {
          String st=rsInsert ['insert'];

          if (st.contains('OK')) {
              Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.product_name}'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Image.network('http://${IP}/mobile/${widget.product_image}',
            width: 150,
            height: 90,
            fit: BoxFit.fill,),
            
            
     
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Center(child: Text('ราคา ${widget.product_price}  บาท',
              style: TextStyle(fontSize: 20, color: Colors.blue),)),
            ),
     
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    child: IconButton(onPressed: () {
                    setState(() {
                      reserve_num--;
                      if(reserve_num<1){ reserve_num=1; }
                    });
                  }, icon: Icon(Icons.remove)),
                  ),

                  Text('  จำนวนที่จอง   ${reserve_num}   คัน  ',
                  style: TextStyle(fontSize: 20),),

                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(onPressed: () {
                    setState(() {
                      reserve_num++;
                    });
                  }, icon: Icon(Icons.add)),
                  )
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.only(top: 20,right: 70,left: 70),
              child: Card(
                color: Colors.green,
                child: ListTile(
                  onTap: () {
                    setState(() {
                      insertReserve(widget.user_name, widget.product_id, reserve_num);
                    });
                  },
                  title: Center(child: Text('ยืนยันการจอง')),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}