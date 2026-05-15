class AppFormatters {
  const AppFormatters._();

  static const List<String> _months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String currency(num amount) {
    final rounded = amount % 1 == 0 ? amount.toInt().toString() : amount.toStringAsFixed(2);
    return 'Rs $rounded';
  }

  static String compactNumber(num value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
  }

  static String date(DateTime value) {
    return '${value.day} ${_months[value.month - 1]} ${value.year}';
  }

  static String dayMonth(DateTime value) {
    return '${value.day} ${_months[value.month - 1]}';
  }

  static String range(DateTime start, DateTime end) {
    return '${dayMonth(start)} - ${dayMonth(end)}';
  }

  static String timeAgo(DateTime value, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final difference = current.difference(value);

    if (difference.inMinutes < 1) {
      return 'just now';
    }
    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    }
    if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }
    return dayMonth(value);
  }

  static String countdown(DateTime target, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final difference = target.difference(current);

    if (difference.isNegative) {
      return 'Ended';
    }
    if (difference.inDays >= 1) {
      return '${difference.inDays}d ${difference.inHours.remainder(24)}h left';
    }
    if (difference.inHours >= 1) {
      return '${difference.inHours}h ${difference.inMinutes.remainder(60)}m left';
    }
    return '${difference.inMinutes}m left';
  }

  static String percent(num value) {
    return '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}%';
  }
}
