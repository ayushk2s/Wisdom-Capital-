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

class MIDCPNIFTY extends StatefulWidget{
  String? interactiveSessionToken;
  String? marketSessionToken;
  MIDCPNIFTY({super.key , required this.interactiveSessionToken, required this.marketSessionToken});
  @override
  State<MIDCPNIFTY> createState() => _MIDCPNIFTYState();
}

class _MIDCPNIFTYState extends State<MIDCPNIFTY> {
  // List<BalanceModel> balanceModels = [];
  List<int> AppOrderID = [];
  TextEditingController profitAmountController = TextEditingController();
  TextEditingController lotSizeController = TextEditingController();
  TextEditingController slController = TextEditingController();
  TextEditingController trailingSlController = TextEditingController();
  BalanceModel? balanceModel;
  bool isLoading = false;
  double? netMarginAvailable;
  double? cashAvailable;
  var myProfitAndLoss = 0.0;
  String? totalProfit;
  // LiveMIDCPNIFTY50Price liveMIDCPNIFTY50Price = LiveMIDCPNIFTY50Price();
  String? MIDCPNIFTYLivePrice;
  String? typeExampleEQ;
  StreamController<String> _MIDCPNIFTYStream = StreamController<String>();
  late Timer _timer;
  bool _isStreaming = false;
  double? lastTradedPriceMIDCPNIFTY;
  double? lastTradedPriceMIDCPNIFTYCE;
  double? lastTradedPriceMIDCPNIFTYPE;
  double yesterdayMIDCPNIFTYPriceComparison = 0.0;


  void MIDCPNIFTYLiveStream() async {
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      MIDCPNIFTYFiftyPrice();
      MIDCPNIFTYPEATMData();
      MIDCPNIFTYCEATMData();
    });
  }

  Future<void> MIDCPNIFTYFiftyPrice() async {
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
          { "exchangeSegment": 1, "exchangeInstrumentID": 26121},
        ],
        "xtsMessageCode": 1502,
        "publishFormat": "JSON"
      };
      String myJson = jsonEncode(payload);
      String url = 'https://trade.wisdomcapital.in/apimarketdata/instruments/quotes';
      Map<String, String> MIDCPNIFTYheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };
      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: MIDCPNIFTYheader,
        body: myJson,
      );
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];
        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == 26121) {
            lastTradedPriceMIDCPNIFTY = quoteData['Touchline']['LastTradedPrice'];
            //  print('lastTradedPriceMIDCPNIFTY ${lastTradedPriceMIDCPNIFTY}');
          } else {
            print('bhag yha se');
          }
        }
      } else {
        print('errors in MIDCPNIFTY ${secondResponse.statusCode}');
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

  String? MIDCPNIFTYATMCENAME;
  String? MIDCPNIFTYATMPENAME;
  String? MIDCPNIFTYCEATM;
  String? MIDCPNIFTYPEATM;
  Future<void> NameOfOPtion() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MIDCPNIFTYATMCENAME = await prefs.getString('MIDCPNIFTYCEATMNAME');
    MIDCPNIFTYATMPENAME = await prefs.getString('MIDCPNIFTYPEATMNAME');
    MIDCPNIFTYCEATM = await prefs.getString('MIDCPNIFTYCEATM');
    MIDCPNIFTYPEATM = await prefs.getString('MIDCPNIFTYPEATM');
    print('MIDCPNIFTYATMCENAME $MIDCPNIFTYATMCENAME nifyt ce instru $MIDCPNIFTYCEATM MIDCPNIFTYATMPENAME $MIDCPNIFTYATMPENAME MIDCPNIFTYPEATM $MIDCPNIFTYPEATM');
    MIDCPNIFTYLiveStream();
    // MIDCPNIFTYFiftyPrice();
    // MIDCPNIFTYPEATMData();
    // MIDCPNIFTYCEATMData();
  }

  @override
  void initState() {
    super.initState();
    NameOfOPtion();
    balanceFunction();
    print('Tokens ${widget.interactiveSessionToken}\n ${widget
        .marketSessionToken}');
    MyProfitAndLoss();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    _MIDCPNIFTYStream.close();
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
                      yesterdayMIDCPNIFTYPriceComparison =
                          lastTradedPriceMIDCPNIFTY ?? yesterdayMIDCPNIFTYPriceComparison;
                      print(yesterdayMIDCPNIFTYPriceComparison);
                    });
                    Get.snackbar('Note', 'MIDCPNIFTY Updated');
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
                  lastTradedPriceMIDCPNIFTY != null ?
                  lastTradedPriceMIDCPNIFTY! >= yesterdayMIDCPNIFTYPriceComparison ?
                  Text('MIDCPNIFTY: ${lastTradedPriceMIDCPNIFTY!.toStringAsFixed(2)}', style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),) :
                  Text('MIDCPNIFTY: ${lastTradedPriceMIDCPNIFTY!.toStringAsFixed(2)}', style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),) :
                  Text('MIDCPNIFTY: Loading...', style: TextStyle(color: Colors.grey,
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
                  decoration: const InputDecoration(
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
                  decoration: const InputDecoration(
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
                  decoration: const InputDecoration(
                      hintText: 'Number of Quantity...',
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('${MIDCPNIFTYATMCENAME!.substring(10)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  Text('${MIDCPNIFTYATMPENAME!.substring(10)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  lastTradedPriceMIDCPNIFTYCE != null ?
                  Text('$lastTradedPriceMIDCPNIFTYCE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green) ):
                  Text('Option: Loading...', style: TextStyle(color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),),
                  lastTradedPriceMIDCPNIFTYPE != null ?
                  Text('$lastTradedPriceMIDCPNIFTYPE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green) ) :
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
                        await MIDCPNIFTYCallBuyBracketOrder();
                      }, child: Text("Call")),
                  ElevatedButton(
                      onPressed: ()async{
                        //Function perform
                        await MIDCPNIFTYPutBuyBracketOrder();
                      }, child: Text("Put"))
                ],
              ),
              SizedBox(height: 30,),
              InkWell(
                  onTap: ()async{
                    await ExitAnyOrder();
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width*0.7,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Exit All', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),))),
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
  Future<void> MIDCPNIFTYCEATMData() async {
    try {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        isLoading = true;
      });

      int ceEntrumentID = int.parse(MIDCPNIFTYCEATM!);


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

      Map<String, String> MIDCPNIFTYheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };

      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: MIDCPNIFTYheader,
        body: myJson,
      );

      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];

        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == ceEntrumentID) {
            lastTradedPriceMIDCPNIFTYCE = quoteData['Touchline']['LastTradedPrice'].toDouble();
          } else {
            print('bhag yha seCE');
          }
        }
      } else {
        print('errors in MIDCPNIFTYCE ${secondResponse.statusCode}');
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

  Future<void> MIDCPNIFTYPEATMData() async {
    // print('Halo');
    try {
      setState(() {
        isLoading = true;
      });
      int peEntrumentID = int.parse(MIDCPNIFTYPEATM!);
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
      Map<String, String> MIDCPNIFTYheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };
      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: MIDCPNIFTYheader,
        body: myJson,
      );
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];
        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == peEntrumentID) {
            lastTradedPriceMIDCPNIFTYPE = quoteData['Touchline']['LastTradedPrice'];
          } else {
            print('error');
          }
        }
      } else {
        print('errors in MIDCPNIFTY PE ${secondResponse.statusCode} ${secondResponse.body}');
      }
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('error  in put $e');
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

  Future<void> ExitAnyOrder() async{
    String exitOrderUrl = 'https://trade.wisdomcapital.in/interactive/orders/cover';
    try{
      AppOrderID.forEach((appOrderId) async{
        Map<String, dynamic> exitCoverOrderPayload =
        {
          "appOrderID": appOrderId
        };
        String exitCoverOrderJson = json.encode(exitCoverOrderPayload);
        Map<String, String> MIDCPNIFTYCEheader = {
          'Content-Type': 'application/json',
          'authorization': '${widget.interactiveSessionToken}',
        };
        try{
          http.Response exitOrderRequest = await http.put(
            Uri.parse(exitOrderUrl),
            body: exitCoverOrderJson,
            headers: MIDCPNIFTYCEheader,
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


  Future<void> MIDCPNIFTYCallBuyBracketOrder() async{
    final start = DateTime.now();

    String bracketOrderCallUrl = 'https://trade.wisdomcapital.in/interactive/orders/bracket';

    int? ceEntrumentID = int.tryParse(MIDCPNIFTYCEATM!);
    // Parse input values from the text controllers
    double profitAmount = double.parse(profitAmountController.text.trim());
    double slAmount = double.parse(slController.text.trim());

    // Calculate profit and stop loss amounts as percentages of lastTradedPriceNiftyCE
    double profitTarget = lastTradedPriceMIDCPNIFTYCE! * (profitAmount / 100);
    double stopLossTarget = lastTradedPriceMIDCPNIFTYCE! * (slAmount / 100);
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
        "limitPrice": lastTradedPriceMIDCPNIFTYCE,
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

  Future<void> MIDCPNIFTYPutBuyBracketOrder() async{

    String bracketOrderCallUrl = 'https://trade.wisdomcapital.in/interactive/orders/bracket';

    int? peEntrumentID = int.tryParse(MIDCPNIFTYPEATM!);

    double profitAmount = double.parse(profitAmountController.text.trim());
    double slAmount = double.parse(slController.text.trim());

    // Calculate profit and stop loss amounts as percentages of lastTradedPriceNiftyCE
    double profitTarget = lastTradedPriceMIDCPNIFTYPE! * (profitAmount / 100);
    double stopLossTarget = lastTradedPriceMIDCPNIFTYPE! * (slAmount / 100);
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
        "limitPrice": lastTradedPriceMIDCPNIFTYPE,
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

  //Trialing
  Future<void> MIDCPNIFTYCallBuyBracketOrderTrialing() async{
    final start = DateTime.now();
    String bracketOrderCallUrl = 'https://trade.wisdomcapital.in/interactive/orders/bracket';

    int? ceEntrumentID = int.tryParse(MIDCPNIFTYCEATM!);
    double trailingSl = double.parse(trailingSlController.text.trim());
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
        "limitPrice": lastTradedPriceMIDCPNIFTYCE,
        "stopLossPrice": 0.0,
        "squarOff": 0.0,
        "trailingStoploss": trailingSl,
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

  Future<void> MIDCPNIFTYPutBuyBracketOrderTrialing() async{

    String bracketOrderCallUrl = 'https://trade.wisdomcapital.in/interactive/orders/bracket';

    int? peEntrumentID = int.tryParse(MIDCPNIFTYPEATM!);
    double trailingSl = double.parse(trailingSlController.text.trim());
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
        "limitPrice": lastTradedPriceMIDCPNIFTYPE,
        "stopLossPrice": 0.0,
        "squarOff": 0.0,
        "trailingStoploss": trailingSl,
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
        print('Error in bracket order: ${bracketOrderResponse.statusCode} ${bracketOrderResponse.body}');
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
      Map<String, String> MIDCPNIFTYheader = {
        'Content-Type': 'application/json',
        'authorization': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiJXRDMyNzhfMkU3NTY5REExRkMyNTZFRTI2QTY5OCIsInB1YmxpY0tleSI6IjJlNzU2OWRhMWZjMjU2ZWUyNmE2OTgiLCJpc0ludGVyYWN0aXZlIjp0cnVlLCJpYXQiOjE3MTUwMDkxMDQsImV4cCI6MTcxNTA5NTUwNH0.fM_9brZ-jy1fsQMuD7NZwGJtMgy_ioyfPWrH-z0sya8',
      };
      http.Response secondResponse = await http.get(
        Uri.parse(url),
        headers: MIDCPNIFTYheader,
      );
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> positionList = responseData["result"]["positionList"];
        print('positionList $positionList');
        for (var position in positionList) {
          var quoteData = position as Map<String, dynamic>; // Cast position to Map<String, dynamic>
          if (quoteData.isNotEmpty) {
            myProfitAndLoss += double.parse(quoteData["NetAmount"].toString());
          } else {
            print("No positions found.");
          }
        }
      } else {
        print('errors in MIDCPNIFTY PE ${secondResponse.statusCode}');
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






