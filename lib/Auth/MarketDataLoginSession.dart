import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanuman/MarketData/optinFetchNifty.dart';
import 'package:hanuman/Screen/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MarketDataLoginSession extends StatefulWidget{
  String? interactiveSessionToken;

  MarketDataLoginSession({super.key, required this.interactiveSessionToken});

  @override
  State<MarketDataLoginSession> createState() => _MarketDataLoginSessionState();
}

class _MarketDataLoginSessionState extends State<MarketDataLoginSession> {
 ///wd3278
   TextEditingController MarketAPIKEYController = TextEditingController(text: 'Your market session api');
   TextEditingController MarketSecretKey = TextEditingController(text: 'Market secrete key');
   TextEditingController MarketloginThrough = TextEditingController(text: 'WebAPI');


//Interactive Order
  Future<void> marketDataAPILogin() async{
    //Interactive
    final String marketUrl = 'https://trade.wisdomcapital.in/apimarketdata/auth/login';
    print(marketUrl);
    Map<String, String> marketPayLoad = {
      "secretKey": "${MarketSecretKey.text.trim()}",
      "appKey": "${MarketAPIKEYController.text.trim()}",
      "source": "WebAPI"
    };
    Map<String, String> marketHeader = {'Content-Type': 'application/json'};
    String marketjsonPayload = jsonEncode(marketPayLoad);

    try {
      setState(() {
        isLoading = true;
      });
      http.Response responseMarket = await http.post(
          Uri.parse(marketUrl),
          headers: marketHeader,
          body: marketjsonPayload
      );
      if (responseMarket.statusCode == 200){

        SharedPreferences prefs = await SharedPreferences.getInstance();
        //market
        Map<String, dynamic> MarketDataTokenGetting = jsonDecode(responseMarket.body);
        String marketSessionToken = MarketDataTokenGetting['result']['token'];
        await prefs.setString('marketSessionToken', marketSessionToken);
        print('MarketDataTokenGetting $MarketDataTokenGetting');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) =>
                OptionFetchNifty(interactiveSessionToken: widget.interactiveSessionToken,
                    marketSessionToken: marketSessionToken)), (route) => false);
      } else {
        print('Failed with status code: ${responseMarket.statusCode}');
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print('Error obtaining session token: $error');
    }
  }




  bool isLoading = false;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 30,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        shadowColor: Colors.yellowAccent,
        title: Text('Market Data Login'),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [
                0.1,
                0.4,
                0.5,
                0.6,
                0.9,
              ],
              colors: [
                Colors.deepOrange,
                Colors.orange,
                Colors.orangeAccent,
                Colors.yellow,
                Colors.yellowAccent,
              ],
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: MarketAPIKEYController,
                decoration: const InputDecoration(
                  hintText: 'API KEY',
                  border: OutlineInputBorder(),

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: MarketSecretKey,
                decoration: const InputDecoration(
                  hintText: 'Secrete Key',
                  border: OutlineInputBorder(),

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: MarketloginThrough,
                decoration: const InputDecoration(
                  hintText: 'WEBAPI',
                  border: OutlineInputBorder(),

                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async{
                  await marketDataAPILogin();
                },
                child: Stack(
                  children: [
                    Text('Log in'),
                    if(isLoading)
                      CupertinoActivityIndicator(color: Colors.black,),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}