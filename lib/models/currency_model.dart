class Currency {
  final String name;
  final String code;
  final String symbolLeft;
  final String symbolRight;
  final String value;

  Currency({
    required this.name,
    required this.code,
    required this.symbolLeft,
    required this.symbolRight,
    required this.value,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      symbolLeft: json['symbol_left'] ?? '',
      symbolRight: json['symbol_right'] ?? '',
      value: json['value'] ?? '',
    );
  }
}