import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../controllers/category_controller.dart';
import '../models/RespCategories.dart';
import 'order_summary.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Consumer2<CategoryController, AuthController>(
      builder: (context, controller, auth, child) {
        if (controller.isLoading && (controller.categories == null || controller.categories!.isEmpty)) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final categories = controller.categories ?? [];

        if (categories.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("No Data")),
          );
        }

        final user = auth.user;

        return DefaultTabController(
          length: categories.length,
          child: Scaffold(
            key: scaffoldKey,
            drawer: Drawer(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 50, bottom: 30),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.lightGreenAccent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.brown.shade200,
                          backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
                          child: user?.photoUrl == null ? const Icon(Icons.person, size: 40, color: Colors.white) : null,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user?.displayName ?? user?.displayName ?? "User",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "ID : ${user?.id ?? ''}",
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.grey),
                    title: const Text("Log out", style: TextStyle(color: Colors.grey, fontSize: 16)),
                    onTap: () {
                      Navigator.pop(context);
                      auth.signOut();
                    },
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu, color: Colors.grey),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                  child: Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OrderSummary()),
                          );
                        },
                        icon: Icon(Icons.shopping_cart, color: Colors.grey.shade700),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: IgnorePointer(
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.red,
                            child: Text(
                              "${controller.totalCartCount}",
                              style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.red,
                labelColor: Colors.red,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: categories.map((cat) => Tab(text: cat.name)).toList(),
              ),
            ),
            body: TabBarView(
              children: categories.map((cat) {
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: cat.dishes?.length ?? 0,
                  separatorBuilder: (context, index) => const Divider(height: 32),
                  itemBuilder: (context, index) {
                    final dish = cat.dishes![index];
                    return DishListItem(dish: dish);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class DishListItem extends StatelessWidget {
  final Dishes dish;

  const DishListItem({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, controller, child) {
        final quantity = controller.getQuantity(dish.id ?? 0);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                border: Border.all(
                  color: dish.isVeg == true ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.circle,
                size: 10,
                color: dish.isVeg == true ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${dish.currency} ${dish.price}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        '${dish.calories} calories',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dish.description ?? '',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    height: 36,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            controller.decrementQuantity(dish.id ?? 0);
                          },
                          icon: const Icon(Icons.remove, color: Colors.white, size: 20),
                        ),
                        Text(
                          '$quantity',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            controller.incrementQuantity(dish.id ?? 0);
                          },
                          icon: const Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                  if (dish.customizationsAvailable == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Customizations Available",
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(width: 12),

            if (dish.imageUrl != null && dish.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  dish.imageUrl!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(width: 80, height: 80),
                ),
              )
            else
              const SizedBox(width: 80, height: 80),
          ],
        );
      },
    );
  }
}
