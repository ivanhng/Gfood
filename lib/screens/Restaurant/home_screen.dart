/*import 'package:flutter/material.dart';
import 'package:gfood_app/components/constant.dart';
import 'package:gfood_app/screens/restaurant/detail_screen.dart';
import 'package:gfood_app/screens/restaurant/favourite_screen.dart';
import 'package:gfood_app/screens/restaurant/list_screen.dart';
import 'package:gfood_app/screens/Setting/setting.dart';
import 'package:gfood_app/common/styles.dart';
import 'package:gfood_app/utilities/notification_helper.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState(title: '');
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  final List<Widget> _pages;
  int _currentPage = 0;
  String _title;

  _HomeScreenState({required String title})
      : _title = title,
        _pages = [
          const ListScreen(),
          FavoriteScreen(),
          SettingsPage(),
        ];

  @override
  void initState() {
    super.initState();
    _notificationHelper.configureSelectNotificationSubject(
      DetailScreen.routeName,
    );
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index;
      if (_currentPage == 0) {
        _title = 'Home';
      } else if (_currentPage == 1) {
        _title = 'Favourite';
      } else {
        _title = 'Settings';
      }
    });
  }

  List<Widget> _buildScreens() {
    return [
      const ListScreen(),
      const FavoriteScreen(),
      const SettingsPage(),
    ];
  }

  /*List<PersistentBottomNavBarItem> _navBarItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.view_agenda),
        title: 'Home',
        textStyle: TextStyles.kRegularTitle.copyWith(
          fontWeight: FontWeight.w400,
        ),
        activeColorPrimary:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
        inactiveColorPrimary:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.favorite),
        title: 'Favourite',
        textStyle: TextStyles.kRegularTitle.copyWith(
          fontWeight: FontWeight.w400,
        ),
        activeColorPrimary:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
        inactiveColorPrimary:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        title: 'Settings',
        textStyle: TextStyles.kRegularTitle.copyWith(
          fontWeight: FontWeight.w400,
        ),
        activeColorPrimary:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
        inactiveColorPrimary:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      ),
    ];
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentPage,
        children: _buildScreens(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF4A148C),
        showUnselectedLabels: true,
        unselectedItemColor: kPrimaryLightColor,
        unselectedLabelStyle: const TextStyle(color: kPrimaryLightColor),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_agenda),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentPage,
        onTap: _onItemTapped,
      ),
    );
    /*return PersistentTabView(
      context,
      screens: _buildScreens(),
      items: _navBarItems(context),
      confineInSafeArea: true,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
      navBarStyle: NavBarStyle.style9,
    );*/
  }
}
*/