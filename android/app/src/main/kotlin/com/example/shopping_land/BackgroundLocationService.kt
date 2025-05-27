package com.levant.shopping.land.delivery

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

class BackgroundLocationService : Service() {
    private val CHANNEL_ID = "location_channel_01" // جعل المعرف فريداً
    private val NOTIFICATION_ID = 101 // معرف فريد للإشعار

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        startServiceProperly()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "خدمة الموقع", // استخدام اسم عربي إذا كان التطبيق بالعربية
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "تتبع الموقع في الخلفية"
                setShowBadge(false)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            }

            val manager = getSystemService(NotificationManager::class.java) as NotificationManager
            manager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("تتبع الموقع")
            .setContentText("جاري تتبع موقعك في الخلفية")
            .setSmallIcon(R.drawable.ic_notification)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true) // إشعار مستمر لا يمكن إزالته
            .setAutoCancel(false) // لا يختفي عند النقر عليه
            .setCategory(Notification.CATEGORY_SERVICE)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .build()
    }

    private fun startServiceProperly() {
        val notification = createNotification()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForeground(NOTIFICATION_ID, notification)
        } else {
            startForeground(NOTIFICATION_ID, notification)
            startService(Intent(this, BackgroundLocationService::class.java))
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // إعادة إنشاء الإشعار إذا تم إنهاء الخدمة
        startServiceProperly()
        return START_STICKY
    }

    companion object {
        fun startService(context: Context) {
            val serviceIntent = Intent(context, BackgroundLocationService::class.java)
            ContextCompat.startForegroundService(context, serviceIntent)
        }
    }
}