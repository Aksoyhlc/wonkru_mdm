import java.util.Properties
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.devtools.ksp")
    id("dev.flutter.flutter-gradle-plugin")
}

val keyProperties = Properties()
val keyPropertiesFile = rootProject.file("key.properties")
val hasKeyProperties = keyPropertiesFile.exists()

if (hasKeyProperties) {
    keyPropertiesFile.inputStream().use { keyProperties.load(it) }
}

if (System.getenv("WONKRU_REQUIRE_RELEASE_SIGNING") == "true") {
    require(listOf("keyAlias", "keyPassword", "storeFile", "storePassword").all {
        !keyProperties.getProperty(it).isNullOrBlank()
    }) {
        "Configure release signing in android/key.properties."
    }
}

android {
    namespace = "com.wonkrumdm"
    compileSdk = flutter.compileSdkVersion
    buildFeatures {
        buildConfig = true
    }
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    signingConfigs {
        create("release") {
            if (hasKeyProperties) {
                keyAlias = keyProperties["keyAlias"]?.toString()
                keyPassword = keyProperties["keyPassword"]?.toString()
                storeFile = keyProperties["storeFile"]
                    ?.toString()
                    ?.takeIf { it.isNotBlank() }
                    ?.let { file(it) }
                storePassword = keyProperties["storePassword"]?.toString()
            }
        }
    }

    defaultConfig {
// TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.wonkrumdm"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = if (hasKeyProperties) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

dependencies {

    implementation("com.scottyab:rootbeer-lib:0.1.1")

    implementation("androidx.work:work-runtime-ktx:2.11.1")

    implementation("androidx.lifecycle:lifecycle-process:2.10.0")

    implementation("androidx.room:room-runtime:2.8.4")
    implementation("androidx.room:room-ktx:2.8.4")
    ksp("androidx.room:room-compiler:2.8.4")

    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.10.2")
}
