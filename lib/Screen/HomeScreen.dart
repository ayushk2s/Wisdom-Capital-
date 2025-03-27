
import 'package:flutter/material.dart';
import 'package:hanuman/Screen/DifferentIndex/FINNIFTY.dart';
import 'package:hanuman/Screen/DifferentIndex/MIDCPNIFTY.dart';
import 'package:hanuman/Screen/DifferentIndex/NIFTY.dart';
import 'package:hanuman/Screen/DifferentIndex/BANKNIFTY.dart';

class HomeScreen extends StatefulWidget{
String? interactiveSessionToken;
String? marketSessionToken;
HomeScreen({super.key , required this.interactiveSessionToken, required this.marketSessionToken});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NIFTY(
            interactiveSessionToken: widget.interactiveSessionToken,
            marketSessionToken: widget.marketSessionToken,)));
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NIFTY(
                      interactiveSessionToken: widget.interactiveSessionToken,
                      marketSessionToken: widget.marketSessionToken,)));
              },
                child: Text("NIFTY", style: TextStyle(fontSize: 25),)),
            SizedBox(height: 20),
            InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FINNIFTY(
                        interactiveSessionToken: widget.interactiveSessionToken,
                        marketSessionToken: widget.marketSessionToken,)));
                },
                child: Text("FINNIFTY", style: TextStyle(fontSize: 25),)),
            SizedBox(height: 20),
            InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MIDCPNIFTY(
                        interactiveSessionToken: widget.interactiveSessionToken,
                        marketSessionToken: widget.marketSessionToken,)));
                },
                child: Text("MIDCPNIFTY", style: TextStyle(fontSize: 25),)),
            SizedBox(height: 20),
            InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BANKNIFTY(
                        interactiveSessionToken: widget.interactiveSessionToken,
                        marketSessionToken: widget.marketSessionToken,)));
                },
                child: Text("BANKNIFTY", style: TextStyle(fontSize: 25),)),
          ],
        ),
      ),
    );
  }

}

// class _HomeScreenState extends State<HomeScreen> {
//   // List<BalanceModel> balanceModels = [];
//   List<int> AppOrderID = [];
//   TextEditingController profitAmountController = TextEditingController();
//   TextEditingController lotSizeController = TextEditingController();
//   TextEditingController slController = TextEditingController();
//   BalanceModel? balanceModel;
//   bool isLoading = false;
//   double? netMarginAvailable;
//   double? cashAvailable;
//   var myProfitAndLoss = 0.0;
//   String? totalProfit;
//   // LiveNifty50Price liveNifty50Price = LiveNifty50Price();
//   String? niftyLivePrice;
//   String? typeExampleEQ;
//   StreamController<String> _niftyStream = StreamController<String>();
//   late Timer _timer;
//   bool _isStreaming = false;
//   double? lastTradedPriceNifty;
//   double? lastTradedPriceNiftyCE;
//   double? lastTradedPriceNiftyPE;
//   double yesterdayNiftyPriceComparison = 0.0;
//
//
  // void niftyLiveStream() async {
  //   _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
  //     niftyFiftyPrice();
  //     niftyPEATMData();
  //     niftyCEATMData();
  //   });
  // }
//
//   // void profitloseupdate() async {
//   //   _timer = Timer.periodic(Duration(seconds: 2), (timer) {
//   //     MyProfitAndLoss();
//   //   });
//   // }
//
//   Future<void> niftyFiftyPrice() async {
//     // print('Halo');
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       Map<String, dynamic> payload =
//       {
//         "isTradeSymbol": "true",
//         "instruments":
//         [
//           { "exchangeSegment": 1, "exchangeInstrumentID": 26004},
//         ],
//         "xtsMessageCode": 1502,
//         "publishFormat": "JSON"
//       };
//       String myJson = jsonEncode(payload);
//       String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/quotes';
//       Map<String, String> niftyheader = {
//         'Content-Type': 'application/json',
//         'authorization': '${widget.marketSessionToken}',
//       };
//       http.Response secondResponse = await http.post(
//         Uri.parse(url),
//         headers: niftyheader,
//         body: myJson,
//       );
//       if (secondResponse.statusCode == 200) {
//         Map<String, dynamic> responseData = json.decode(secondResponse.body);
//         List<dynamic> listQuotes = responseData['result']['listQuotes'];
//         for (var quote in listQuotes) {
//           Map<String, dynamic> quoteData = jsonDecode(quote);
//           if (quoteData['ExchangeInstrumentID'] == 26004) {
//             lastTradedPriceNifty = quoteData['Touchline']['LastTradedPrice'];
//           //  print('lastTradedPriceNifty ${lastTradedPriceNifty}');
//           } else {
//             print('bhag yha se');
//           }
//         }
//       } else {
//         print('errors in nifty ${secondResponse.statusCode}');
//       }
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print('error $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
// //trying
// //   Future<void> niftyFiftyPrice2() async {
// //     try {
// //       setState(() {
// //         isLoading = true;
// //       });
// //
// //       // Establish WebSocket connection
// //       final channel = IOWebSocketChannel.connect('wss://trade.wisdomcapital.in/apimarketdata/instruments/quotes');
// //
// //       // Send payload through WebSocket
// //       Map<String, dynamic> payload = {
// //         "isTradeSymbol": "true",
// //         "instruments": [{"exchangeSegment": 1, "exchangeInstrumentID": 26000}],
// //         "xtsMessageCode": 1502,
// //         "publishFormat": "JSON"
// //       };
// //       String myJson = jsonEncode(payload);
// //       channel.sink.add(myJson);
// //
// //       // Listen for messages from the server
// //       channel.stream.listen((message) {
// //         Map<String, dynamic> responseData = json.decode(message);
// //         List<dynamic> listQuotes = responseData['result']['listQuotes'];
// //         for (var quote in listQuotes) {
// //           Map<String, dynamic> quoteData = jsonDecode(quote);
// //           if (quoteData['ExchangeInstrumentID'] == 26000) {
// //              = quoteData['Touchline']['LastTradedPrice'];
// //             print('lastTradedPriceNifty ${lastTradedPriceNifty}');
// //           } else {
// //             print('bhag yha se');
// //           }
// //         }
// //       });
// //
// //       // Close the WebSocket connection
// //       channel.sink.close();
// //
// //       setState(() {
// //         isLoading = false;
// //       });
// //     } catch (e) {
// //       print('error $e');
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }
//
//
//   String? NIFTYATMCENAME;
//   String? NIFTYATMPENAME;
//   String? NIFTYCEATM;
//   String? NIFTYPEATM;
//   Future<void> NameOfOPtion() async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     NIFTYATMCENAME = await prefs.getString('NIFTYCEATMNAME');
//     NIFTYATMPENAME = await prefs.getString('NIFTYPEATMNAME');
//     NIFTYCEATM = await prefs.getString('NIFTYCEATM');
//     NIFTYPEATM = await prefs.getString('NIFTYPEATM');
//     print('NIFTYATMCENAME $NIFTYATMCENAME nifyt ce instru $NIFTYCEATM NIFTYATMPENAME $NIFTYATMPENAME NIFTYPEATM $NIFTYPEATM');
//     niftyPEATMData();
//     niftyCEATMData();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//      //niftyLiveStream();
//         niftyFiftyPrice();
//
//     niftyFiftyPrice();
//     //niftyFiftyPrice();
//     NameOfOPtion();
//     balanceFunction();
//     print('Tokens ${widget.interactiveSessionToken}\n ${widget
//         .marketSessionToken}');
//     MyProfitAndLoss();
//   }
//
//   @override
//   void dispose() {
//     // Cancel the timer when the widget is disposed
//     _timer.cancel();
//     _niftyStream.close();
//     super.dispose();
//   }
//
//   //BalanceData
//   var mydata;
//
//   //Future<List<BalanceModel>>
//
//   balanceFunction() async {
//     String secondUrl = 'https://trade.wisdomcapital.in/interactive/user/balance?clientID=WD3278';
//     Map<String, String> secondHeaders = {
//       'Content-Type': 'application/json',
//       'authorization': '${widget.interactiveSessionToken}',
//     };
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       http.Response secondResponse = await http.get(
//         Uri.parse(secondUrl),
//         headers: secondHeaders,
//       );
//
//       if (secondResponse.statusCode == 200) {
//         Map<String, dynamic> responseData = json.decode(secondResponse.body);
//         // Extract the marginAvailable object from the result
//         Map<String, dynamic> marginAvailable = responseData['result']['BalanceList'][0]['limitObject']['RMSSubLimits'];
//
//         // Extract cashAvailable and netMarginAvailable values
//         setState(() {
//           cashAvailable = double.tryParse(marginAvailable['cashAvailable']);
//           netMarginAvailable = double.tryParse(marginAvailable['netMarginAvailable']);
//         });
//         print('Cash Available $cashAvailable net margin $netMarginAvailable');
//         print('response data balance $responseData');
//       } else {
//         print('Failed with status code: ${secondResponse.statusCode}');
//         setState(() {
//           isLoading = false;
//         });
//         // return [];
//       }
//     } catch (error) {
//       print('Error fetching user profile: $error');
//       setState(() {
//         isLoading = false;
//       });
//       //return [];
//     }
//   }
//
//   //* Widget build goes after this */
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title:  InkWell(
//             onTap: (){
//               Get.to(()=>OrderList(), arguments: widget.interactiveSessionToken);
//             },
//             child: Text(
//                 "Radhey Radhey ", style: TextStyle(color: Colors.blue)),
//           ),
//           leading: FittedBox(
//             child: ElevatedButton(
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.black)),
//                 onPressed: () {
//                   if (mounted) { // Check if the widget is mounted
//                     setState(() {
//                       yesterdayNiftyPriceComparison =
//                           lastTradedPriceNifty ?? yesterdayNiftyPriceComparison;
//                       print(yesterdayNiftyPriceComparison);
//                     });
//                     Get.snackbar('Note', 'Nifty Updated');
//                   }
//                 },
//                 child: Icon(Icons.update, color: Colors.green, size: 40,)
//             ),
//           ),
//           actions: [
//             Container(
//               width: MediaQuery.of(context).size.width*0.2,
//               child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                   onPressed: () async {
//                     try {
//                       //Interactive Data Session Log Out
//                       Map<String, String> deleteHeader = {
//                         'Content-Type': 'application/json',
//                         'authorization': '${widget.interactiveSessionToken}',
//                       };
//                       String interactiveUrlDelete = 'https://trade.wisdomcapital.in/interactive/user/session';
//                       http.Response deleteResponse = await http.delete(
//                         Uri.parse(interactiveUrlDelete),
//                         headers: deleteHeader,
//                       );
//                       //Market Data Session Log Out
//                       Map<String, String> deleteHeaderMarket = {
//                         'Content-Type': 'application/json',
//                         'authorization': '${widget.marketSessionToken}',
//                       };
//                       String marketUrlDelete = 'https://trade.wisdomcapital.in/apimarketdata/auth/logout';
//
//                       http.Response deleteResponseMarket = await http.delete(
//                         Uri.parse(marketUrlDelete),
//                         headers: deleteHeaderMarket,
//                       );
//                       if (deleteResponse.statusCode == 200 &&
//                           deleteResponseMarket.statusCode == 200) {
//                         SharedPreferences prefs = await SharedPreferences
//                             .getInstance();
//                         prefs.remove('interactiveSessionToken');
//                         prefs.remove('marketSessionToken');
//                         print(deleteResponse.body.toString());
//                         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
//                             builder: (context) => InteractiveLoginSession()), (
//                             route) => false);
//                         Get.snackbar('Successfully', 'Logged Out');
//                       }
//                     } catch (e) {
//
//                     }
//                   },
//                   child: Icon(Icons.exit_to_app, color: Colors.black,)),
//             )
//           ],
//         ),
//         body: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               //Text('Cash Used $cashAvailable'),
//               Center(child: Text('Balance: $netMarginAvailable', style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold),)),
//               Center(child:
//               Stack(
//                 children: <Widget>[
//                   lastTradedPriceNifty != null ?
//                   lastTradedPriceNifty! >= yesterdayNiftyPriceComparison ?
//                   Text('Nifty: ${lastTradedPriceNifty!.toStringAsFixed(2)}', style: TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25),) :
//                   Text('Nifty: ${lastTradedPriceNifty!.toStringAsFixed(2)}', style: TextStyle(
//                       color: Colors.red,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25),) :
//                   Text('Nifty: Loading...', style: TextStyle(color: Colors.grey,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25),),
//                 ],
//               ),
//               ),
//               SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: slController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                       hintText: 'StopLoss Amount...',
//                       border: OutlineInputBorder()
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: profitAmountController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     hintText: 'Profit Amount...',
//                     border: OutlineInputBorder()
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: lotSizeController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                       hintText: 'Number of Lot...',
//                       border: OutlineInputBorder()
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text('${NIFTYATMCENAME!.substring(10)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
//                   Text('${NIFTYATMPENAME!.substring(10)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   lastTradedPriceNiftyCE != null ?
//                   Text('$lastTradedPriceNiftyCE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green) ):
//                   Text('Option: Loading...', style: TextStyle(color: Colors.grey,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25),),
//                   lastTradedPriceNiftyPE != null ?
//                   Text('$lastTradedPriceNiftyPE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green) ) :
//                   Text('Option: Loading...', style: TextStyle(color: Colors.grey,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25),),
//
//                 ],
//               ),
//               SizedBox(height: 30,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                       onPressed: () async{
//                         //Call Buy Function
//                         await NiftyCallBuyBracketOrder();
//                         }, child: Text("Call")),
//                   ElevatedButton(
//                       onPressed: ()async{
//                         //Function perform
//                         await NiftyPutBuyBracketOrder();
//                       }, child: Text("Put"))
//                 ],
//               ),
//               SizedBox(height: 30,),
//               InkWell(
//                   onTap: ()async{
//                     await ExitAnyOrder();
//                   },
//                   child: Container(
//                     alignment: Alignment.center,
//                     width: MediaQuery.of(context).size.width*0.7,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text('Exit All', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),))),
//               SizedBox(height: 30,),
//
//
//                 myProfitAndLoss != null && myProfitAndLoss.isNegative == true ?
//                 Center(
//                   child: Text(
//                     'Profit And Loss: $myProfitAndLoss',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.red),
//                   ),
//                 )
//                     :  Center(
//                   child: Text(
//                     'Profit And Loss: $myProfitAndLoss',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.green),
//                   ),
//                 ),
//             ],
//           ),
//         )
//
//     );
//   }
//
//   //Option Data CE
//
//   Future<void> niftyCEATMData() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       int ceEntrumentID = int.parse(NIFTYCEATM!);
//       print('ceEntrumentID $ceEntrumentID');
//       Map<String, dynamic> payload = {
//         "isTradeSymbol": "true",
//         "instruments": [
//           {"exchangeSegment": 2, "exchangeInstrumentID": ceEntrumentID},
//         ],
//         "xtsMessageCode": 1502,
//         "publishFormat": "JSON"
//       };
//       String myJson = jsonEncode(payload);
//       String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/quotes';
//       Map<String, String> niftyheader = {
//         'Content-Type': 'application/json',
//         'authorization': '${widget.marketSessionToken}',
//       };
//       http.Response secondResponse = await http.post(
//         Uri.parse(url),
//         headers: niftyheader,
//         body: myJson,
//       );
//       if (secondResponse.statusCode == 200) {
//         Map<String, dynamic> responseData = json.decode(secondResponse.body);
//         List<dynamic> listQuotes = responseData['result']['listQuotes'];
//         for (var quote in listQuotes) {
//           Map<String, dynamic> quoteData = jsonDecode(quote);
//           if (quoteData['ExchangeInstrumentID'] == ceEntrumentID) {
//             // Convert int to double here
//             lastTradedPriceNiftyCE = quoteData['Touchline']['LastTradedPrice'].toDouble();
//             // if(callCount == 1 && callCountTrade == lastTradedPriceNiftyCE){
//             //   ExitAnyOrder();
//             //   callCount = 0;
//             // }else{
//             //  // print('Cant sell');
//             // }
//           } else {
//             print('bhag yha seCE');
//           }
//         }
//       } else {
//         print('errors in niftyCE ${secondResponse.statusCode}');
//       }
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print('error in call $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//
//
// //Option Data PE
//
//   Future<void> niftyPEATMData() async {
//     // print('Halo');
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       int peEntrumentID = int.parse(NIFTYPEATM!);
//       print('pijh$peEntrumentID');
//       Map<String, dynamic> payload =
//       {
//         "isTradeSymbol": "true",
//         "instruments":
//         [
//           { "exchangeSegment": 2, "exchangeInstrumentID": peEntrumentID},
//         ],
//         "xtsMessageCode": 1502,
//         "publishFormat": "JSON"};
//       String myJson = jsonEncode(payload);
//       String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/quotes';
//       Map<String, String> niftyheader = {
//         'Content-Type': 'application/json',
//         'authorization': '${widget.marketSessionToken}',
//       };
//       http.Response secondResponse = await http.post(
//         Uri.parse(url),
//         headers: niftyheader,
//         body: myJson,
//       );
//       if (secondResponse.statusCode == 200) {
//         Map<String, dynamic> responseData = json.decode(secondResponse.body);
//         List<dynamic> listQuotes = responseData['result']['listQuotes'];
//         for (var quote in listQuotes) {
//           Map<String, dynamic> quoteData = jsonDecode(quote);
//           if (quoteData['ExchangeInstrumentID'] == peEntrumentID) {
//             lastTradedPriceNiftyPE = quoteData['Touchline']['LastTradedPrice'];
//             // if(putCount == 1 && callCountTrade == lastTradedPriceNiftyPE){
//             //   ExitAnyOrder();
//             //   callCount = 0;
//             // }else{
//             //   print('Cant sell');
//             // }
//           } else {
//             print('error');
//           }
//         }
//       } else {
//         print('errors in nifty PE ${secondResponse.statusCode}');
//       }
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print('error  in put $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   //Buying code CE
//   int callCount = 0;
//   int putCount =0;
//   double callCountTrade = 0;
//   //  Future<void> NiftyCallBuyATM() async{
//   //
//   //    try{
//   //      double profitAmount = double.parse(profitAmountController.text.trim());
//   //     String myCEUrl = 'https://trade.wisdomcapital.in/interactive/orders';
//   //     int? ceEntrumentID = int.tryParse(NIFTYCEATM!);
//   //   //  double profitAmount = double.parse(profitAmountController.text.trim());
//   //     int? lotSize = int.tryParse(lotSizeController.text.trim());
//   //     print('ceEntrumetnId $ceEntrumentID lotSize $lotSize');
//   //     int uniqueFilename = Random().nextInt(1000000);
//   //     Map<String, dynamic> payload =
//   //     {
//   //       "disclosedQuantity":0,
//   //       "exchangeSegment":"NSEFO",
//   //       "orderType":"MARKET",
//   //       "stopPrice":0,
//   //       "limitPrice":lastTradedPriceNiftyCE,
//   //       "orderUniqueIdentifier": "$uniqueFilename",
//   //       "exchangeInstrumentID":ceEntrumentID,
//   //       "orderSide":"BUY",
//   //       "timeInForce":"DAY",
//   //       "productType":"NRML",
//   //       "orderQuantity":lotSize
//   //     };
//   //     String jsonPayLoadCE = jsonEncode(payload);
//   //     Map<String, String> niftyCEheader = {
//   //       'Content-Type': 'application/json',
//   //       'authorization': '${widget.interactiveSessionToken}',
//   //     };
//   //     http.Response myCETrade = await http.post(
//   //      Uri.parse(myCEUrl),
//   //         headers: niftyCEheader,
//   //         body: jsonPayLoadCE
//   //     );
//   //     if(myCETrade.statusCode == 200){
//   //       Get.snackbar('Ho gya', 'Call me buy');
//   //       Map<String, dynamic> myCEresult = json.decode(myCETrade.body);
//   //       int niftyCallAppOrderId = myCEresult['result']['AppOrderID'];
//   //       print(niftyCallAppOrderId);
//   //       AppOrderID.add(niftyCallAppOrderId);
//   //       callCount = 1;
//   //       callCountTrade = lastTradedPriceNiftyCE! + profitAmount;
//   //     }else{
//   //       print('error while buy ${myCETrade.statusCode}');
//   //     }
//   //   }catch(e){
//   //     print('Error $e');
//   //   }
//   //  }
//   //
//   //  //Buying code PE
//   //  Future<void> NiftyPUTBuyATM() async{
//   //   try{
//   //     double profitAmount = double.parse(profitAmountController.text.trim());
//   //     String myCEUrl = 'https://trade.wisdomcapital.in/interactive/orders';
//   //     int? peEntrumentID = int.tryParse(NIFTYPEATM!);
//   //     int? lotSize = int.tryParse(lotSizeController.text.trim());
//   //     print('ceEntrumetnId $peEntrumentID lotSize $lotSize');
//   //     int uniqueFilename = Random().nextInt(1000000);
//   //     Map<String, dynamic> payload =
//   //     {
//   //       "disclosedQuantity":0,
//   //       "exchangeSegment":"NSEFO",
//   //       "orderType":"MARKET",
//   //       "stopPrice":0,
//   //       "limitPrice": lastTradedPriceNiftyPE,
//   //       "orderUniqueIdentifier": "$uniqueFilename",
//   //       "exchangeInstrumentID":peEntrumentID,
//   //       "orderSide":"BUY",
//   //       "timeInForce":"DAY",
//   //       "productType":"NRML",
//   //       "orderQuantity":lotSize
//   //     };
//   //     String jsonPayLoadCE = jsonEncode(payload);
//   //     Map<String, String> niftyCEheader = {
//   //       'Content-Type': 'application/json',
//   //       'authorization': '${widget.interactiveSessionToken}',
//   //     };
//   //     http.Response myCETrade = await http.post(
//   //         Uri.parse(myCEUrl),
//   //         headers: niftyCEheader,
//   //         body: jsonPayLoadCE
//   //     );
//   //     if(myCETrade.statusCode == 200){
//   //       Get.snackbar('Ho gya', 'Call me buy');
//   //       Map<String, dynamic> myCEresult = json.decode(myCETrade.body);
//   //       int niftyPutAppOrderId = myCEresult['result']['AppOrderID'];
//   //       AppOrderID.add(niftyPutAppOrderId);
//   //       callCount = 1;
//   //       callCountTrade = lastTradedPriceNiftyCE! + profitAmount;
//   //     }else{
//   //       print(myCETrade.statusCode);
//   //     }
//   //   }catch(e){
//   //     print('Error $e');
//   //   }
//   // }
//
//   //Booking P&L of any order
//
//    Future<void> ExitAnyOrder() async{
//     String exitOrderUrl = 'https://trade.wisdomcapital.in/interactive/orders/cover';
//     try{
//       AppOrderID.forEach((appOrderId) async{
//         Map<String, dynamic> exitCoverOrderPayload =
//         {
//           "appOrderID": appOrderId
//         };
//         String exitCoverOrderJson = json.encode(exitCoverOrderPayload);
//         Map<String, String> niftyCEheader = {
//           'Content-Type': 'application/json',
//           'authorization': '${widget.interactiveSessionToken}',
//         };
//         try{
//           http.Response exitOrderRequest = await http.put(
//             Uri.parse(exitOrderUrl),
//             body: exitCoverOrderJson,
//             headers: niftyCEheader,
//           );
//           if(exitOrderRequest.statusCode == 200){
//             // Map<String, dynamic> myCEresult = json.decode(exitOrderRequest.body);
//             Get.snackbar('Note', 'Request sent Exited for selling');
//           }else{
//             print('error while selling ${exitOrderRequest.statusCode}');
//           }
//         }catch(e){
//           print('Error while selling try catch $e');
//         }
//       });
//     }finally{
//       AppOrderID.clear();
//     }
// }
//
// // Putting profit code
// // Future<void> CoverMarketOrder() async{
// // String marketCoverUrl = 'https://trade.wisdomcapital.in/interactive/orders/bracket';
// // Map<String, String> niftyCEheader = {
// //   'Content-Type': 'application/json',
// //   'authorization': '${widget.marketSessionToken}',
// // };
// // }
//
//
// Future<void> NiftyCallBuyBracketOrder() async{
// final start = DateTime.now();
//   String bracketOrderCallUrl = 'https://trade.wisdomcapital.in/interactive/orders/bracket';
//
//   int? ceEntrumentID = int.tryParse(NIFTYCEATM!);
//     double profitAmount = double.parse(profitAmountController.text.trim());
//  // double? profitAmount = double.tryParse(profitAmountController.text.trim());
//   double slAmount = double.parse(slController.text.trim());
//
//   int? lotSize = int.tryParse(lotSizeController.text.trim());
//   print('ceEntrumetnId $ceEntrumentID lotSize $lotSize profit amount');
//   int uniqueFilename = Random().nextInt(1000000);
//   try{
//   Map<String, dynamic> bracketOrderPayload =
//   {
//     "clientID": "WD3278",
//     "exchangeSegment": "NSEFO",
//     "exchangeInstrumentID": ceEntrumentID,
//     "orderType": "MARKET",
//     "orderSide": "BUY",
//     "disclosedQuantity": 0,
//     "orderQuantity": lotSize,
//     "limitPrice": lastTradedPriceNiftyCE,
//     "stopLossPrice": slAmount,
//     "squarOff": profitAmount,
//     "trailingStoploss": profitAmount,
//     "orderUniqueIdentifier": '$uniqueFilename'
//   };
//   Map<String, String> bracketOrderHeader = {
//     'Content-Type': 'application/json',
//     'authorization': '${widget.interactiveSessionToken}',
//   };
//   String bracketOrderPayloadJson  = json.encode(bracketOrderPayload);
//
//     http.Response bracketOrderResponse = await http.post(
//       Uri.parse(bracketOrderCallUrl),
//       headers: bracketOrderHeader,
//       body: bracketOrderPayloadJson
//     );
//     if(bracketOrderResponse.statusCode == 200){
//       Map<String, dynamic> myBrackerCE = json.decode(bracketOrderResponse.body);
//       AppOrderID = myBrackerCE['result']['OrderID'];
//       Get.snackbar('Ho gya', 'Call me buy');
//       print('ho gya');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order Brought OrderId $AppOrderID')));
//     }else{
//       print('Error in bracket order: ${bracketOrderResponse.statusCode}');
//     }
//   }catch(e){
//     print('Error in bracket Order: $e');
//   }finally{
//     final end = DateTime.now();
//     final difference = start.difference(end);
//     print('time $difference');
//   }
// }
//
//   Future<void> NiftyPutBuyBracketOrder() async{
//
//     String bracketOrderCallUrl = 'https://trade.wisdomcapital.in/interactive/orders/bracket';
//
//     int? peEntrumentID = int.tryParse(NIFTYPEATM!);
//     double profitAmount = double.parse(profitAmountController.text.trim());
//     double slAmount = double.parse(slController.text.trim());
//     // double? profitAmount = double.tryParse(profitAmountController.text.trim());
//     int? lotSize = int.tryParse(lotSizeController.text.trim());
//     print('ceEntrumetnId $peEntrumentID lotSize $lotSize profit amount');
//     int uniqueFilename = Random().nextInt(1000000);
//     try{
//       Map<String, dynamic> bracketOrderPayload =
//       {
//         "clientID": "WD3278",
//         "exchangeSegment": "NSEFO",
//         "exchangeInstrumentID": peEntrumentID,
//         "orderType": "MARKET",
//         "orderSide": "BUY",
//         "disclosedQuantity": 0,
//         "orderQuantity": lotSize,
//         "limitPrice": lastTradedPriceNiftyPE,
//         "stopLossPrice": slAmount,
//         "squarOff": profitAmount,
//         "trailingStoploss": profitAmount,
//         "orderUniqueIdentifier": '$uniqueFilename'
//       };
//       Map<String, String> bracketOrderHeader = {
//         'Content-Type': 'application/json',
//         'authorization': '${widget.interactiveSessionToken}',
//       };
//       String bracketOrderPayloadJson  = json.encode(bracketOrderPayload);
//
//       http.Response bracketOrderResponse = await http.post(
//           Uri.parse(bracketOrderCallUrl),
//           headers: bracketOrderHeader,
//           body: bracketOrderPayloadJson
//       );
//       if(bracketOrderResponse.statusCode == 200){
//         Map<String, dynamic> myBrackerCE = json.decode(bracketOrderResponse.body);
//         AppOrderID = myBrackerCE['result']['OrderID'];
//         Get.snackbar('Ho gya', 'Call me buy');
//         print('ho gya');
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order Brought OrderId $AppOrderID')));
//       }else{
//         print('Error in bracket order: ${bracketOrderResponse.statusCode}');
//       }
//     }catch(e){
//       print('Error in bracket Order: $e');
//     }
//   }
//
//   //P&L
//   Future<void> MyProfitAndLoss() async {
//     myProfitAndLoss = 0.0;
//     try {
//       String url = 'https://trade.wisdomcapital.in/interactive/portfolio/positions?dayOrNet=DayWise';
//       Map<String, String> niftyheader = {
//         'Content-Type': 'application/json',
//         'authorization': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiJXRDMyNzhfMkU3NTY5REExRkMyNTZFRTI2QTY5OCIsInB1YmxpY0tleSI6IjJlNzU2OWRhMWZjMjU2ZWUyNmE2OTgiLCJpc0ludGVyYWN0aXZlIjp0cnVlLCJpYXQiOjE3MTUwMDkxMDQsImV4cCI6MTcxNTA5NTUwNH0.fM_9brZ-jy1fsQMuD7NZwGJtMgy_ioyfPWrH-z0sya8',
//       };
//       http.Response secondResponse = await http.get(
//         Uri.parse(url),
//         headers: niftyheader,
//       );
//       if (secondResponse.statusCode == 200) {
//         Map<String, dynamic> responseData = json.decode(secondResponse.body);
//         List<dynamic> positionList = responseData["result"]["positionList"];
//         print('positionList $positionList');
//         for (var position in positionList) {
//           var quoteData = position as Map<String, dynamic>; // Cast position to Map<String, dynamic>
//           if (quoteData.isNotEmpty) {
//             myProfitAndLoss += double.parse(quoteData["NetAmount"].toString());
//           } else {
//             print("No positions found.");
//           }
//         }
//       } else {
//         print('errors in nifty PE ${secondResponse.statusCode}');
//       }
//     } catch (e) {
//       print('error  in put $e');
//     } finally {
//             print('myProfitAndLoss $myProfitAndLoss');
//     }
//   }
// }






