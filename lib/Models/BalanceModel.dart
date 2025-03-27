class BalanceModel {
  String? type;
  String? code;
  String? description;
  Result? result;

  BalanceModel({this.type, this.code, this.description, this.result});

  BalanceModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    code = json['code'];
    description = json['description'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['code'] = this.code;
    data['description'] = this.description;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  BalanceList? balanceList;

  Result({this.balanceList});

  Result.fromJson(Map<String, dynamic> json) {
    balanceList = json['BalanceList'] != null
        ? new BalanceList.fromJson(json['BalanceList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.balanceList != null) {
      data['BalanceList'] = this.balanceList!.toJson();
    }
    return data;
  }
}

class BalanceList {
  String? limitHeader;
  LimitObject? limitObject;

  BalanceList({this.limitHeader, this.limitObject});

  BalanceList.fromJson(Map<String, dynamic> json) {
    limitHeader = json['limitHeader'];
    limitObject = json['limitObject'] != null
        ? new LimitObject.fromJson(json['limitObject'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limitHeader'] = this.limitHeader;
    if (this.limitObject != null) {
      data['limitObject'] = this.limitObject!.toJson();
    }
    return data;
  }
}

class LimitObject {
  RMSSubLimits? rMSSubLimits;
  MarginAvailable? marginAvailable;
  MarginUtilized? marginUtilized;
  LimitsAssigned? limitsAssigned;
  String? accountID;

  LimitObject(
      {this.rMSSubLimits,
        this.marginAvailable,
        this.marginUtilized,
        this.limitsAssigned,
        this.accountID});

  LimitObject.fromJson(Map<String, dynamic> json) {
    rMSSubLimits = json['RMSSubLimits'] != null
        ? new RMSSubLimits.fromJson(json['RMSSubLimits'])
        : null;
    marginAvailable = json['marginAvailable'] != null
        ? new MarginAvailable.fromJson(json['marginAvailable'])
        : null;
    marginUtilized = json['marginUtilized'] != null
        ? new MarginUtilized.fromJson(json['marginUtilized'])
        : null;
    limitsAssigned = json['limitsAssigned'] != null
        ? new LimitsAssigned.fromJson(json['limitsAssigned'])
        : null;
    accountID = json['AccountID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rMSSubLimits != null) {
      data['RMSSubLimits'] = this.rMSSubLimits!.toJson();
    }
    if (this.marginAvailable != null) {
      data['marginAvailable'] = this.marginAvailable!.toJson();
    }
    if (this.marginUtilized != null) {
      data['marginUtilized'] = this.marginUtilized!.toJson();
    }
    if (this.limitsAssigned != null) {
      data['limitsAssigned'] = this.limitsAssigned!.toJson();
    }
    data['AccountID'] = this.accountID;
    return data;
  }
}

class RMSSubLimits {
  int? cashAvailable;
  int? collateral;
  double? marginUtilized;
  double? netMarginAvailable;
  int? mTM;
  int? unrealizedMTM;
  int? realizedMTM;

  RMSSubLimits(
      {this.cashAvailable,
        this.collateral,
        this.marginUtilized,
        this.netMarginAvailable,
        this.mTM,
        this.unrealizedMTM,
        this.realizedMTM});

  RMSSubLimits.fromJson(Map<String, dynamic> json) {
    cashAvailable = json['cashAvailable'];
    collateral = json['collateral'];
    marginUtilized = json['marginUtilized'];
    netMarginAvailable = json['netMarginAvailable'];
    mTM = json['MTM'];
    unrealizedMTM = json['UnrealizedMTM'];
    realizedMTM = json['RealizedMTM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cashAvailable'] = this.cashAvailable;
    data['collateral'] = this.collateral;
    data['marginUtilized'] = this.marginUtilized;
    data['netMarginAvailable'] = this.netMarginAvailable;
    data['MTM'] = this.mTM;
    data['UnrealizedMTM'] = this.unrealizedMTM;
    data['RealizedMTM'] = this.realizedMTM;
    return data;
  }
}

class MarginAvailable {
  int? cashMarginAvailable;
  int? adhocMargin;
  int? notinalCash;
  int? payInAmount;
  int? payOutAmount;
  int? cNCSellBenifit;
  int? directCollateral;
  int? holdingCollateral;
  int? clientBranchAdhoc;
  int? sellOptionsPremium;
  int? totalBranchAdhoc;
  int? adhocFOMargin;
  int? adhocCurrencyMargin;
  int? adhocCommodityMargin;

  MarginAvailable(
      {this.cashMarginAvailable,
        this.adhocMargin,
        this.notinalCash,
        this.payInAmount,
        this.payOutAmount,
        this.cNCSellBenifit,
        this.directCollateral,
        this.holdingCollateral,
        this.clientBranchAdhoc,
        this.sellOptionsPremium,
        this.totalBranchAdhoc,
        this.adhocFOMargin,
        this.adhocCurrencyMargin,
        this.adhocCommodityMargin});

  MarginAvailable.fromJson(Map<String, dynamic> json) {
    cashMarginAvailable = json['CashMarginAvailable'];
    adhocMargin = json['AdhocMargin'];
    notinalCash = json['NotinalCash'];
    payInAmount = json['PayInAmount'];
    payOutAmount = json['PayOutAmount'];
    cNCSellBenifit = json['CNCSellBenifit'];
    directCollateral = json['DirectCollateral'];
    holdingCollateral = json['HoldingCollateral'];
    clientBranchAdhoc = json['ClientBranchAdhoc'];
    sellOptionsPremium = json['SellOptionsPremium'];
    totalBranchAdhoc = json['TotalBranchAdhoc'];
    adhocFOMargin = json['AdhocFOMargin'];
    adhocCurrencyMargin = json['AdhocCurrencyMargin'];
    adhocCommodityMargin = json['AdhocCommodityMargin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CashMarginAvailable'] = this.cashMarginAvailable;
    data['AdhocMargin'] = this.adhocMargin;
    data['NotinalCash'] = this.notinalCash;
    data['PayInAmount'] = this.payInAmount;
    data['PayOutAmount'] = this.payOutAmount;
    data['CNCSellBenifit'] = this.cNCSellBenifit;
    data['DirectCollateral'] = this.directCollateral;
    data['HoldingCollateral'] = this.holdingCollateral;
    data['ClientBranchAdhoc'] = this.clientBranchAdhoc;
    data['SellOptionsPremium'] = this.sellOptionsPremium;
    data['TotalBranchAdhoc'] = this.totalBranchAdhoc;
    data['AdhocFOMargin'] = this.adhocFOMargin;
    data['AdhocCurrencyMargin'] = this.adhocCurrencyMargin;
    data['AdhocCommodityMargin'] = this.adhocCommodityMargin;
    return data;
  }
}

class MarginUtilized {
  int? grossExposureMarginPresent;
  int? buyExposureMarginPresent;
  int? sellExposureMarginPresent;
  int? varELMarginPresent;
  int? scripBasketMarginPresent;
  int? grossExposureLimitPresent;
  int? buyExposureLimitPresent;
  int? sellExposureLimitPresent;
  int? cNCLimitUsed;
  int? cNCAmountUsed;
  double? marginUsed;
  int? limitUsed;
  int? totalSpanMargin;
  int? exposureMarginPresent;

  MarginUtilized(
      {this.grossExposureMarginPresent,
        this.buyExposureMarginPresent,
        this.sellExposureMarginPresent,
        this.varELMarginPresent,
        this.scripBasketMarginPresent,
        this.grossExposureLimitPresent,
        this.buyExposureLimitPresent,
        this.sellExposureLimitPresent,
        this.cNCLimitUsed,
        this.cNCAmountUsed,
        this.marginUsed,
        this.limitUsed,
        this.totalSpanMargin,
        this.exposureMarginPresent});

  MarginUtilized.fromJson(Map<String, dynamic> json) {
    grossExposureMarginPresent = json['GrossExposureMarginPresent'];
    buyExposureMarginPresent = json['BuyExposureMarginPresent'];
    sellExposureMarginPresent = json['SellExposureMarginPresent'];
    varELMarginPresent = json['VarELMarginPresent'];
    scripBasketMarginPresent = json['ScripBasketMarginPresent'];
    grossExposureLimitPresent = json['GrossExposureLimitPresent'];
    buyExposureLimitPresent = json['BuyExposureLimitPresent'];
    sellExposureLimitPresent = json['SellExposureLimitPresent'];
    cNCLimitUsed = json['CNCLimitUsed'];
    cNCAmountUsed = json['CNCAmountUsed'];
    marginUsed = json['MarginUsed'];
    limitUsed = json['LimitUsed'];
    totalSpanMargin = json['TotalSpanMargin'];
    exposureMarginPresent = json['ExposureMarginPresent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GrossExposureMarginPresent'] = this.grossExposureMarginPresent;
    data['BuyExposureMarginPresent'] = this.buyExposureMarginPresent;
    data['SellExposureMarginPresent'] = this.sellExposureMarginPresent;
    data['VarELMarginPresent'] = this.varELMarginPresent;
    data['ScripBasketMarginPresent'] = this.scripBasketMarginPresent;
    data['GrossExposureLimitPresent'] = this.grossExposureLimitPresent;
    data['BuyExposureLimitPresent'] = this.buyExposureLimitPresent;
    data['SellExposureLimitPresent'] = this.sellExposureLimitPresent;
    data['CNCLimitUsed'] = this.cNCLimitUsed;
    data['CNCAmountUsed'] = this.cNCAmountUsed;
    data['MarginUsed'] = this.marginUsed;
    data['LimitUsed'] = this.limitUsed;
    data['TotalSpanMargin'] = this.totalSpanMargin;
    data['ExposureMarginPresent'] = this.exposureMarginPresent;
    return data;
  }
}

class LimitsAssigned {
  int? cNCLimit;
  int? turnoverLimitPresent;
  int? mTMLossLimitPresent;
  int? buyExposureLimit;
  int? sellExposureLimit;
  int? grossExposureLimit;
  int? grossExposureDerivativesLimit;
  int? buyExposureFuturesLimit;
  int? buyExposureOptionsLimit;
  int? sellExposureOptionsLimit;
  int? sellExposureFuturesLimit;

  LimitsAssigned(
      {this.cNCLimit,
        this.turnoverLimitPresent,
        this.mTMLossLimitPresent,
        this.buyExposureLimit,
        this.sellExposureLimit,
        this.grossExposureLimit,
        this.grossExposureDerivativesLimit,
        this.buyExposureFuturesLimit,
        this.buyExposureOptionsLimit,
        this.sellExposureOptionsLimit,
        this.sellExposureFuturesLimit});

  LimitsAssigned.fromJson(Map<String, dynamic> json) {
    cNCLimit = json['CNCLimit'];
    turnoverLimitPresent = json['TurnoverLimitPresent'];
    mTMLossLimitPresent = json['MTMLossLimitPresent'];
    buyExposureLimit = json['BuyExposureLimit'];
    sellExposureLimit = json['SellExposureLimit'];
    grossExposureLimit = json['GrossExposureLimit'];
    grossExposureDerivativesLimit = json['GrossExposureDerivativesLimit'];
    buyExposureFuturesLimit = json['BuyExposureFuturesLimit'];
    buyExposureOptionsLimit = json['BuyExposureOptionsLimit'];
    sellExposureOptionsLimit = json['SellExposureOptionsLimit'];
    sellExposureFuturesLimit = json['SellExposureFuturesLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CNCLimit'] = this.cNCLimit;
    data['TurnoverLimitPresent'] = this.turnoverLimitPresent;
    data['MTMLossLimitPresent'] = this.mTMLossLimitPresent;
    data['BuyExposureLimit'] = this.buyExposureLimit;
    data['SellExposureLimit'] = this.sellExposureLimit;
    data['GrossExposureLimit'] = this.grossExposureLimit;
    data['GrossExposureDerivativesLimit'] = this.grossExposureDerivativesLimit;
    data['BuyExposureFuturesLimit'] = this.buyExposureFuturesLimit;
    data['BuyExposureOptionsLimit'] = this.buyExposureOptionsLimit;
    data['SellExposureOptionsLimit'] = this.sellExposureOptionsLimit;
    data['SellExposureFuturesLimit'] = this.sellExposureFuturesLimit;
    return data;
  }
}
