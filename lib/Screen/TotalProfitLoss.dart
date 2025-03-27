import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
class Totalprofitloss extends StatefulWidget{
  String? interactiveSessionToken;
  Totalprofitloss({super.key , required this.interactiveSessionToken});
  @override
  State<Totalprofitloss> createState() => _TotalprofitlossState();
}

class _TotalprofitlossState extends State<Totalprofitloss> {
  int c =0;
  double? broughtPrice, soldPrice;
  int? totalQuantity;
  double netAmount = 0.0;
  Future<void> MyProfitAndLoss() async {
    try {
      String url = 'https://trade.wisdomcapital.in/interactive/portfolio/positions?dayOrNet=DayWise';
      Map<String, String> niftyheader = {
        'Content-Type': 'application/json',
        'authorization': '${widget.interactiveSessionToken}',
      };
      http.Response secondResponse = await http.get(
        Uri.parse(url),
        headers: niftyheader,
      );
      if (secondResponse.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(secondResponse.body);

        List<dynamic> positionList = responseData["result"]["positionList"];
        for (var position in positionList) {
          var quoteData = position as Map<String, dynamic>; // Cast position to Map<String, dynamic>
          if (quoteData.isNotEmpty) {
            setState(() {
            broughtPrice = double.tryParse(quoteData['BuyAveragePrice'])!;
            soldPrice = double.tryParse(quoteData['SellAveragePrice'])!;
            totalQuantity = int.tryParse(quoteData['OpenBuyQuantity'])!;
            netAmount = netAmount + calculateNetProfit(broughtPrice!, soldPrice!, totalQuantity!);
            c++;
            });
          } else {
            print("No positions found.");
          }
        }
      } else {
        print('error in Position ${secondResponse.statusCode}');
      }
    } catch (e) {
      print('error  in position $e');
    } finally {
      print('Total P&L is $netAmount');
    }
  }
  double calculateNetProfit(double buyPrice, double sellPrice, int quantity) {
    // Constants
    const double brokeragePerOrder = 0.0;
    const double sttRate = 0.05 / 100;
    const double exchangeTransactionRate = 0.053 / 100;
    const double gstRate = 18 / 100;
    const double sebiTurnoverRate = 0.0001 / 100;
    const double stampDutyRate = 0.003 / 100;

    // Calculate values
    double buyValue = buyPrice * quantity;
    double sellValue = sellPrice * quantity;
    double grossProfit = sellValue - buyValue;

    // Brokerage Fee
   double totalBrokerage = 2 * brokeragePerOrder;  // Buy and Sell

    // STT
    double sttOnSell = (sttRate * sellValue).roundToDouble();  // Rounded to nearest integer

    // Exchange Transaction Charges
    double exchangeTransactionChargesBuy = exchangeTransactionRate * buyValue;
    double exchangeTransactionChargesSell = exchangeTransactionRate * sellValue;
    double totalExchangeTransactionCharges = exchangeTransactionChargesBuy + exchangeTransactionChargesSell;

    // GST
   double gst = gstRate * (totalBrokerage + totalExchangeTransactionCharges);

    // SEBI Turnover Fees
    double sebiTurnoverFeesBuy = sebiTurnoverRate * buyValue;
    double sebiTurnoverFeesSell = sebiTurnoverRate * sellValue;
    double totalSebiTurnoverFees = sebiTurnoverFeesBuy + sebiTurnoverFeesSell;

    // Stamp Duty
    double stampDuty = stampDutyRate * buyValue;

    // Total Charges
    double totalCharges = sttOnSell + totalExchangeTransactionCharges + gst + totalSebiTurnoverFees + stampDuty;

    // Net Profit or Loss
    double netProfitOrLoss = grossProfit - totalCharges;

    return netProfitOrLoss;
  }
  @override
  void initState() {
    super.initState();
    MyProfitAndLoss();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Total P&L: ${netAmount.toStringAsFixed(2)}',
        textAlign: TextAlign.center, style: TextStyle(fontSize: 25, color: netAmount > -1 ? Colors.green : Colors.red),
      ),
    );
  }
}