import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanuman/Screen/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OptionFetchNifty extends StatefulWidget{
  String? interactiveSessionToken;
  String? marketSessionToken;
  OptionFetchNifty({super.key , required this.interactiveSessionToken, required this.marketSessionToken});
  @override
  State<OptionFetchNifty> createState() => _OptionFetchNiftyState();
}

class _OptionFetchNiftyState extends State<OptionFetchNifty> {
  TextEditingController monthController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  var lastTradedPriceNifty;
  var lastTradedPriceFinNifty;
  var lastTradedPriceMidCpNifty;
  var lastTradedPriceBankNifty;

  Future<void> niftyFiftyPrice() async {
    print('Hello');
    try {
      Map<String, dynamic> payload =
      {
        "isTradeSymbol": "true",
        "instruments": [
          {"exchangeSegment": 1, "exchangeInstrumentID": 26000},
        ],
        "xtsMessageCode": 1502,
        "publishFormat": "JSON"
      };
      String myJson = jsonEncode(payload);
      String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/quotes';
      Map<String, String> niftyheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };
      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: niftyheader,
        body: myJson,
      );
      print(secondResponse);
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];
        print(listQuotes);
        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == 26000) {
            lastTradedPriceNifty = quoteData['Touchline']['LastTradedPrice'];
            print('lastTradedPriceNifty $lastTradedPriceNifty');
          } else {
            print('bhag yha se');
          }
        }
      } else {
        // Print the error status code and response body
        print('Error in nifty: ${secondResponse.statusCode}');
        print('Response Body: ${secondResponse.body}');
      }
    } catch (e) {
      print('Error fetching nifty data: $e');
    }
    await intrumentIDNiftyOption();
  }
  Future<void> bankNiftyPrice() async {
    print('Hello');
    try {
      Map<String, dynamic> payload =
      {
        "isTradeSymbol": "true",
        "instruments": [
          {"exchangeSegment": 1, "exchangeInstrumentID": 26001},
        ],
        "xtsMessageCode": 1502,
        "publishFormat": "JSON"
      };
      String myJson = jsonEncode(payload);
      String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/quotes';
      Map<String, String> niftyheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };
      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: niftyheader,
        body: myJson,
      );
      print(secondResponse);
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];
        print(listQuotes);
        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == 26001) {
            lastTradedPriceBankNifty = quoteData['Touchline']['LastTradedPrice'];
            print('lastTradedPriceNifty $lastTradedPriceBankNifty');
          } else {
            print('bhag yha se');
          }
        }
      } else {
        // Print the error status code and response body
        print('Error in nifty: ${secondResponse.statusCode}');
        print('Response Body: ${secondResponse.body}');
      }
    } catch (e) {
      print('Error fetching nifty data: $e');
    }
    await intrumentIDBankNiftyOption();
  }
  Future<void> finniftyPrice() async {
    print('Hello');
    try {
      Map<String, dynamic> payload =
      {
        "isTradeSymbol": "true",
        "instruments": [
          {"exchangeSegment": 1, "exchangeInstrumentID": 26034},
        ],
        "xtsMessageCode": 1502,
        "publishFormat": "JSON"
      };
      String myJson = jsonEncode(payload);
      String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/quotes';
      Map<String, String> niftyheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };
      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: niftyheader,
        body: myJson,
      );
      print(secondResponse);
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];
        print(listQuotes);
        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == 26034) {
            lastTradedPriceFinNifty = quoteData['Touchline']['LastTradedPrice'];
            print('lastTradedPriceNifty $lastTradedPriceFinNifty');
          } else {
            print('bhag yha se');
          }
        }
      } else {
        // Print the error status code and response body
        print('Error in nifty: ${secondResponse.statusCode}');
        print('Response Body: ${secondResponse.body}');
      }
    } catch (e) {
      print('Error fetching nifty data: $e');
    }
    await intrumentIDFinniftyOption();
  }
  Future<void> midcpniftyPrice() async {
    print('Hello');
    try {
      Map<String, dynamic> payload =
      {
        "isTradeSymbol": "true",
        "instruments": [
          {"exchangeSegment": 1, "exchangeInstrumentID": 26121},
        ],
        "xtsMessageCode": 1502,
        "publishFormat": "JSON"
      };
      String myJson = jsonEncode(payload);
      String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/quotes';
      Map<String, String> niftyheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };
      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: niftyheader,
        body: myJson,
      );
      print(secondResponse);
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];
        print(listQuotes);
        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == 26121) {
            lastTradedPriceMidCpNifty = quoteData['Touchline']['LastTradedPrice'];
            print('lastTradedPriceMidCpNifty $lastTradedPriceMidCpNifty');
          } else {
            print('bhag yha se');
          }
        }
      } else {
        // Print the error status code and response body
        print('Error in nifty: ${secondResponse.statusCode}');
        print('Response Body: ${secondResponse.body}');
      }
    } catch (e) {
      print('Error fetching nifty data: $e');
    }
   await intrumentIDMidCpNiftyOption();
  }

  @override
  void initState() {
    super.initState();
   // NameOfOPtion();
    niftyFiftyPrice();
    // print('init called');
    // finniftyPrice();
    // midcpniftyPrice();
    // bankNiftyPrice();
  }

  Future<void> _fetchNiftyOptions() async {
    await intrumentIDNiftyOption(); // Wait for the completion of the async method
    _navigateToHomeScreen();
    niftyFiftyPrice();
  }

  void _navigateToHomeScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          interactiveSessionToken: widget.interactiveSessionToken,
          marketSessionToken: widget.marketSessionToken,
        ),
      ),
          (route) => false,
    );
  }
  String? exchangeInstrumentID;
  double? lastTradePriceATMOP;


  Future<void> intrumentIDNiftyOption() async {
    String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/master';

    // Define the headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${widget.marketSessionToken}'
    };

    // Define the request body
    String requestBody = jsonEncode({
      "exchangeSegmentList": ["NSEFO"]
    });

    // Make the HTTP POST request
    http.Response response =
    await http.post(Uri.parse(url), headers: headers, body: requestBody);

    // Check if the request was successful (status code 200)
    try {
      String month = monthController.text.trim();
      String date = dateController.text.trim();
      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> jsonDataMap = jsonDecode(response.body);

        // Extract the 'result' string from the JSON response
        String result = jsonDataMap['result'];

        // Split the 'result' string by newline character
        List<String> instruments = result.split('\n');

        // Initialize a counter for names containing 'APR'
        int aprCount = 0;
        // Iterate over each instrument to find NIFTY and extract its ExchangeInstrumentID and name
        double roundedNifty = roundToNearest50(lastTradedPriceNifty);
        String NIFTYCEATM = '${roundedNifty.toInt()}CE';
        // print("NIFTYATM $NIFTYCEATM");
        String NIFTYPEATM = '${(roundedNifty + 50).toInt()}PE';
        for (String instrument in instruments) {
          List<String> fields = instrument.split('|');
          if (fields.length >= 4 && fields[3] == 'NIFTY') {
            String exchangeSegment = fields[0];
            exchangeInstrumentID = fields[1];
            String name = fields[4];
            SharedPreferences prefs = await SharedPreferences.getInstance();
            print(name);
            if (name.contains('116')){
              print('$name'); // Print the name for debugging
              // if (name.trim() == '${NIFTYCEATM.toString()}CE'.trim()) {
              print('NIFTYPEATM$NIFTYPEATM');
              if (name.contains('${NIFTYCEATM.trim()}')) {
                print('$name NIFTYCEATMStart $NIFTYCEATM' ); // Print the name for debugging
                prefs.setString('NIFTYCEATM', '$exchangeInstrumentID');
                prefs.setString('NIFTYCEATMNAME', '$name');
                print(
                    'ExchangeInstrumentID for NIFTY: $exchangeSegment-$exchangeInstrumentID, Name: $name');
              }
               if(name.contains('${NIFTYPEATM.trim()}')){
                print('NIFTYPEATMstart $NIFTYPEATM');
                prefs.setString('NIFTYPEATM', '$exchangeInstrumentID');
                prefs.setString('NIFTYPEATMNAME', '$name');
                print(
                    'ExchangeInstrumentID for NIFTY: $exchangeSegment-$exchangeInstrumentID, Name: $name');
              }else{
                print('not got');
              }
            }
          }
          //await niftyOptionPrice();
        }
        //   print('Total names containing "APR": $aprCount');
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } finally {
      Navigator.pushAndRemoveUntil(
          context,MaterialPageRoute(
              builder: (context) => HomeScreen(
                  interactiveSessionToken: widget.interactiveSessionToken,
                  marketSessionToken: widget.marketSessionToken)),
              (route) => false);
    }
    //await NameOfOPtion();
  }
  Future<void> intrumentIDBankNiftyOption() async {
    String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/master';

    // Define the headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${widget.marketSessionToken}'
    };

    // Define the request body
    String requestBody = jsonEncode({
      "exchangeSegmentList": ["NSEFO"]
    });

    // Make the HTTP POST request
    http.Response response =
    await http.post(Uri.parse(url), headers: headers, body: requestBody);

    // Check if the request was successful (status code 200)
    try {
      String month = monthController.text.trim();
      String date = dateController.text.trim();
      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> jsonDataMap = jsonDecode(response.body);

        // Extract the 'result' string from the JSON response
        String result = jsonDataMap['result'];

        // Split the 'result' string by newline character
        List<String> instruments = result.split('\n');

        // Initialize a counter for names containing 'APR'
        int aprCount = 0;
        // Iterate over each instrument to find NIFTY and extract its ExchangeInstrumentID and name
        double roundedNifty = roundToNearest100(lastTradedPriceBankNifty);
        String BANKNIFTYCEATM = '${roundedNifty.toInt()}CE';
        // print("NIFTYATM $NIFTYCEATM");
        String BANKNIFTYPEATM = '${(roundedNifty + 100).toInt()}PE';
        for (String instrument in instruments) {
          List<String> fields = instrument.split('|');
          if (fields.length >= 4 && fields[3] == 'BANKNIFTY') {
            String exchangeSegment = fields[0];
            exchangeInstrumentID = fields[1];
            String name = fields[4];
            SharedPreferences prefs = await SharedPreferences.getInstance();
            //double roundedNifty  = roundToNearest50(22701);


            if (name.contains('16')){
              // print('month ${monthController.text.trim()} date ${dateController.text.trim()}');
              print('$name'); // Print the name for debugging
              // if (name.trim() == '${NIFTYCEATM.toString()}CE'.trim()) {
              print('BANKNIFTYPEATM$BANKNIFTYPEATM');
              if (name.contains('${BANKNIFTYCEATM.trim()}')) {
                print('$name BANKNIFTYCEATMStart $BANKNIFTYCEATM' ); // Print the name for debugging
                prefs.setString('BANKNIFTYCEATM', '$exchangeInstrumentID');
                prefs.setString('BANKNIFTYCEATMNAME', '$name');
                print(
                    'ExchangeInstrumentID for NIFTY: $exchangeSegment-$exchangeInstrumentID, Name: $name');
              }
              if(name.contains('${BANKNIFTYPEATM.trim()}')){
                print('BANKNIFTYPEATMstart $BANKNIFTYPEATM');
                prefs.setString('BANKNIFTYPEATM', '$exchangeInstrumentID');
                prefs.setString('BANKNIFTYPEATMNAME', '$name');
                print(
                    'ExchangeInstrumentID for NIFTY: $exchangeSegment-$exchangeInstrumentID, Name: $name');
              }else{
                print('not got');
              }
            }
          }
          //await niftyOptionPrice();
        }
        //   print('Total names containing "APR": $aprCount');
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } finally {
      Navigator.pushAndRemoveUntil(
          context,MaterialPageRoute(
          builder: (context) => HomeScreen(
              interactiveSessionToken: widget.interactiveSessionToken,
              marketSessionToken: widget.marketSessionToken)),
              (route) => false);
    }
    //await NameOfOPtion();
  }
  Future<void> intrumentIDFinniftyOption() async {
    String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/master';

    // Define the headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${widget.marketSessionToken}'
    };

    // Define the request body
    String requestBody = jsonEncode({
      "exchangeSegmentList": ["NSEFO"]
    });

    // Make the HTTP POST request
    http.Response response =
    await http.post(Uri.parse(url), headers: headers, body: requestBody);

    // Check if the request was successful (status code 200)
    try {
      String month = monthController.text.trim();
      String date = dateController.text.trim();
      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> jsonDataMap = jsonDecode(response.body);

        // Extract the 'result' string from the JSON response
        String result = jsonDataMap['result'];

        // Split the 'result' string by newline character
        List<String> instruments = result.split('\n');

        // Initialize a counter for names containing 'APR'
        int aprCount = 0;
        // Iterate over each instrument to find NIFTY and extract its ExchangeInstrumentID and name
        double roundedNifty = roundToNearest50(lastTradedPriceFinNifty);
        String FINNIFTYCEATM = '${roundedNifty.toInt()}CE';
        // print("NIFTYATM $NIFTYCEATM");
        String FINNIFTYPEATM = '${(roundedNifty + 50).toInt()}PE';
        for (String instrument in instruments) {
          List<String> fields = instrument.split('|');
          if (fields.length >= 4 && fields[3] == 'FINNIFTY') {
            String exchangeSegment = fields[0];
            exchangeInstrumentID = fields[1];
            String name = fields[4];
            SharedPreferences prefs = await SharedPreferences.getInstance();
            //double roundedNifty  = roundToNearest50(22701);


            if (name.contains('24N05')){
              // print('month ${monthController.text.trim()} date ${dateController.text.trim()}');
              print('$name'); // Print the name for debugging
              // if (name.trim() == '${NIFTYCEATM.toString()}CE'.trim()) {
              print('FINNIFTYPEATM$FINNIFTYPEATM');
              if (name.contains('${FINNIFTYCEATM.trim()}')) {
                print('$name FINNIFTYCEATMStart $FINNIFTYCEATM' ); // Print the name for debugging
                prefs.setString('FINNIFTYCEATM', '$exchangeInstrumentID');
                prefs.setString('FINNIFTYCEATMNAME', '$name');
                print(
                    'ExchangeInstrumentID for FINNIFTY: $exchangeSegment-$exchangeInstrumentID, Name: $name');
              }
              if(name.contains('${FINNIFTYPEATM.trim()}')){
                print('FINNIFTYPEATMstart $FINNIFTYPEATM');
                prefs.setString('FINNIFTYPEATM', '$exchangeInstrumentID');
                prefs.setString('FINNIFTYPEATMNAME', '$name');
                print(
                    'ExchangeInstrumentID for FINNIFTY: $exchangeSegment-$exchangeInstrumentID, Name: $name');
              }else{
                print('not got');
              }
            }
          }
          //await niftyOptionPrice();
        }
        //   print('Total names containing "APR": $aprCount');
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } finally {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                  interactiveSessionToken: widget.interactiveSessionToken,
                  marketSessionToken: widget.marketSessionToken)),
              (route) => false);
    }
    //await NameOfOPtion();
  }
  Future<void> intrumentIDMidCpNiftyOption() async {
    String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/master';

    // Define the headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '${widget.marketSessionToken}'
    };


    // Define the request body
    String requestBody = jsonEncode({
      "exchangeSegmentList": ["NSEFO"]
    });

    // Make the HTTP POST request
    http.Response response =
    await http.post(Uri.parse(url), headers: headers, body: requestBody);

    // Check if the request was successful (status code 200)
    try {
      String month = monthController.text.trim();
      String date = dateController.text.trim();
      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> jsonDataMap = jsonDecode(response.body);

        // Extract the 'result' string from the JSON response
        String result = jsonDataMap['result'];

        // Split the 'result' string by newline character
        List<String> instruments = result.split('\n');

        // Initialize a counter for names containing 'APR'
        int aprCount = 0;
        // Iterate over each instrument to find NIFTY and extract its ExchangeInstrumentID and name
        double roundedMidCpNifty = roundToNearest25(lastTradedPriceMidCpNifty);
        String MIDCPNIFTYCEATM = '${roundedMidCpNifty.toInt()}CE';
        // print("NIFTYATM $NIFTYCEATM");
        String MIDCPNIFTYPEATM = '${(roundedMidCpNifty + 25).toInt()}PE';
        for (String instrument in instruments) {
          List<String> fields = instrument.split('|');
          if (fields.length >= 4 && fields[3] == 'MIDCPNIFTY') {
            String exchangeSegment = fields[0];
            exchangeInstrumentID = fields[1];
            String name = fields[4];
            SharedPreferences prefs = await SharedPreferences.getInstance();
            //double roundedNifty  = roundToNearest50(22701);


            if (name.contains('24N04')){
              // print('month ${monthController.text.trim()} date ${dateController.text.trim()}');
              print('$name'); // Print the name for debugging
              // if (name.trim() == '${NIFTYCEATM.toString()}CE'.trim()) {
              print('MIDCPNIFTY$MIDCPNIFTYPEATM');
              if (name.contains('${MIDCPNIFTYCEATM.trim()}')) {
                print('$name MIDCPNIFTYCEATMStart $MIDCPNIFTYCEATM' ); // Print the name for debugging
                prefs.setString('MIDCPNIFTYCEATM', '$exchangeInstrumentID');
                prefs.setString('MIDCPNIFTYCEATMNAME', '$name');
                print(
                    'ExchangeInstrumentID for MIDCPNIFTY: $exchangeSegment-$exchangeInstrumentID, Name: $name');
              }
              if(name.contains('${MIDCPNIFTYPEATM.trim()}')){
                print('MIDCPNIFTYPEATMstart $MIDCPNIFTYPEATM');
                prefs.setString('MIDCPNIFTYPEATM', '$exchangeInstrumentID');
                prefs.setString('MIDCPNIFTYPEATMNAME', '$name');
                print(
                    'ExchangeInstrumentID for MIDCPNIFTY: $exchangeSegment-$exchangeInstrumentID, Name: $name');
              }else{
                print('not got');
              }
            }
          }
          //await niftyOptionPrice();
        }
        //   print('Total names containing "APR": $aprCount');
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } finally {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                  interactiveSessionToken: widget.interactiveSessionToken,
                  marketSessionToken: widget.marketSessionToken)),
              (route) => false);
    }
    //await NameOfOPtion();
  }




  @override
  Widget build(BuildContext context){
    return  Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Wait!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),),
            // Padding(
            //   padding: EdgeInsets.all(20),
            //   child: TextFormField(
            //     controller: monthController,
            //     decoration: InputDecoration(
            //         hintText: 'Write Month',
            //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
            //     ),
            //   ),
            // ),
            // SizedBox(height: 15,),
            // Padding(
            //   padding: EdgeInsets.all(20),
            //   child: TextFormField(
            //     controller: dateController,
            //     decoration: InputDecoration(
            //         hintText: 'Write Date',
            //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
            //     ),
            //   ),
            // ),
            // ElevatedButton(
            //     onPressed: ()async{
            //       print('hii');
            //       await niftyFiftyPrice();
            // }, child: Text('Go'))
          ]
        )
      )
    );
  }
  //Rounding the nifty 50 price
double roundToNearest50(double number) {
  // Calculate the remainder when dividing the number by 50
  double remainder = number % 50;
  // If the remainder is less than or equal to 25, round down
  if (remainder <= 49) {
    return number - remainder;
  }
  // If the remainder is greater than 25, round up
  else {
    return number + (50 - remainder);
  }
}
  double roundToNearest25(double number) {
    // Calculate the remainder when dividing the number by 50
    double remainder = number % 25;
    // If the remainder is less than or equal to 25, round down
    if (remainder <= 24) {
      return number - remainder;
    }
    // If the remainder is greater than 25, round up
    else {
      return number + (25 - remainder);
    }
  }
  double roundToNearest100(double number) {
    // Calculate the remainder when dividing the number by 50
    double remainder = number % 100;
    // If the remainder is less than or equal to 25, round down
    if (remainder <= 99) {
      return number - remainder;
    }
    // If the remainder is greater than 25, round up
    else {
      return number + (100 - remainder);
    }
  }

}
