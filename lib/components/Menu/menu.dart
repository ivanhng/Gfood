class MenuItem {
  String name;
  String description;
  double price;
  String imageUrl;

  MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class MenuCategory {
  String name;
  List<MenuItem> items;

  MenuCategory({
    required this.name,
    required this.items,
  });
}

class Menu {
  List<MenuCategory> categories;

  Menu({required this.categories});
}
