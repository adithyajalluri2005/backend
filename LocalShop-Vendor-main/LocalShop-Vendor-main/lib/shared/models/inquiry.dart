class Inquiry {
  const Inquiry({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.productId,
    required this.productName,
    required this.status,
    required this.date,
    required this.message,
    required this.quantity,
  });

  final String id;
  final String customerName;
  final String customerPhone;
  final String productId;
  final String productName;
  final String status;
  final DateTime date;
  final String message;
  final int quantity;

  bool get isPending => status == 'Pending';

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      status: json['status'] as String,
      date: DateTime.parse(json['date'] as String),
      message: json['message'] as String,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'productId': productId,
      'productName': productName,
      'status': status,
      'date': date.toIso8601String(),
      'message': message,
      'quantity': quantity,
    };
  }

  Inquiry copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? productId,
    String? productName,
    String? status,
    DateTime? date,
    String? message,
    int? quantity,
  }) {
    return Inquiry(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      status: status ?? this.status,
      date: date ?? this.date,
      message: message ?? this.message,
      quantity: quantity ?? this.quantity,
    );
  }
}
