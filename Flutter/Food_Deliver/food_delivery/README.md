# 🍔 FoodRush — Flutter Food Delivery App

A production-level Flutter food delivery app built with **MVVM architecture**, **Riverpod**, **built_value**, and **SQLite**.

---

## 🧰 Tech Stack

| Layer | Technology |
|---|---|
| Architecture | MVVM |
| State Management | Riverpod (`flutter_riverpod`) |
| Immutable Models | `built_value` + `built_collection` |
| Local Database | SQLite (`sqflite`) |
| Code Generation | `build_runner` |

---

## 📂 Project Structure

```
lib/
  core/services/
    local_storage_service.dart        ← Abstract interface (Repository contract)

  services/
    local_storage_service_impl.dart   ← SQLite implementation

  model/
    restaurant.dart                   ← built_value model
    food_item.dart                    ← built_value model
    cart_item.dart                    ← built_value model
    order.dart                        ← built_value model
    serializers.dart                  ← built_value serializers
    *.g.dart                          ← Generated code

  view/
    restaurant_list_screen.dart       ← Screen 1: Browse restaurants
    menu_screen.dart                  ← Screen 2: View restaurant menu
    cart_screen.dart                  ← Screen 3: Cart & checkout
    orders_screen.dart                ← Screen 4: Order history

  viewmodel/
    view_model.dart                   ← All Riverpod providers & StateNotifiers

  main.dart
```

---

## 🚀 Getting Started

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Generate built_value code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

> ⚠️ The `.g.dart` files are **pre-generated** and included in the project. You only need to re-run `build_runner` if you modify the model files.

### 3. Run the app
```bash
flutter run
```

---

## ✨ Features

- **Restaurant List** — Browse restaurants with ratings, delivery time & fees
- **Menu Screen** — View categorized menu items with images and prices
- **Cart** — Add/remove items, adjust quantities, view bill summary
- **Place Order** — Enter delivery address and place order
- **Order History** — View all past orders with status
- **Persistence** — Cart and orders survive app restarts via SQLite

---

## 🏗️ Architecture: MVVM

```
View  ──────►  ViewModel (Riverpod)  ──────►  Repository
  ▲                                         (LocalStorageService)
  │                                                  │
  └──────────── state update ◄─────────────────  SQLite
```

### MVVM Layers

**Model** — Immutable `built_value` classes: `Restaurant`, `FoodItem`, `CartItem`, `Order`

**ViewModel** — Riverpod `StateNotifier` classes: `CartNotifier`, `OrdersNotifier` plus simple `Provider`s for restaurants and menu items

**View** — Pure UI widgets that watch providers and call ViewModel methods. No business logic, no `setState` for state management

**Repository** — `LocalStorageService` interface implemented by `LocalStorageServiceImpl` using `sqflite`

---

## 🗄 SQLite Schema

### `cart_items` table
| Column | Type |
|---|---|
| id | INTEGER PRIMARY KEY AUTOINCREMENT |
| food_item_id | INTEGER |
| food_item_name | TEXT |
| price | REAL |
| image_url | TEXT |
| quantity | INTEGER |
| restaurant_id | INTEGER |
| restaurant_name | TEXT |

### `orders` table
| Column | Type |
|---|---|
| id | INTEGER PRIMARY KEY AUTOINCREMENT |
| restaurant_name | TEXT |
| items_json | TEXT (JSON array) |
| total_amount | REAL |
| status | TEXT |
| placed_at | TEXT (ISO 8601) |
| delivery_address | TEXT |

---

## ✅ Assignment Requirements Checklist

- [x] MVVM Architecture
- [x] Riverpod for state management (no `setState` for business logic)
- [x] `built_value` for immutable models with `rebuild()`
- [x] SQLite (`sqflite`) for local persistence
- [x] Repository pattern (`LocalStorageService` interface + impl)
- [x] Restaurant List screen
- [x] Menu screen
- [x] Cart screen
- [x] Place Order functionality
- [x] Cart persists across app restarts
- [x] Orders persist across app restarts
- [x] No mutable models
- [x] UI never accesses database directly
