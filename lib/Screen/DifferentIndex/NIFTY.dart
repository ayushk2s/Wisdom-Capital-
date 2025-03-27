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

class NIFTY extends StatefulWidget{
  String? interactiveSessionToken;
  String? marketSessionToken;
  NIFTY({super.key , required this.interactiveSessionToken, required this.marketSessionToken});
  @override
  State<NIFTY> createState() => _NIFTYState();
}

class _NIFTYState extends State<NIFTY> {
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
  // LiveNifty50Price liveNifty50Price = LiveNifty50Price();
  String? niftyLivePrice;
  String? typeExampleEQ;
  StreamController<String> _niftyStream = StreamController<String>();
  late Timer _timer;
  bool _isStreaming = false;
  double? lastTradedPriceNifty;
  double? lastTradedPriceNiftyCE;
  double? lastTradedPriceNiftyPE;
  double yesterdayNiftyPriceComparison = 0.0;


  void niftyLiveStream() async {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      niftyFiftyPrice();
      niftyPEATMData();
      niftyCEATMData();
    });
  }


  Future<void> niftyFiftyPrice() async {
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
          { "exchangeSegment": 1, "exchangeInstrumentID": 26000},
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
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];
        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == 26000) {
            lastTradedPriceNifty = quoteData['Touchline']['LastTradedPrice'];
            //  print('lastTradedPriceNifty ${lastTradedPriceNifty}');
          } else {
            print('bhag yha se');
          }
        }
      } else {
        print('errors in nifty ${secondResponse.statusCode}');
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


  String? NIFTYATMCENAME;
  String? NIFTYATMPENAME;
  String? NIFTYCEATM;
  String? NIFTYPEATM;
  Future<void> NameOfOPtion() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    NIFTYATMCENAME = await prefs.getString('NIFTYCEATMNAME');
    NIFTYATMPENAME = await prefs.getString('NIFTYPEATMNAME');
    NIFTYCEATM = await prefs.getString('NIFTYCEATM');
    NIFTYPEATM = await prefs.getString('NIFTYPEATM');
    print('NIFTYATMCENAME $NIFTYATMCENAME nifyt ce instru $NIFTYCEATM NIFTYATMPENAME $NIFTYATMPENAME NIFTYPEATM $NIFTYPEATM');
    niftyLiveStream();
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
    _niftyStream.close();
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
            child: const Text(
                "Radhey Radhey ", style: TextStyle(color: Colors.blue)),
          ),
          leading: FittedBox(
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)),
                onPressed: () {
                  if (mounted) { // Check if the widget is mounted
                    setState(() {
                      yesterdayNiftyPriceComparison =
                          lastTradedPriceNifty ?? yesterdayNiftyPriceComparison;
                      print(yesterdayNiftyPriceComparison);
                    });
                    Get.snackbar('Note', 'Nifty Updated');
                  }
                },
                child: const Icon(Icons.update, color: Colors.green, size: 40,)
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
                  child: const Icon(Icons.exit_to_app, color: Colors.black,)),
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
              Center(child: Text('Balance: $netMarginAvailable', style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),)),
              Center(child:
              Stack(
                children: <Widget>[
                  lastTradedPriceNifty != null ?
                  lastTradedPriceNifty! >= yesterdayNiftyPriceComparison ?
                  Text('Nifty: ${lastTradedPriceNifty!.toStringAsFixed(2)}', style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),) :
                  Text('Nifty: ${lastTradedPriceNifty!.toStringAsFixed(2)}', style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),) :
                  const Text('Nifty: Loading...', style: TextStyle(color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),),
                ],
              ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: profitAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Profit Amount...',
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: slController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'StopLoss Amount...',
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: lotSizeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Number of Lot...',
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NIFTYATMCENAME != null ? Text('${NIFTYATMCENAME!.substring(10)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
                  : Container(),
                  NIFTYATMPENAME != null ? Text('${NIFTYATMPENAME!.substring(10)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
                      : Container()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  lastTradedPriceNiftyCE != null ?
                  Text('$lastTradedPriceNiftyCE', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green) ):
                  const Text('Option: Loading...', style: TextStyle(color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),),
                  lastTradedPriceNiftyPE != null ?
                  Text('$lastTradedPriceNiftyPE', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green) ) :
                  const Text('Option: Loading...', style: TextStyle(color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),),

                ],
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async{
                        //Call Buy Function
                        await NiftyCallBuyBracketOrder();
                      }, child: const Text("Call")),
                  ElevatedButton(
                      onPressed: ()async{
                        //Function perform
                        await NiftyPutBuyBracketOrder();
                      }, child: const Text("Put"))
                ],
              ),
              const SizedBox(height: 30,),
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
  Future<void> niftyCEATMData() async {
    try {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        isLoading = true;
      });

      int ceEntrumentID = int.parse(NIFTYCEATM!);

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

      Map<String, String> niftyheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };

      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: niftyheader,
        body: myJson,
      );

      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];

        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == ceEntrumentID) {
            lastTradedPriceNiftyCE = quoteData['Touchline']['LastTradedPrice'].toDouble();
          } else {
            print('bhag yha seCE');
          }
        }
      } else {
        print('errors in niftyCE ${secondResponse.statusCode}');
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

  Future<void> niftyPEATMData() async {
    // print('Halo');
    try {
      setState(() {
        isLoading = true;
      });
      int peEntrumentID = int.parse(NIFTYPEATM!);
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
      Map<String, String> niftyheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.marketSessionToken}',
      };
      http.Response secondResponse = await http.post(
        Uri.parse(url),
        headers: niftyheader,
        body: myJson,
      );
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);
        List<dynamic> listQuotes = responseData['result']['listQuotes'];
        for (var quote in listQuotes) {
          Map<String, dynamic> quoteData = jsonDecode(quote);
          if (quoteData['ExchangeInstrumentID'] == peEntrumentID) {
            lastTradedPriceNiftyPE = quoteData['Touchline']['LastTradedPrice'];
          } else {
            print('error');
          }
        }
      } else {
        print('errors in nifty PE ${secondResponse.statusCode}');
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
        Map<String, String> niftyCEheader = {
          'Content-Type': 'application/json',
          'authorization': '${widget.interactiveSessionToken}',
        };
        try{
          http.Response exitOrderRequest = await http.put(
            Uri.parse(exitOrderUrl),
            body: exitCoverOrderJson,
            headers: niftyCEheader,
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
// Map<String, String> niftyCEheader = {
//   'Content-Type': 'application/json',
//   'authorization': '${widget.marketSessionToken}',
// };
// }


  Future<void> NiftyCallBuyBracketOrder() async{
    final start = DateTime.now();

    String bracketOrderCallUrl = 'https://trade.wisdomcapital.in/interactive/orders/bracket';

    int? ceEntrumentID = int.tryParse(NIFTYCEATM!);
    // Parse input values from the text controllers
    double profitAmount = double.parse(profitAmountController.text.trim());
    double slAmount = double.parse(slController.text.trim());

    // Calculate profit and stop loss amounts as percentages of lastTradedPriceNiftyCE
    double profitTarget = lastTradedPriceNiftyCE! * (profitAmount / 100);
    double stopLossTarget = lastTradedPriceNiftyCE! * (slAmount / 100);
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
        "limitPrice": lastTradedPriceNiftyCE,
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
        print('Error in bracket order: ${bracketOrderResponse.statusCode} ${bracketOrderResponse.body}');
      }
    }catch(e){
      print('Error in bracket Order: $e');
    }finally{
      final end = DateTime.now();
      final difference = start.difference(end);
      print('time $difference');
    }
  }

  Future<void> NiftyPutBuyBracketOrder() async{

    String bracketOrderCallUrl = 'https://trade.wisdomcapital.in/interactive/orders/bracket';

    int? peEntrumentID = int.tryParse(NIFTYPEATM!);

    double profitAmount = double.parse(profitAmountController.text.trim());
    double slAmount = double.parse(slController.text.trim());

    // Calculate profit and stop loss amounts as percentages of lastTradedPriceNiftyCE
    double profitTarget = lastTradedPriceNiftyPE! * (profitAmount / 100);
    double stopLossTarget = lastTradedPriceNiftyPE! * (slAmount / 100);
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
        "limitPrice": lastTradedPriceNiftyPE,
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
        // AppOrderID = myBrackerCE['result']['OrderID'];
        Get.snackbar('Ho gya', 'Call me buy');
        print('ho gya');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order Brought OrderId $AppOrderID')));
      }else{
        print('Error in bracket order: ${bracketOrderResponse.statusCode}  ${bracketOrderResponse.body}');
      }
    }catch(e){
      print('Error in bracket Order: $e');
    }
  }

  double roundFun(double modifyTick){
    String roundedValue = ((modifyTick / 0.05).round() * 0.05).toStringAsFixed(2);
    double roundedTrailingSL = double.parse(roundedValue);
    return roundedTrailingSL;
  }

}






