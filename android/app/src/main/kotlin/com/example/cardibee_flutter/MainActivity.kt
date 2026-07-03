package com.example.cardibee_flutter

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createDefaultNotificationChannel()
    }

    // Must match com.google.firebase.messaging.default_notification_channel_id
    // in AndroidManifest.xml. Required for tray notifications on Android 8+.
    private fun createDefaultNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "cardibee_default",
                "General",
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                description = "Offer alerts and reminders"
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }
}
