import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Reserve extends StatefulWidget {
  const Reserve({super.key});

  @override
  State<Reserve> createState() => _ReserveState();
}

class _ReserveState extends State<Reserve> {

  var id =[];
  var product_id=[];
  var product_name=[];
  var product_price=[];
  var reserve_num=[];
  var total=[];
  var reserve_datetime=[];
  var reserve_slip=[];
  var reserve_status=[];
  var user_name=[];


  final IP = '10.34.3.148';//10.34.3.181

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReserves();
  }


  void getReserves() async {
    try {
      String url = "http://${IP}/mobile/getReserves.php";

      print(url);
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      });
      if (response.statusCode == 200) {
        var rs = response.body.replaceAll('ï»¿', '');
        var reserve = convert.jsonDecode(rs);

        setState(() {
          reserve.forEach((value){
            id.add(value['id']);
            product_id.add(value['product_id']);
            product_name.add(value['product_name']);
            product_price.add(value['product_price']);
            reserve_num.add(value['reserve_num']);
            total.add(value['total']);
            reserve_datetime.add(value['reserve_datetime']);
            reserve_slip.add(value['reserve_slip']);
            reserve_status.add(value['reserve_status']);
            user_name.add(value['user_name']);

          });

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
    return Container(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
      itemCount: product_id.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: MediaQuery.of(context).size.width /
              350),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: InkWell(
            onTap: () {
             setState(() {
              //----------
             });
            },
            child: Column(
              children: [
                Text('ยี่ห้อ: ${product_name[index]} ',
                style: TextStyle(color: Colors.blue,
                fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('ราคา: ${product_price[index]} บาท',
                style: TextStyle(color: Colors.black,
                fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('จำนวนที่จอง: ${reserve_num[index]} คัน',
                style: TextStyle(color: Colors.black,
                fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('รวมเป็นเงิน: ${total[index]} บาท',
                style: TextStyle(color: Colors.red,
                fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('วันที่จอง: ${reserve_datetime[index]} '),
                SizedBox(
                  height: 20,
                ),
                Text('สถานะ: ${reserve_status[index]}'),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    ),
      );
  }
}