class ApiResponse<T> {
  final bool success;
  final String message;
  final List<String>? messages;
  final T? data;
  final Map<String, dynamic>? meta;
  final int? statusCode;
  final String? path;
  final String? timestamp;

  ApiResponse({
    required this.success,
    this.message = '',
    this.messages,
    this.data,
    this.meta,
    this.statusCode,
    this.path,
    this.timestamp,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    String message = '';
    List<String>? messages;

    if (json['message'] is String) {
      message = json['message'];
    } else if (json['message'] is List) {
      messages = List<String>.from(json['message']);
      message = messages.isNotEmpty ? messages.first : '';
    }

    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: message,
      messages: messages,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      meta: json['meta'],
      statusCode: json['statusCode'],
      path: json['path'],
      timestamp: json['timestamp'],
    );
  }

  String get fullMessage => messages?.join(', ') ?? message;
}
