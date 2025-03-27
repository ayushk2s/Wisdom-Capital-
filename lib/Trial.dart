void main(){
  double profitAmountController = 4, slController = 1, lastTradedPriceNiftyCE = 50.00;
  double profitAmount = profitAmountController;
  double slAmount = slController;

  // Calculate profit and stop loss amounts as percentages of lastTradedPriceNiftyCE
  double profitTarget = lastTradedPriceNiftyCE * (profitAmount / 100);
  double stopLossTarget = lastTradedPriceNiftyCE * (slAmount / 100);
  profitTarget = roundFun(profitTarget);
  stopLossTarget = roundFun(stopLossTarget);
  print('Profit $profitTarget stoploss $stopLossTarget');
}

double roundFun(double modifyTick){
  String roundedValue = ((modifyTick / 0.05).round() * 0.05).toStringAsFixed(2);
  double roundedTrailingSL = double.parse(roundedValue);
  return roundedTrailingSL;
}