# Keep Error Prone annotations
-keep class com.google.errorprone.annotations.** { *; }

# Keep Tink classes and methods
-keep class com.google.crypto.tink.** { *; }

# Prevent stripping metadata used by Tink
-keepnames class com.google.crypto.tink.**
-keepclassmembers class com.google.crypto.tink.** {
    *;
}

# Suppress warnings for missing Error Prone annotations
-dontwarn com.google.errorprone.annotations.CanIgnoreReturnValue
-dontwarn com.google.errorprone.annotations.CheckReturnValue
-dontwarn com.google.errorprone.annotations.Immutable
-dontwarn com.google.errorprone.annotations.RestrictedApi

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.api.client.http.GenericUrl
-dontwarn com.google.api.client.http.HttpHeaders
-dontwarn com.google.api.client.http.HttpRequest
-dontwarn com.google.api.client.http.HttpRequestFactory
-dontwarn com.google.api.client.http.HttpResponse
-dontwarn com.google.api.client.http.HttpTransport
-dontwarn com.google.api.client.http.javanet.NetHttpTransport$Builder
-dontwarn com.google.api.client.http.javanet.NetHttpTransport
-dontwarn com.google.errorprone.annotations.InlineMe
-dontwarn org.joda.time.Instant

 -keep class com.kbyai.facesdk.** {*;}
