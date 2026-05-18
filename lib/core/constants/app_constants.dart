enum DashboardRange { weekly, monthly }

enum ProductFilter { all, active, inactive, outOfStock }

enum OfferFilter { all, active, upcoming, expired }

enum InquiryFilter { all, pending, responded }

class AppConstants {
  const AppConstants._();

  static const String appName = 'Local Vyapari Partner';
  static const String supportEmail = 'support@localvyapari.com';
  static const String supportPhone = '+91 99999 00000';

  static const List<String> productCategories = <String>[
    'Biryani',
    'Starters',
    'Combos',
    'Bread',
    'Beverages',
    'Desserts',
  ];

  static const List<String> languages = <String>[
    'English',
    'Hindi',
    'Kannada',
  ];

  static const List<String> openingHourOptions = <String>[
    '8:00 AM - 10:30 PM',
    '9:00 AM - 11:00 PM',
    '10:00 AM - 12:00 AM',
  ];
}

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  static const String dashboard = '/dashboard';
  static const String products = '/products';
  static const String offers = '/offers';
  static const String inquiries = '/inquiries';
  static const String profile = '/profile';
  static const String createShop = '/profile/create';

  static const String analytics = '/analytics';
  static const String addProduct = '/products/new';
  static String editProduct(String productId) => '/products/$productId/edit';
  static String productDetail(String productId) => '/products/$productId';

  static const String addOffer = '/offers/new';
  static String editOffer(String offerId) => '/offers/$offerId/edit';

  static String inquiryDetail(String inquiryId) => '/inquiries/$inquiryId';
  static const String settings = '/settings';
}
