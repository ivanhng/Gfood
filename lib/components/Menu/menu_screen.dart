import 'package:flutter/material.dart';
import 'package:gfood_app/components/Menu/menuprovider.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Consumer<MenuProvider>(
        builder: (context, menuProvider, child) {
          return ListView.builder(
            itemCount: menuProvider.menu.categories.length,
            itemBuilder: (context, index) {
              final category = menuProvider.menu.categories[index];
              return ExpansionTile(
                title: Text(category.name),
                children: category.items
                    .map((item) => ListTile(
                          title: Text(item.name),
                          subtitle: Text(item.description),
                          trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                          leading: Image.network(item.imageUrl),
                        ))
                    .toList(),
              );
            },
          );
        },
      ),
    );
  }
}
