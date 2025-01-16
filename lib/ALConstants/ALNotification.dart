import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class CLNotification {
  static final _note = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String>();

  Future<NotificationDetails> notificationDetails({
    Uint8List? bitmap,
    String? groupKey,
    String? id,
  }) async {
    // إعداد أيقونة كبيرة
    AndroidBitmap<Object>? largeIcon = bitmap != null ? ByteArrayAndroidBitmap(bitmap) : null;

    // إعداد نمط BigPictureStyle
    BigPictureStyleInformation? bigPictureStyleInformation = bitmap != null
        ? BigPictureStyleInformation(
      ByteArrayAndroidBitmap(bitmap),
      largeIcon: largeIcon,
    )
        : null;

    // إعداد تفاصيل الإشعار
    return NotificationDetails(
      android: AndroidNotificationDetails(
        id ?? 'default_id',
        groupKey ?? 'default_group',
        channelDescription: 'Default channel description',
        icon: '@mipmap/ic_launcher',
        showProgress: false,
        channelShowBadge: true,
        enableVibration: false,
        enableLights: false,
        playSound: true,
        priority: Priority.high,
        groupKey: groupKey,
        setAsGroupSummary: true,
        visibility: NotificationVisibility.public,
        importance: Importance.high,
        styleInformation: bigPictureStyleInformation, // إضافة هذا السطر لدعم BigPictureStyle
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  Future<void> configuration() async {
    // إعدادات Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // إعدادات iOS
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // إعدادات عامة
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // تهيئة الإشعارات
    await _note.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        onNotification.add(response.payload ?? '');
      },
    );
  }

  Future<void> showNote({
    String? groupKey,
    required int id,
    String? title,
    String? body,
    String? payload,
    Uint8List? bitmap,
  }) async {
    _note.show(
      id,
      title,
      body,
      await notificationDetails(
        bitmap: bitmap,
        id: id.toString(),
        groupKey: groupKey,
      ),
      payload: payload,
    );
  }

  Future<void> cancelAllForGroup({required int id}) async {
    await _note.cancel(id);
  }

  Future<void> cancelAll() async {
    await _note.cancelAll();
  }
}
