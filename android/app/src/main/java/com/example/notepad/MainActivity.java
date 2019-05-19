package com.example.notepad;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  String savedNote;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    Intent intent = getIntent();
    String action = intent.getAction();
    String type = intent.getType();

    if("com.google.android.gms.actions.CREATE_NOTE".equals(action) && type != null) {
      if ("text/plain".equals(type)) {
        savedNote = intent.getStringExtra(Intent.EXTRA_TEXT);
      }
    }

    new MethodChannel(getFlutterView(), "app.channel.shared.data")
            .setMethodCallHandler((methodCall, result) -> {
              if(methodCall.method.contentEquals("getSavedNote")) {
                result.success(savedNote);
                savedNote = null;
              }
            });
  }
}
