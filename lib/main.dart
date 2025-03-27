import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanuman/Auth/IntractiveLoginSession.dart';
import 'package:hanuman/MarketData/optinFetchNifty.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? interactiveSessionToken = prefs.getString('interactiveSessionToken');
  final String? marketSessionToken = prefs.getString('marketSessionToken');
  runApp( MyApp(interactiveSessionToken: interactiveSessionToken, marketSessionToken: marketSessionToken));
}

class MyApp extends StatefulWidget {
  String? interactiveSessionToken;
  String? marketSessionToken;
   MyApp({super.key, required this.interactiveSessionToken, required this.marketSessionToken});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hanuman',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
        home:
        widget.interactiveSessionToken != null && widget.marketSessionToken != null ?
        OptionFetchNifty(interactiveSessionToken: widget.interactiveSessionToken,
         marketSessionToken: widget.marketSessionToken) :
        InteractiveLoginSession(),

    );
  }
}