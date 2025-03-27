import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanuman/Auth/IntractiveLoginSession.dart';
import 'package:hanuman/Models/BalanceModel.dart';
import 'package:hanuman/Screen/OrderHistory.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class FINNIFTY extends StatefulWidget{
  String? interactiveSessionToken;
  String? marketSessionToken;
  FINNIFTY({super.key , required this.interactiveSessionToken, required this.marketSessionToken});
  @override
  State<FINNIFTY> createState() => _FINNIFTYState();
}

class _FINNIFTYState extends State<FINNIFTY> {
  // List<BalanceModel> balanceModels = [];
  List<int> AppOrderID = [];
  TextEditingController profitAmountController = TextEditingController();
  TextEditingController lotSizeController = TextEditingController();
  TextEditingController slController = TextEditingController();
  BalanceModel? balanceModel;
  bool isLoading = false;
  double? netMarginAvailable;
  double? cashAvailable;
  var myProfitAndLoss = 0.0;
  String? totalProfit;
  // LiveFINNIFTY50Price liveFINNIFTY50Price = LiveFINNIFTY50Price();
  String? FINNIFTYLivePrice;
  String? typeExampleEQ;
  StreamController<String> _FINNIFTYStream = StreamController<String>();
  late Timer _timer;
  bool _isStreaming = false;
  double? lastTradedPriceFINNIFTY;
  double? lastTradedPriceFINNIFTYCE;
  double? lastTradedPriceFINNIFTYPE;
  double yesterdayFINNIFTYPriceComparison = 0.0;


  void FINNIFTYLiveStream() async {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      FINNIFTYPrice();
      FINNIFTYPEATMData();
      FINNIFTYCEATMData();
    });
  }

  // void profitloseupdate() async {
  //   _timer = Timer.periodic(Duration(seconds: 2), (timer) {
  //     MyProfitAndLoss();
  //   });
  // }

  Future<void> FINNIFTYPrice() async {
    // print('Halo');
    try {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> payload =
      {
        "isTradeSymbol": "true",
        "instruments":
        [
          { "exchangeSegment": 1, "exchangeInstrumentID": 26034},
        ],
        "xtsMessageCode": 1502,
        "publishFormat": "JSON"
      };
      String myJson = jsonEncode(payload);
      String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/quotes';
      Map<String, String> FINNIFTYheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };
      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: FINNIFTYheader,
        body: myJson,
      );
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];
        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == 26034) {
            lastTradedPriceFINNIFTY = quoteData['Touchline']['LastTradedPrice'];
            //  print('lastTradedPriceFINNIFTY ${lastTradedPriceFINNIFTY}');
          } else {
            print('bhag yha se');
          }
        }
      } else {
        print('errors in FINNIFTY ${secondResponse.statusCode}');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('error $e');
      setState(() {
        isLoading = false;
      });
    }
  }
//trying
//   Future<void> FINNIFTYFiftyPrice2() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });
//
//       // Establish WebSocket connection
//       final channel = IOWebSocketChannel.connect('wss://trade.wisdomcapital.in/apimarketdata/instruments/quotes');
//
//       // Send payload through WebSocket
//       Map<String, dynamic> payload = {
//         "isTradeSymbol": "true",
//         "instruments": [{"exchangeSegment": 1, "exchangeInstrumentID": 26034}],
//         "xtsMessageCode": 1502,
//         "publishFormat": "JSON"
//       };
//       String myJson = jsonEncode(payload);
//       channel.sink.add(myJson);
//
//       // Listen for messages from the server
//       channel.stream.listen((message) {
//         Map<String, dynamic> responseData = json.decode(message);
//         List<dynamic> listQuotes = responseData['result']['listQuotes'];
//         for (var quote in listQuotes) {
//           Map<String, dynamic> quoteData = jsonDecode(quote);
//           if (quoteData['ExchangeInstrumentID'] == 26034) {
//              = quoteData['Touchline']['LastTradedPrice'];
//             print('lastTradedPriceFINNIFTY ${lastTradedPriceFINNIFTY}');
//           } else {
//             print('bhag yha se');
//           }
//         }
//       });
//
//       // Close the WebSocket connection
//       channel.sink.close();
//
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


  String? FINNIFTYATMCENAME;
  String? FINNIFTYATMPENAME;
  String? FINNIFTYCEATM;
  String? FINNIFTYPEATM;
  Future<void> NameOfOPtion() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FINNIFTYATMCENAME = await prefs.getString('FINNIFTYCEATMNAME');
    FINNIFTYATMPENAME = await prefs.getString('FINNIFTYPEATMNAME');
    FINNIFTYCEATM = await prefs.getString('FINNIFTYCEATM');
    FINNIFTYPEATM = await prefs.getString('FINNIFTYPEATM');
    print('FINNIFTYATMCENAME $FINNIFTYATMCENAME nifyt ce instru $FINNIFTYCEATM FINNIFTYATMPENAME $FINNIFTYATMPENAME FINNIFTYPEATM $FINNIFTYPEATM');
    FINNIFTYLiveStream();
  }

  @override
  void initState() {
    super.initState();
    //FINNIFTYLiveStream();
    NameOfOPtion();

    //FINNIFTYPrice();
    balanceFunction();
    print('Tokens ${widget.interactiveSessionToken}\n ${widget.marketSessionToken}');
    MyProfitAndLoss();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    _FINNIFTYStream.close();
    super.dispose();
  }

  //BalanceData
  var mydata;

  //Future<List<BalanceModel>>

  balanceFunction() async {
    String secondUrl = 'https://trade.wisdomcapital.in/interactive/user/balance?clientID=WD3278';
    Map<String, String> secondHeaders = {
      'Content-Type': 'application/json',
      'authorization': '${widget.interactiveSessionToken}',
    };

    setState(() {
      isLoading = true;
    });

    try {
      http.Response secondResponse = await http.get(
        Uri.parse(secondUrl),
        headers: secondHeaders,
      );

      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        // Extract the marginAvailable object from the result
        Map<String, dynamic> marginAvailable = responseData['result']['BalanceList'][0]['limitObject']['RMSSubLimits'];

        // Extract cashAvailable and netMarginAvailable values
        setState(() {
          cashAvailable = double.tryParse(marginAvailable['cashAvailable']);
          netMarginAvailable = double.tryParse(marginAvailable['netMarginAvailable']);
        });
        print('Cash Available $cashAvailable net margin $netMarginAvailable');
        print('response data balance $responseData');
      } else {
        print('Failed with status code: ${secondResponse.statusCode}');
        setState(() {
          isLoading = false;
        });
        // return [];
      }
    } catch (error) {
      print('Error fetching user profile: $error');
      setState(() {
        isLoading = false;
      });
      //return [];
    }
  }

  //* Widget build goes after this */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  InkWell(
            onTap: (){
              Get.to(()=>OrderList(), arguments: widget.interactiveSessionToken);
            },
            child: Text(
                "Radhey Radhey ", style: TextStyle(color: Colors.blue)),
          ),
          leading: FittedBox(
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)),
                onPressed: () {
                  if (mounted) { // Check if the widget is mounted
                    setState(() {
                      yesterdayFINNIFTYPriceComparison =
                          lastTradedPriceFINNIFTY ?? yesterdayFINNIFTYPriceComparison;
                      print(yesterdayFINNIFTYPriceComparison);
                    });
                    Get.snackbar('Note', 'FINNIFTY Updated');
                  }
                },
                child: Icon(Icons.update, color: Colors.green, size: 40,)
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width*0.2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    try {
                      //Interactive Data Session Log Out
                      Map<String, String> deleteHeader = {
                        'Content-Type': 'application/json',
                        'authorization': '${widget.interactiveSessionToken}',
                      };
                      String interactiveUrlDelete = 'https://trade.wisdomcapital.in/interactive/user/session';
                      http.Response deleteResponse = await http.delete(
                        Uri.parse(interactiveUrlDelete),
                        headers: deleteHeader,
                      );
                      //Market Data Session Log Out
                      Map<String, String> deleteHeaderMarket = {
                        'Content-Type': 'application/json',
                        'authorization': '${widget.marketSessionToken}',
                      };
                      String marketUrlDelete = 'https://trade.wisdomcapital.in/apimarketdata/auth/logout';

                      http.Response deleteResponseMarket = await http.delete(
                        Uri.parse(marketUrlDelete),
                        headers: deleteHeaderMarket,
                      );
                      if (deleteResponse.statusCode == 200 &&
                          deleteResponseMarket.statusCode == 200) {
                        SharedPreferences prefs = await SharedPreferences
                            .getInstance();
                        prefs.remove('interactiveSessionToken');
                        prefs.remove('marketSessionToken');
                        print(deleteResponse.body.toString());
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                            builder: (context) => InteractiveLoginSession()), (
                            route) => false);
                        Get.snackbar('Successfully', 'Logged Out');
                      }
                    } catch (e) {

                    }
                  },
                  child: Icon(Icons.exit_to_app, color: Colors.black,)),
            )
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Text('Cash Used $cashAvailable'),
              Center(child: Text('Balance: $netMarginAvailable', style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),)),
              Center(child:
              Stack(
                children: <Widget>[
                  lastTradedPriceFINNIFTY != null ?
                  lastTradedPriceFINNIFTY! >= yesterdayFINNIFTYPriceComparison ?
                  Text('FINNIFTY: ${lastTradedPriceFINNIFTY!.toStringAsFixed(2)}', style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),) :
                  Text('FINNIFTY: ${lastTradedPriceFINNIFTY!.toStringAsFixed(2)}', style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),) :
                  Text('FINNIFTY: Loading...', style: TextStyle(color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),),
                ],
              ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: profitAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Profit %...',
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: slController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'StopLoss %...',
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: lotSizeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Number of Quantity...',
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('${FINNIFTYATMCENAME!.substring(10)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  Text('${FINNIFTYATMPENAME!.substring(10)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  lastTradedPriceFINNIFTYCE != null ?
                  Text('$lastTradedPriceFINNIFTYCE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green) ):
                  Text('Option: Loading...', style: TextStyle(color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),),
                  lastTradedPriceFINNIFTYPE != null ?
                  Text('$lastTradedPriceFINNIFTYPE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green) ) :
                  Text('Option: Loading...', style: TextStyle(color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),),

                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async{
                        //Call Buy Function
                        await FINNIFTYCallBuyBracketOrder();
                      }, child: Text("Call")),
                  ElevatedButton(
                      onPressed: ()async{
                        //Function perform
                        await FINNIFTYPutBuyBracketOrder();
                      }, child: Text("Put"))
                ],
              ),
              SizedBox(height: 30,),
             myProfitAndLoss != null && myProfitAndLoss.isNegative == true ?
              Center(
                child: Text(
                  'Profit And Loss: $myProfitAndLoss',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.red),
                ),
              )
                  :  Center(
                child: Text(
                  'Profit And Loss: $myProfitAndLoss',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.green),
                ),
              ),
            ],
          ),
        )

    );
  }

  //Option Data CE

  Future<void> FINNIFTYCEATMData() async {
    try {
      setState(() {
        isLoading = true;
      });
      int ceEntrumentID = int.parse(FINNIFTYCEATM!);
      print('ceEntrumentID $ceEntrumentID');
      Map<String, dynamic> payload = {
        "isTradeSymbol": "true",
        "instruments": [
          {"exchangeSegment": 2, "exchangeInstrumentID": ceEntrumentID},
        ],
        "xtsMessageCode": 1502,
        "publishFormat": "JSON"
      };
      String myJson = jsonEncode(payload);
      String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/quotes';
      Map<String, String> FINNIFTYheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };
      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: FINNIFTYheader,
        body: myJson,
      );
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];
        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == ceEntrumentID) {
            // Convert int to double here
            lastTradedPriceFINNIFTYCE = quoteData['Touchline']['LastTradedPrice'].toDouble();
            // if(callCount == 1 && callCountTrade == lastTradedPriceFINNIFTYCE){
            //   ExitAnyOrder();
            //   callCount = 0;
            // }else{
            //  // print('Cant sell');
            // }
          } else {
            print('bhag yha seCE');
          }
        }
      } else {
        print('errors in FINNIFTYCE ${secondResponse.statusCode}');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('error in call $e');
      setState(() {
        isLoading = false;
      });
    }
  }



//Option Data PE

  Future<void> FINNIFTYPEATMData() async {
    // print('Halo');
    try {
      setState(() {
        isLoading = true;
      });
      int peEntrumentID = int.parse(FINNIFTYPEATM!);
      print('pijh$peEntrumentID');
      Map<String, dynamic> payload =
      {
        "isTradeSymbol": "true",
        "instruments":
        [
          { "exchangeSegment": 2, "exchangeInstrumentID": peEntrumentID},
        ],
        "xtsMessageCode": 1502,
        "publishFormat": "JSON"};
      String myJson = jsonEncode(payload);
      String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/quotes';
      Map<String, String> FINNIFTYheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };
      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: FINNIFTYheader,
        body: myJson,
      );
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];
        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == peEntrumentID) {
            lastTradedPriceFINNIFTYPE = quoteData['Touchline']['LastTradedPrice'];
          } else {
            print('error');
          }
        }
      } else {
        print('errors in FINNIFTY PE ${secondResponse.statusCode}');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('error  in put $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  //Buying code CE
  int callCount = 0;
  int putCount =0;
  double callCountTrade = 0;

  Future<void> ExitAnyOrder() async{
    String exitOrderUrl = 'https://trade.wisdomcapital.in/interactive/orders/cover';
    try{
      AppOrderID.forEach((appOrderId) async{
        Map<String, dynamic> exitCoverOrderPayload =
        {
          "appOrderID": appOrderId
        };
        String exitCoverOrderJson = json.encode(exitCoverOrderPayload);
        Map<String, String> FINNIFTYCEheader = {
          'Content-Type': 'application/json',
          'authorization': '${widget.interactiveSessionToken}',
        };
        try{
          http.Response exitOrderRequest = await http.put(
            Uri.parse(exitOrderUrl),
            body: exitCoverOrderJson,
            headers: FINNIFTYCEheader,
          );
          if(exitOrderRequest.statusCode == 200){
            // Map<String, dynamic> myCEresult = json.decode(exitOrderRequest.body);
            Get.snackbar('Note', 'Request sent Exited for selling');
          }else{
            print('error while selling ${exitOrderRequest.statusCode}');
          }
        }catch(e){
          print('Error while selling try catch $e');
        }
      });
    }finally{
      AppOrderID.clear();
    }
  }



  Future<void> FINNIFTYCallBuyBracketOrder() async{
    final start = DateTime.now();

    String bracketOrderCallUrl = 'https://trade.wisdomcapital.in/interactive/orders/bracket';

    int? ceEntrumentID = int.tryParse(FINNIFTYCEATM!);
    // Parse input values from the text controllers
    double profitAmount = double.parse(profitAmountController.text.trim());
    double slAmount = double.parse(slController.text.trim());

    // Calculate profit and stop loss amounts as percentages of lastTradedPriceNiftyCE
    double profitTarget = lastTradedPriceFINNIFTYCE! * (profitAmount / 100);
    double stopLossTarget = lastTradedPriceFINNIFTYCE! * (slAmount / 100);
    profitTarget = roundFun(profitTarget);
    stopLossTarget = roundFun(stopLossTarget);

    int? lotSize = int.tryParse(lotSizeController.text.trim());
    print('ceEntrumetnId $ceEntrumentID lotSize $lotSize profit amount');
    int uniqueFilename = Random().nextInt(1000000);
    try{
      Map<String, dynamic> bracketOrderPayload =
      {
        "clientID": "WD3278",
        "exchangeSegment": "NSEFO",
        "exchangeInstrumentID": ceEntrumentID,
        "orderType": "MARKET",
        "orderSide": "BUY",
        "disclosedQuantity": 0,
        "orderQuantity": lotSize,
        "limitPrice": lastTradedPriceFINNIFTYCE,
        "stopLossPrice": stopLossTarget,
        "squarOff": profitTarget,
        "trailingStoploss": 1,
        "orderUniqueIdentifier": '$uniqueFilename'
      };
      Map<String, String> bracketOrderHeader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.interactiveSessionToken}',
      };
      String bracketOrderPayloadJson  = json.encode(bracketOrderPayload);

      http.Response bracketOrderResponse = await http.post(
          Uri.parse(bracketOrderCallUrl),
          headers: bracketOrderHeader,
          body: bracketOrderPayloadJson
      );
      if(bracketOrderResponse.statusCode == 200){
        Map<String, dynamic> myBrackerCE = json.decode(bracketOrderResponse.body);
        AppOrderID = myBrackerCE['result']['OrderID'];
        Get.snackbar('Ho gya', 'Call me buy');
        print('ho gya');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order Brought OrderId $AppOrderID')));
      }else{
        print('Error in bracket order: ${bracketOrderResponse.statusCode}');
      }
    }catch(e){
      print('Error in bracket Order: $e');
    }finally{
      final end = DateTime.now();
      final difference = start.difference(end);
      print('time $difference');
    }
  }

  Future<void> FINNIFTYPutBuyBracketOrder() async{

    String bracketOrderCallUrl = 'https://trade.wisdomcapital.in/interactive/orders/bracket';

    int? peEntrumentID = int.tryParse(FINNIFTYPEATM!);

    double profitAmount = double.parse(profitAmountController.text.trim());
    double slAmount = double.parse(slController.text.trim());

    // Calculate profit and stop loss amounts as percentages of lastTradedPriceNiftyCE
    double profitTarget = lastTradedPriceFINNIFTYPE! * (profitAmount / 100);
    double stopLossTarget = lastTradedPriceFINNIFTYPE! * (slAmount / 100);
    profitTarget = roundFun(profitTarget);
    stopLossTarget = roundFun(stopLossTarget);

    // double? profitAmount = double.tryParse(profitAmountController.text.trim());
    int? lotSize = int.tryParse(lotSizeController.text.trim());
    print('ceEntrumetnId $peEntrumentID lotSize $lotSize profit amount');
    int uniqueFilename = Random().nextInt(1000000);
    try{
      Map<String, dynamic> bracketOrderPayload =
      {
        "clientID": "WD3278",
        "exchangeSegment": "NSEFO",
        "exchangeInstrumentID": peEntrumentID,
        "orderType": "MARKET",
        "orderSide": "BUY",
        "disclosedQuantity": 0,
        "orderQuantity": lotSize,
        "limitPrice": lastTradedPriceFINNIFTYPE,
        "stopLossPrice": stopLossTarget,
        "squarOff": profitTarget,
        "trailingStoploss": 1,
        "orderUniqueIdentifier": '$uniqueFilename'
      };
      Map<String, String> bracketOrderHeader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.interactiveSessionToken}',
      };
      String bracketOrderPayloadJson  = json.encode(bracketOrderPayload);

      http.Response bracketOrderResponse = await http.post(
          Uri.parse(bracketOrderCallUrl),
          headers: bracketOrderHeader,
          body: bracketOrderPayloadJson
      );
      if(bracketOrderResponse.statusCode == 200){
        Map<String, dynamic> myBrackerCE = json.decode(bracketOrderResponse.body);
        AppOrderID = myBrackerCE['result']['OrderID'];
        Get.snackbar('Ho gya', 'Call me buy');
        print('ho gya');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order Brought OrderId $AppOrderID')));
      }else{
        print('Error in bracket order: ${bracketOrderResponse.statusCode}');
      }
    }catch(e){
      print('Error in bracket Order: $e');
    }
  }

  //P&L
  Future<void> MyProfitAndLoss() async {
    myProfitAndLoss = 0.0;
    try {
      String url = 'https://trade.wisdomcapital.in/interactive/portfolio/positions?dayOrNet=DayWise';
      Map<String, String> FINNIFTYheader = {
        'Content-Type': 'application/json',
        'authorization': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiJXRDMyNzhfMkU3NTY5REExRkMyNTZFRTI2QTY5OCIsInB1YmxpY0tleSI6IjJlNzU2OWRhMWZjMjU2ZWUyNmE2OTgiLCJpc0ludGVyYWN0aXZlIjp0cnVlLCJpYXQiOjE3MTUwMDkxMDQsImV4cCI6MTcxNTA5NTUwNH0.fM_9brZ-jy1fsQMuD7NZwGJtMgy_ioyfPWrH-z0sya8',
      };
      http.Response secondResponse = await http.get(
        Uri.parse(url),
        headers: FINNIFTYheader,
      );
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> positionList = responseData["result"]["positionList"];
        print('positionList $positionList');
        for (var position in positionList) {
          var quoteData = position as Map<String, dynamic>; // Cast position to Map<String, dynamic>
          if (quoteData.isNotEmpty) {
            myProfitAndLoss += double.parse(quoteData["Net%"].toString());
          } else {
            print("No positions found.");
          }
        }
      } else {
        print('errors in FINNIFTY PE ${secondResponse.statusCode}');
      }
    } catch (e) {
      print('error  in put $e');
    } finally {
      print('myProfitAndLoss $myProfitAndLoss');
    }
  }

  double roundFun(double modifyTick){
    String roundedValue = ((modifyTick / 0.05).round() * 0.05).toStringAsFixed(2);
    double roundedTrailingSL = double.parse(roundedValue);
    return roundedTrailingSL;
  }
}






