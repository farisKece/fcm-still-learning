// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';

// class NotificationController extends GetxController {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void onInit() {
//     super.onInit();
//     _initializeFCM();
//     _checkForInitialMessage();
//     _initializeLocalNotifications();
//   }

//   void _initializeLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//       notificationCategories: darwinNotificationCategories,
//     );

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//   }

//   void _initializeFCM() async {
//     String? token = await _firebaseMessaging.getToken();
//     print("FCM Token: $token");

//     await _firebaseMessaging.requestPermission();

//     // Mendengarkan notifikasi saat aplikasi di foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       Get.snackbar(
//         message.notification?.title ?? 'Notifikasi',
//         message.notification?.body ?? '',
//       );
//     });

//     // Mendengarkan notifikasi yang dibuka dari tray
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _handleMessage(message);
//     });
//   }

//   // Mengecek jika aplikasi dibuka dari notifikasi saat terminated
//   void _checkForInitialMessage() async {
//     RemoteMessage? initialMessage =
//         await _firebaseMessaging.getInitialMessage();
//     if (initialMessage != null) {
//       print(
//           'Aplikasi dibuka dari notifikasi saat terminated: ${initialMessage.notification?.title}');
//       _handleMessage(initialMessage);
//     }
//   }

//   // Fungsi untuk menangani logika navigasi atau aksi berdasarkan notifikasi
//   void _handleMessage(RemoteMessage message) {
//     if (message.data.containsKey('productId')) {
//       String productId = message.data['productId'];
//       Get.toNamed('/productDetail', arguments: {'productId': productId});
//     } else {
//       Get.offAllNamed('/home'); // Arahkan ke home jika tidak ada ID produk
//     }
//   }
// }

// import 'package:get/get.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationController extends GetxController {
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   late FirebaseMessaging messaging;

//   @override
//   void onInit() {
//     print('NotificationController initialized');
//     _initializeFCM();
//     print('goblok');
//     _initializeLocalNotifications();
//     print('anjay');
//     super.onInit();
//   }

//   void _initializeFCM() {
//     messaging = FirebaseMessaging.instance;

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message while in the foreground!');

//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//         _showNotification(message);
//       } else {
//         print('gak ada pesan');
//       }
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // Handle when a user taps on the notification and app opens
//       _navigateToDetailPage(message.data);
//     });
//   }

//   void _initializeLocalNotifications() {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         if (response.payload != null) {
//           _navigateToDetailPage({'payload': response.payload!});
//         }
//       },
//     );
//   }

//   void _showNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails('channel_id', 'channel_name',
//             importance: Importance.max,
//             priority: Priority.high,
//             showWhen: false);
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title ?? 'No Title',
//       message.notification?.body ?? 'No Body',
//       platformChannelSpecifics,
//       payload: message.data['payload'] ?? 'No Data',
//     );
//   }

//   void _navigateToDetailPage(Map<String, dynamic> data) {
//     // Navigasi ke halaman detail atau halaman lainnya menggunakan Get.to
//     Get.toNamed('/detail', arguments: data);
//   }
// }

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var token = ''.obs;

  @override
  void onInit() async {
    await requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened app');
      print(message);
    });
    super.onInit();
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permisson');
    } else {
      print('declined or has not accepted permission');
    }
  }
}
