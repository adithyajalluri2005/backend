import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/features/analytics/analytics_screen.dart';
import 'package:vendor_app/features/auth/login_screen.dart';
import 'package:vendor_app/features/auth/register_screen.dart';
import 'package:vendor_app/features/auth/splash_screen.dart';
import 'package:vendor_app/features/dashboard/dashboard_screen.dart';
import 'package:vendor_app/features/dashboard/main_wrapper.dart';
import 'package:vendor_app/features/inquiries/inquiries_screen.dart';
import 'package:vendor_app/features/inquiries/inquiry_detail_screen.dart';
import 'package:vendor_app/features/offers/offer_editor_screen.dart';
import 'package:vendor_app/features/offers/offers_discounts_screen.dart';
import 'package:vendor_app/features/products/add_product_screen.dart';
import 'package:vendor_app/features/products/my_products_screen.dart';
import 'package:vendor_app/features/products/product_detail_screen.dart';
import 'package:vendor_app/features/profile/shop_profile_screen.dart';
import 'package:vendor_app/features/shops/create_shop_screen.dart';
import 'package:vendor_app/features/settings/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (BuildContext context, GoRouterState state) => const RegisterScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) {
        return MainWrapper(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (BuildContext context, GoRouterState state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.products,
              builder: (BuildContext context, GoRouterState state) => const ProductsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.offers,
              builder: (BuildContext context, GoRouterState state) => const OffersDiscountsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.inquiries,
              builder: (BuildContext context, GoRouterState state) => const InquiriesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.profile,
              builder: (BuildContext context, GoRouterState state) => const ShopProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.analytics,
      builder: (BuildContext context, GoRouterState state) => const AnalyticsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.addProduct,
      builder: (BuildContext context, GoRouterState state) => const AddProductScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/products/:productId',
      builder: (BuildContext context, GoRouterState state) {
        return ProductDetailScreen(productId: state.pathParameters['productId']!);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/products/:productId/edit',
      builder: (BuildContext context, GoRouterState state) {
        return AddProductScreen(productId: state.pathParameters['productId']!);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.addOffer,
      builder: (BuildContext context, GoRouterState state) => const OfferEditorScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/offers/:offerId/edit',
      builder: (BuildContext context, GoRouterState state) {
        return OfferEditorScreen(offerId: state.pathParameters['offerId']!);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/inquiries/:inquiryId',
      builder: (BuildContext context, GoRouterState state) {
        return InquiryDetailScreen(inquiryId: state.pathParameters['inquiryId']!);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.settings,
      builder: (BuildContext context, GoRouterState state) => const SettingsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.createShop,
      builder: (BuildContext context, GoRouterState state) => const CreateShopScreen(),
    ),
  ],
);
