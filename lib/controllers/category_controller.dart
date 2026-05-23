
import 'package:flutter/cupertino.dart';

import '../models/RespCategories.dart';
import '../services/api_service.dart';


class CategoryController extends ChangeNotifier {

  bool isLoading = false;
  int selectedIndex = 0;
  List<Categories>? categories = [];
  Map<num, int> dishQuantities = {};
  ApiService apiService = ApiService();
  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();

    categories = await apiService.fetchCategory();

    isLoading = false;
    notifyListeners();
  }

  void changeCategory(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void incrementQuantity(num dishId) {
    if (dishQuantities.containsKey(dishId)) {
      dishQuantities[dishId] = dishQuantities[dishId]! + 1;
    } else {
      dishQuantities[dishId] = 1;
    }
    notifyListeners();
  }

  void decrementQuantity(num dishId) {
    if (dishQuantities.containsKey(dishId) && dishQuantities[dishId]! > 0) {
      dishQuantities[dishId] = dishQuantities[dishId]! - 1;

      if (dishQuantities[dishId] == 0) {
        dishQuantities.remove(dishId);
      }
      notifyListeners();
    }
  }

  int getQuantity(num dishId) {
    return dishQuantities[dishId] ?? 0;
  }

  int get totalCartCount {
    int count = 0;
    dishQuantities.forEach((key, value) {
      count += value;
    });
    return count;
  }

  List<Dishes> get cartItems {
    List<Dishes> items = [];
    if (categories == null) return items;

    for (var category in categories!) {
      if (category.dishes != null) {
        for (var dish in category.dishes!) {
          if (dishQuantities.containsKey(dish.id) && dishQuantities[dish.id]! > 0) {
            items.add(dish);
          }
        }
      }
    }
    return items;
  }

  double get totalAmount {
    double total = 0;
    for (var dish in cartItems) {
      double price = double.tryParse(dish.price ?? '0') ?? 0;
      total += price * (dishQuantities[dish.id] ?? 0);
    }
    return total;
  }

  void clearCart() {
    dishQuantities.clear();
    notifyListeners();
  }
}
