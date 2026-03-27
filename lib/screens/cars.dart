import 'package:flutter/material.dart';
import 'package:project01/screens/cardetail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Cars extends StatefulWidget {
  const Cars({super.key, required this.user_name});

final String user_name;


  @override
  State<Cars> createState() => _CarsState();
}

class _CarsState extends State<Cars> {
  
  int menu = 0;

  var product_id = [];
  var product_name = [];
  var product_price = [];
  var product_image = [];

final IP = '192.168.1.147';



@override
  void initState(){
    // TODO: implement ==
    super.initState();
    getProducts();
  }

  void getProducts() async {
    try {
      String url = "http://${IP}/mobile/getProducts.php";

      print(url);
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      });
      if (response.statusCode == 200) {
        var rs = response.body.replaceAll('ï»¿', '');
        var products = convert.jsonDecode(rs);


      setState(() {
        products.forEach((value){
          product_id.add(value['product_id']);
          product_name.add(value['product_name']);
          product_price.add(value['product_price']);
          product_image.add(value['product_image']);
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
  // var carName = [
  //   'paganiHR1',
  //   'paganiSp',
  //   'PaganiZonda HP',
  //   'koniseggGT',
  //   'koniseggS',
  //   'konisegg',
  //   'nsx',
  //   'bugatichiron',
  //   'bugatihiper',
  //   'mini',
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รถที่แนะนำ'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
      itemCount: product_id.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2)),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: InkWell(
            onTap: () {             
              setState(() {
                Navigator.push(context,
                MaterialPageRoute(builder: 
                (context) => CarDetail(user_name: widget.user_name,
                 product_id: product_id[index],
                 product_name: product_name[index],
                 product_image: product_image[index],
                 product_price: product_price[index],),));
              });
            },
            child: Column(
              children: [
                Text('${product_id[index]}'),
                SizedBox(
                  height: 20,
                ),
                Image.network(
                'http://${IP}/mobile/${product_image[index]}',
                width: 130,
                height: 90,
                fit: BoxFit.fill,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    product_name[index],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                )
                //Text('ราคา $('product_price[index]') บาท;
              ],
            ),
          ),
        );
      },
    ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 93, 59, 9),
        unselectedItemColor: Colors.yellow,
        selectedItemColor: Colors.white,
        currentIndex: menu,
        onTap: (value) {
          setState(() {
            menu=value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.money_off_csred_rounded),
          label: 'ชำระจอง' ),                                     
          BottomNavigationBarItem(icon: Icon(Icons.history_toggle_off),
          label: 'ชำระการจอง' ),
        ]),
    );
  }
}