import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanuman/Auth/IntractiveLoginSession.dart';
import 'package:hanuman/Models/BalanceModel.dart';
import 'package:hanuman/Screen/OrderHistory.dart';
import 'package:hanuman/Screen/TotalProfitLoss.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class BANKNIFTY extends StatefulWidget{
  String? interactiveSessionToken;
  String? marketSessionToken;
  BANKNIFTY({super.key , required this.interactiveSessionToken, required this.marketSessionToken});
  @override
  State<BANKNIFTY> createState() => _BANKNIFTYState();
}

class _BANKNIFTYState extends State<BANKNIFTY> {
  // List<BalanceModel> balanceModels = [];
  List<int> AppOrderID = [];
  TextEditingController profitAmountController = TextEditingController();
  TextEditingController lotSizeController = TextEditingController();
  TextEditingController slController = TextEditingController();
  BalanceModel? balanceModel;
  bool isLoading = false;
  double? netMarginAvailable;
  double? cashAvailable;
  String? totalProfit;
  // LiveBANKNIFTY50Price liveBANKNIFTY50Price = LiveBANKNIFTY50Price();
  String? BANKNIFTYLivePrice;
  String? typeExampleEQ;
  StreamController<String> _BANKNIFTYStream = StreamController<String>();
  late Timer _timer;
  bool _isStreaming = false;
  double? lastTradedPriceBANKNIFTY;
  double? lastTradedPriceBANKNIFTYCE;
  double? lastTradedPriceBANKNIFTYPE;
  double yesterdayBANKNIFTYPriceComparison = 0.0;


  void BANKNIFTYLiveStream() async {
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      BANKNIFTYFiftyPrice();
      BANKNIFTYPEATMData();
      BANKNIFTYCEATMData();
    });
  }


  Future<void> BANKNIFTYFiftyPrice() async {
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
          { "exchangeSegment": 1, "exchangeInstrumentID": 26001},
        ],
        "xtsMessageCode": 1502,
        "publishFormat": "JSON"
      };
      String myJson = jsonEncode(payload);
      String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/quotes';
      Map<String, String> BANKNIFTYheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };
      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: BANKNIFTYheader,
        body: myJson,
      );
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];
        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == 26001) {
            lastTradedPriceBANKNIFTY = quoteData['Touchline']['LastTradedPrice'];
            //  print('lastTradedPriceBANKNIFTY ${lastTradedPriceBANKNIFTY}');
          } else {
            print('bhag yha se');
          }
        }
      } else {
        print('errors in BANKNIFTY ${secondResponse.statusCode}');
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


  String? BANKNIFTYATMCENAME;
  String? BANKNIFTYATMPENAME;
  String? BANKNIFTYCEATM;
  String? BANKNIFTYPEATM;
  Future<void> NameOfOPtion() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BANKNIFTYATMCENAME = await prefs.getString('BANKNIFTYCEATMNAME');
    BANKNIFTYATMPENAME = await prefs.getString('BANKNIFTYPEATMNAME');
    BANKNIFTYCEATM = await prefs.getString('BANKNIFTYCEATM');
    BANKNIFTYPEATM = await prefs.getString('BANKNIFTYPEATM');
    print('BANKNIFTYATMCENAME $BANKNIFTYATMCENAME nifyt ce instru $BANKNIFTYCEATM BANKNIFTYATMPENAME $BANKNIFTYATMPENAME BANKNIFTYPEATM $BANKNIFTYPEATM');
    BANKNIFTYLiveStream();
  }

  late Totalprofitloss totalprofitloss;
  @override
  void initState() {
    super.initState();
    NameOfOPtion();
    balanceFunction();
    print('Tokens ${widget.interactiveSessionToken}\n ${widget
        .marketSessionToken}');
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    _BANKNIFTYStream.close();
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
                      yesterdayBANKNIFTYPriceComparison =
                          lastTradedPriceBANKNIFTY ?? yesterdayBANKNIFTYPriceComparison;
                      print(yesterdayBANKNIFTYPriceComparison);
                    });
                    Get.snackbar('Note', 'BANKNIFTY Updated');
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
            children: <Widget>[
              //Text('Cash Used $cashAvailable'),
              Center(child: Text('Balance: $netMarginAvailable', style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),)),
              Center(child:
              Stack(
                children: <Widget>[
                  lastTradedPriceBANKNIFTY != null ?
                  lastTradedPriceBANKNIFTY! >= yesterdayBANKNIFTYPriceComparison ?
                  Text('BANKNIFTY: ${lastTradedPriceBANKNIFTY!.toStringAsFixed(2)}', style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),) :
                  Text('BANKNIFTY: ${lastTradedPriceBANKNIFTY!.toStringAsFixed(2)}', style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),) :
                  Text('BANKNIFTY: Loading...', style: TextStyle(color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),),
                ],
              ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: slController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'StopLoss Amount...',
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: profitAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Profit Amount...',
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
                      hintText: 'Number of Lot...',
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BANKNIFTYATMCENAME != null ? Text('${BANKNIFTYATMCENAME!.substring(10)}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
                      : Container(),
                  BANKNIFTYATMPENAME != null ? Text('${BANKNIFTYATMPENAME!.substring(10)}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
                      : Container()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  lastTradedPriceBANKNIFTYCE != null ?
                  Text('$lastTradedPriceBANKNIFTYCE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green) ):
                  Text('Option: Loading...', style: TextStyle(color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),),
                  lastTradedPriceBANKNIFTYPE != null ?
                  Text('$lastTradedPriceBANKNIFTYPE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green) ) :
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
                        await BANKNIFTYCallBuyBracketOrder();
                      }, child: Text("Call")),
                  ElevatedButton(
                      onPressed: ()async{
                        //Function perform
                        await BANKNIFTYPutBuyBracketOrder();
                      }, child: Text("Put"))
                ],
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                  onPressed: () async{
                    //Call Buy Function
                    try {
                      await BANKNIFTYCallBuyBracketOrder();
                      await BANKNIFTYPutBuyBracketOrder();
                    }catch(e){
                      print('$e');
                    }

                  }, child: Text("Both")),
              SizedBox(height: 30,),
              Container(
                height: 100,
                child: Totalprofitloss(
                  interactiveSessionToken: widget.interactiveSessionToken,),
              ),
            ],
          ),
        )

    );
  }

  //Option Data CE
  Future<void> BANKNIFTYCEATMData() async {
    try {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        isLoading = true;
      });

      int ceEntrumentID = int.parse(BANKNIFTYCEATM!);

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

      Map<String, String> BANKNIFTYheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };

      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: BANKNIFTYheader,
        body: myJson,
      );

      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];

        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == ceEntrumentID) {
            lastTradedPriceBANKNIFTYCE = quoteData['Touchline']['LastTradedPrice'].toDouble();
          } else {
            print('bhag yha seCE');
          }
        }
      } else {
        print('errors in BANKNIFTYCE ${secondResponse.statusCode}');
      }

      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('error in call $e');

      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        isLoading = false;
      });
    }
  }

//Option Data PE

  Future<void> BANKNIFTYPEATMData() async {
    // print('Halo');
    try {
      setState(() {
        isLoading = true;
      });
      int peEntrumentID = int.parse(BANKNIFTYPEATM!);
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
      Map<String, String> BANKNIFTYheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };
      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: BANKNIFTYheader,
        body: myJson,
      );
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];
        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == peEntrumentID) {
            lastTradedPriceBANKNIFTYPE = quoteData['Touchline']['LastTradedPrice'];
          } else {
            print('error');
          }
        }
      } else {
        print('errors in BANKNIFTY PE ${secondResponse.statusCode}');
      }
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // print('error  in put $e');
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        isLoading = false;
      });
    }
  }

  //Buying code CE
  int callCount = 0;
  int putCount =0;
  double callCountTrade = 0;
  //  Future<void> BANKNIFTYCallBuyATM() async{
  //
  //    try{
  //      double profitAmount = double.parse(profitAmountController.text.trim());
  //     String myCEUrl = 'https://trade.wisdomcapital.in/interactive/orders';
  //     int? ceEntrumentID = int.tryParse(BANKNIFTYCEATM!);
  //   //  double profitAmount = double.parse(profitAmountController.text.trim());
  //     int? lotSize = int.tryParse(lotSizeController.text.trim());
  //     print('ceEntrumetnId $ceEntrumentID lotSize $lotSize');
  //     int uniqueFilename = Random().nextInt(1000000);
  //     Map<String, dynamic> payload =
  //     {
  //       "disclosedQuantity":0,
  //       "exchangeSegment":"NSEFO",
  //       "orderType":"MARKET",
  //       "stopPrice":0,
  //       "limitPrice":lastTradedPriceBANKNIFTYCE,
  //       "orderUniqueIdentifier": "$uniqueFilename",
  //       "exchangeInstrumentID":ceEntrumentID,
  //       "orderSide":"BUY",
  //       "timeInForce":"DAY",
  //       "productType":"NRML",
  //       "orderQuantity":lotSize
  //     };
  //     String jsonPayLoadCE = jsonEncode(payload);
  //     Map<String, String> BANKNIFTYCEheader = {
  //       'Content-Type': 'application/json',
  //       'authorization': '${widget.interactiveSessionToken}',
  //     };
  //     http.Response myCETrade = await http.post(
  //      Uri.parse(myCEUrl),
  //         headers: BANKNIFTYCEheader,
  //         body: jsonPayLoadCE
  //     );
  //     if(myCETrade.statusCode == 200){
  //       Get.snackbar('Ho gya', 'Call me buy');
  //       Map<String, dynamic> myCEresult = json.decode(myCETrade.body);
  //       int BANKNIFTYCallAppOrderId = myCEresult['result']['AppOrderID'];
  //       print(BANKNIFTYCallAppOrderId);
  //       AppOrderID.add(BANKNIFTYCallAppOrderId);
  //       callCount = 1;
  //       callCountTrade = lastTradedPriceBANKNIFTYCE! + profitAmount;
  //     }else{
  //       print('error while buy ${myCETrade.statusCode}');
  //     }
  //   }catch(e){
  //     print('Error $e');
  //   }
  //  }
  //
  //  //Buying code PE
  //  Future<void> BANKNIFTYPUTBuyATM() async{
  //   try{
  //     double profitAmount = double.parse(profitAmountController.text.trim());
  //     String myCEUrl = 'https://trade.wisdomcapital.in/interactive/orders';
  //     int? peEntrumentID = int.tryParse(BANKNIFTYPEATM!);
  //     int? lotSize = int.tryParse(lotSizeController.text.trim());
  //     print('ceEntrumetnId $peEntrumentID lotSize $lotSize');
  //     int uniqueFilename = Random().nextInt(1000000);
  //     Map<String, dynamic> payload =
  //     {
  //       "disclosedQuantity":0,
  //       "exchangeSegment":"NSEFO",
  //       "orderType":"MARKET",
  //       "stopPrice":0,
  //       "limitPrice": lastTradedPriceBANKNIFTYPE,
  //       "orderUniqueIdentifier": "$uniqueFilename",
  //       "exchangeInstrumentID":peEntrumentID,
  //       "orderSide":"BUY",
  //       "timeInForce":"DAY",
  //       "productType":"NRML",
  //       "orderQuantity":lotSize
  //     };
  //     String jsonPayLoadCE = jsonEncode(payload);
  //     Map<String, String> BANKNIFTYCEheader = {
  //       'Content-Type': 'application/json',
  //       'authorization': '${widget.interactiveSessionToken}',
  //     };
  //     http.Response myCETrade = await http.post(
  //         Uri.parse(myCEUrl),
  //         headers: BANKNIFTYCEheader,
  //         body: jsonPayLoadCE
  //     );
  //     if(myCETrade.statusCode == 200){
  //       Get.snackbar('Ho gya', 'Call me buy');
  //       Map<String, dynamic> myCEresult = json.decode(myCETrade.body);
  //       int BANKNIFTYPutAppOrderId = myCEresult['result']['AppOrderID'];
  //       AppOrderID.add(BANKNIFTYPutAppOrderId);
  //       callCount = 1;
  //       callCountTrade = lastTradedPriceBANKNIFTYCE! + profitAmount;
  //     }else{
  //       print(myCETrade.statusCode);
  //     }
  //   }catch(e){
  //     print('Error $e');
  //   }
  // }

  //Booking P&L of any order

  Future<void> ExitAnyOrder() async{
    String exitOrderUrl = 'https://trade.wisdomcapital.in/interactive/orders/cover';
    try{
      AppOrderID.forEach((appOrderId) async{
        Map<String, dynamic> exitCoverOrderPayload =
        {
          "appOrderID": appOrderId
        };
        String exitCoverOrderJson = json.encode(exitCoverOrderPayload);
        Map<String, String> BANKNIFTYCEheader = {
          'Content-Type': 'application/json',
          'authorization': '${widget.interactiveSessionToken}',
        };
        try{
          http.Response exitOrderRequest = await http.put(
            Uri.parse(exitOrderUrl),
            body: exitCoverOrderJson,
            headers: BANKNIFTYCEheader,
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

// Putting profit code
// Future<void> CoverMarketOrder() async{
// String marketCoverUrl = 'https://trade.wisdomcapital.in/interactive/orders/bracket';
// Map<String, String> BANKNIFTYCEheader = {
//   'Content-Type': 'application/json',
//   'authorization': '${widget.marketSessionToken}',
// };
// }


  Future<void> BANKNIFTYCallBuyBracketOrder() async{
    final start = DateTime.now();
    String bracketOrderCallUrl = 'https://trade.wisdomcapital.in/interactive/orders/bracket';

    int? ceEntrumentID = int.tryParse(BANKNIFTYCEATM!);
    double profitAmount = double.parse(profitAmountController.text.trim());
    // double? profitAmount = double.tryParse(profitAmountController.text.trim());
    double slAmount = double.parse(slController.text.trim());

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
        "limitPrice": lastTradedPriceBANKNIFTYCE,
        "stopLossPrice": slAmount,
        "squarOff": profitAmount,
        "trailingStoploss": profitAmount,
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

  Future<void> BANKNIFTYPutBuyBracketOrder() async{

    String bracketOrderCallUrl = 'https://trade.wisdomcapital.in/interactive/orders/bracket';

    int? peEntrumentID = int.tryParse(BANKNIFTYPEATM!);
    double profitAmount = double.parse(profitAmountController.text.trim());
    double slAmount = double.parse(slController.text.trim());
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
        "limitPrice": lastTradedPriceBANKNIFTYPE,
        "stopLossPrice": slAmount,
        "squarOff": profitAmount,
        "trailingStoploss": profitAmount,
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

}






