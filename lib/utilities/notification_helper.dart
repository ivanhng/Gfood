/*import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gfood_app/components/data/models/restaurant.dart';
import 'package:gfood_app/common/navigation.dart';
import 'package:rxdart/subjects.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  int index = Random().nextInt(20);
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    Restaurants restaurants,
  ) async {
    var _channelId = '1';
    var _channelName = 'channel_01';
    var _channelDescription = 'daily restaurant channel';

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: const DefaultStyleInformation(true, true),
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    var notificationTitle = '<b>Recommendation Restaurant Today</b>';
    var restaurantName = restaurants.items![index].name;

    await flutterLocalNotificationsPlugin.show(
      0,
      notificationTitle,
      restaurantName,
      platformChannelSpecifics,
      payload: json.encode(
        restaurants.toMap(),
      ),
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) {
      var data = Restaurants.fromMap(json.decode(payload));
      var restaurant = data.items![index];
      Navigation.intentWithData(route, arguments: restaurant.place_id);
    });
  }
}*/
