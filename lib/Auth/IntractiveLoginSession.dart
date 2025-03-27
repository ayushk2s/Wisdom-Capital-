import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanuman/Auth/MarketDataLoginSession.dart';
import 'package:hanuman/Screen/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InteractiveLoginSession extends StatefulWidget{

  InteractiveLoginSession({super.key});

  @override
  State<InteractiveLoginSession> createState() => _InteractiveLoginSessionState();
}

class _InteractiveLoginSessionState extends State<InteractiveLoginSession> {
  ///wd3278
  TextEditingController APIKEYController = TextEditingController(text: 'Your interactive session api');
  TextEditingController SecretKey = TextEditingController(text: 'secrete key');
  TextEditingController loginThrough = TextEditingController(text: 'WEBAPI');


//Interactive Order
  Future<void> interactiveOrderAPILogin() async{
    //Interactive
    String firstUrl = 'https://trade.wisdomcapital.in/interactive/user/session';
    Map<String, String> firstPayload = {
      "secretKey": "${SecretKey.text.trim()}",
      "appKey": "${APIKEYController.text.trim()}",
      "source": "WEBAPI"
    };
    String firstJsonPayload = jsonEncode(firstPayload);
    Map<String, String> firstHeaders = {'Content-Type': 'application/json'};
    try {
      setState(() {
        isLoading = true;
      });
      http.Response firstResponse = await http.post(
        Uri.parse(firstUrl),
        headers: firstHeaders,
        body: firstJsonPayload,
      );
      if (firstResponse.statusCode == 200) {
        //interactive
        Map<String, dynamic> firstData = jsonDecode(firstResponse.body);
        String interactiveSessionToken = firstData['result']['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('interactiveSessionToken', interactiveSessionToken);
        print('interactiveSessionToken $interactiveSessionToken');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) =>
                MarketDataLoginSession(interactiveSessionToken: interactiveSessionToken)), (route) => false);
      } else {
        print('Failed with status code: ${firstResponse.statusCode} ${firstResponse.body}');
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
        title: Text('Interactive Order Login'),
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
              controller: APIKEYController,
              decoration: const InputDecoration(
                hintText: 'API KEY',
                border: OutlineInputBorder(),

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: SecretKey,
              decoration: const InputDecoration(
                hintText: 'Secrete Key',
                border: OutlineInputBorder(),

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: loginThrough,
              decoration: const InputDecoration(
                hintText: 'WEBAPI',
                border: OutlineInputBorder(),

              ),
            ),
          ),
          ElevatedButton(
              onPressed: () async{
                print('Interactive start login');
                await interactiveOrderAPILogin();
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