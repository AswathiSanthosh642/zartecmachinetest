import 'dart:convert';
RespCategories respCategoriesFromJson(String str) => RespCategories.fromJson(json.decode(str));
String respCategoriesToJson(RespCategories data) => json.encode(data.toJson());
class RespCategories {
  RespCategories({
      this.categories,});

  RespCategories.fromJson(dynamic json) {
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories?.add(Categories.fromJson(v));
      });
    }
  }
  List<Categories>? categories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (categories != null) {
      map['categories'] = categories?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Categories categoriesFromJson(String str) => Categories.fromJson(json.decode(str));
String categoriesToJson(Categories data) => json.encode(data.toJson());
class Categories {
  Categories({
      this.id, 
      this.name, 
      this.dishes,});

  Categories.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    if (json['dishes'] != null) {
      dishes = [];
      json['dishes'].forEach((v) {
        dishes?.add(Dishes.fromJson(v));
      });
    }
  }
  num? id;
  String? name;
  List<Dishes>? dishes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (dishes != null) {
      map['dishes'] = dishes?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Dishes dishesFromJson(String str) => Dishes.fromJson(json.decode(str));
String dishesToJson(Dishes data) => json.encode(data.toJson());
class Dishes {
  Dishes({
      this.id, 
      this.name, 
      this.price, 
      this.currency, 
      this.calories, 
      this.description, 
      this.addons, 
      this.imageUrl, 
      this.customizationsAvailable, 
      this.isVeg,});

  Dishes.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    currency = json['currency'];
    calories = json['calories'];
    description = json['description'];
    if (json['addons'] != null) {
      addons = [];
      json['addons'].forEach((v) {
        addons?.add(Addons.fromJson(v));
      });
    }
    imageUrl = json['image_url'];
    customizationsAvailable = json['customizations_available'];
    isVeg = json['is_veg'];
  }
  num? id;
  String? name;
  String? price;
  String? currency;
  num? calories;
  String? description;
  List<Addons>? addons;
  String? imageUrl;
  bool? customizationsAvailable;
  bool? isVeg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['price'] = price;
    map['currency'] = currency;
    map['calories'] = calories;
    map['description'] = description;
    if (addons != null) {
      map['addons'] = addons?.map((v) => v.toJson()).toList();
    }
    map['image_url'] = imageUrl;
    map['customizations_available'] = customizationsAvailable;
    map['is_veg'] = isVeg;
    return map;
  }

}

Addons addonsFromJson(String str) => Addons.fromJson(json.decode(str));
String addonsToJson(Addons data) => json.encode(data.toJson());
class Addons {
  Addons({
      this.id, 
      this.name, 
      this.price,});

  Addons.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
  }
  num? id;
  String? name;
  String? price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['price'] = price;
    return map;
  }

}