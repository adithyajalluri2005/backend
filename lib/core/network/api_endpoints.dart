class ApiEndpoints {
  static const String baseUrl = 'https://backend-9g8c.onrender.com/api/v1';
  
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  
  // Shops
  static const String shops = '/shops';
  static const String nearbyShops = '/shops/nearby';
  static String shopDetails(String id) => '/shops/$id';
  static String shopImage(String id) => '/shops/$id/image';
  
  // Products
  static const String products = '/products';
  static String productDetails(String id) => '/products/$id';
  static String productImage(String id) => '/products/$id/image';
  
  // Offers
  static const String offers = '/offers';
  static const String activeOffers = '/offers/active';
  static String deactivateOffer(String id) => '/offers/$id/deactivate';
  
  // Search
  static const String productsNearby = '/search/products-nearby';
  static const String searchHistory = '/search/history';
  
  // Saved Items
  static const String savedShops = '/saved/shops';
  static String bookmarkShop(String shopId) => '/saved/shops/$shopId';
  static const String savedProducts = '/saved/products';
  static String bookmarkProduct(String productId) => '/saved/products/$productId';
  
  // Merchant
  static const String merchantDashboard = '/merchant/dashboard';
}
