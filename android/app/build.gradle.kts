plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mi_app"              // <-- cámbialo si tu package es otro
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true     // KTS: usa el prefijo is*
    }

    kotlinOptions {
        jvmTarget = "17"                          // KTS: string
    }

    defaultConfig {
        applicationId = "com.example.mi_app"      // <-- debe coincidir con tu paquete real
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName         // KTS: string (usa el de Flutter)
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.24")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    // ... tus demás dependencias
}

flutter {
    source = "../.."
}
