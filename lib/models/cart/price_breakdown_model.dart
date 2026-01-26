class PriceBreakdown {
  final double subTotal;
  final bool isFreeShippingEligible;
  final double shippingPrice;
  final double totalValue;

  PriceBreakdown({
    required this.subTotal,
    required this.isFreeShippingEligible,
    required this.shippingPrice,
    required this.totalValue,
  });

  factory PriceBreakdown.fromJson(Map<String, dynamic> json) {
    return PriceBreakdown(
      subTotal: (json['subTotal'] as num).toDouble(),
      isFreeShippingEligible: json['isFreeShippingEligible'],
      shippingPrice: (json['shippingPrice'] as num).toDouble(),
      totalValue: (json['totalValue'] as num).toDouble(),
    );
  }

  /// Zero state
  factory PriceBreakdown.empty() {
    return PriceBreakdown(
      subTotal: 0,
      isFreeShippingEligible: false,
      shippingPrice: 0,
      totalValue: 0,
    );
  }
}