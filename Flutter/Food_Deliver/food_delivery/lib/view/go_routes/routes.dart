import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:food_delivery/view/login_screen.dart';
import 'package:food_delivery/view/signup_screen.dart';
import 'package:food_delivery/view/restaurant_list_screen.dart';
import 'package:food_delivery/view/menu_screen.dart';
import 'package:food_delivery/view/cart_screen.dart';
import 'package:food_delivery/view/orders_screen.dart';
import 'package:food_delivery/model/restaurant.dart';
final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/restaurants',
      builder: (context, state) => const RestaurantListScreen(),
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) {
        final restaurant = state.extra as Restaurant;
        return MenuScreen(restaurant: restaurant);
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
GoRoute(
path: '/orders',
builder: (context, state) => const OrdersScreen(),
),

  ],
);