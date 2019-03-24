#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

#-keep class com.botafi.narai.DetectedQR { *; }
#-keep class com.botafi.narai.QR { *; }
-keepclassmembers class com.botafi.narai.DetectedQR { <fields>; }
-keepclassmembers class com.botafi.narai.QR { <fields>; }

-dontwarn java.**

-ignorewarnings