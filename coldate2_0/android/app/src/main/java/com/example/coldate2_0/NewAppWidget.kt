package com.example.coldate2_0

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.content.SharedPreferences
import android.widget.Button
import android.widget.TextView
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.w3c.dom.Text

/**
 * Implementation of App Widget functionality.
 */
class NewAppWidget : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
        val pendingIntent: PendingIntent = Intent(context, MainActivity::class.java).let { intent -> PendingIntent.getActivity(context, 0, intent, 0) }
        val pref = context.getSharedPreferences("DataSrore", Context.MODE_PRIVATE);
        val stringvalue = pref.getString("Input", "NoData")
        val views = RemoteViews(context.packageName, R.layout.new_app_widget).apply{
            setOnClickPendingIntent(R.id.appwidget_text,pendingIntent)
        }
        views.setTextViewText(R.id.appwidget_text, stringvalue + "kCal")
        views.setOnClickPendingIntent(R.id.appwidget_text, pendingIntent)

        appWidgetManager.updateAppWidget(appWidgetIds, views)




    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }


}



internal fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
    val pref = context.getSharedPreferences("DataSrore", Context.MODE_PRIVATE);
    val stringvalue = pref.getString("Input", "Could not get")
    val widgetText = context.getString(R.string.appwidget_text)
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.new_app_widget)
    views.setTextViewText(R.id.appwidget_text, stringvalue + "kCal")



    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}