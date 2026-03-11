// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';
//
// class Premium {
//   final bool isPurchased;
//   final int premiumPrice;
//   final DateTime purchaseDate;
//
//   Premium({required this.isPurchased, required this.premiumPrice, required this.purchaseDate});
//
//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'isPurchased': isPurchased,
//       'premiumPrice': premiumPrice,
//       'purchaseDate': purchaseDate.millisecondsSinceEpoch,
//     };
//   }
//
//   factory Premium.fromMap(Map<String, dynamic> map) {
//     return Premium(
//       isPurchased: map['isPurchased'] ?? false,
//       premiumPrice: map['premiumPrice'] ?? 0,
//       purchaseDate: DateTime.fromMillisecondsSinceEpoch(map['purchaseDate'] as int),
//     );
//   }
//
//   String toJson() => json.encode(toMap());
//
//   factory Premium.fromJson(String source) => Premium.fromMap(json.decode(source) as Map<String, dynamic>);
// }
