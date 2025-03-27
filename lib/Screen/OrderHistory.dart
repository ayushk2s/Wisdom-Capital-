import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<dynamic> orderData = []; // List to store order data
  String? myvalue;
  @override
  void initState() {
    super.initState();


    MyProfitAndLoss(); // Fetch data when the widget initializes
  }

  Future<void> MyProfitAndLoss() async {
    try {
      myvalue = Get.arguments;
      print('hiin  $myvalue');
      String url = 'https://trade.wisdomcapital.in//interactive/orders';
      Map<String, String> niftyheader = {
        'Content-Type': 'application/json',
        'authorization': '$myvalue',
      };
      http.Response secondResponse = await http.get(
        Uri.parse(url),
        headers: niftyheader,
      );
      print(secondResponse)
;      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        setState(() {
          orderData = responseData["result"];
          print(orderData);
        });
      } else {
        print('Failed to fetch data: ${secondResponse.statusCode}');
      }
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          columns: <DataColumn>[
            DataColumn(
              label: Text('Trading Symbol'),
            ),
            DataColumn(
              label: Text('Order Side'),
            ),
            DataColumn(
              label: Text('Order Price'),
            ),
          ],
          rows: orderData.map((data) {
            return DataRow(
              cells: <DataCell>[
                DataCell(Text(data['TradingSymbol'] ?? 'N/A')),
                DataCell(Text(data['OrderSide'] ?? 'N/A')),
                DataCell(Text(data['OrderPrice'] != null ? data['OrderPrice'].toString() : 'N/A')),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
