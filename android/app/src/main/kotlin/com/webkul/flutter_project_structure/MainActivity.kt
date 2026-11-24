package webkul.opencart_flutter.mobikul

import android.app.Activity
import android.content.ContentValues
import android.content.Intent
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import webkul.opencart.mobikul.mlkit.CameraSearchActivity
import java.io.File

import android.content.pm.PackageManager
import android.content.ComponentName
import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import webkul.opencart_flutter.mobikul.launcherAlias.LauncherAliasDefault
import webkul.opencart_flutter.mobikul.launcherAlias.LauncherAliasFive
import webkul.opencart_flutter.mobikul.launcherAlias.LauncherAliasFour
import webkul.opencart_flutter.mobikul.launcherAlias.LauncherAliasOne
import webkul.opencart_flutter.mobikul.launcherAlias.LauncherAliasThree
import webkul.opencart_flutter.mobikul.launcherAlias.LauncherAliasTwo

class MainActivity : FlutterFragmentActivity() {
    private val EVENTS = "com.webkul.oc.methodchannel"
    var methodChannelResult: MethodChannel.Result? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        WindowCompat.setDecorFitsSystemWindows(getWindow(), false)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
        }

        super.onCreate(savedInstanceState)
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("custom-webview", CustomWebViewFactory(flutterEngine.dartExecutor.binaryMessenger))


        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENTS
        ).setMethodCallHandler { call, result ->
            methodChannelResult = result;
            if (call.method.equals("fileviewer")) {
                val reference = call.arguments<String>()
                if (reference.isNullOrBlank()) {
                    result.error("INVALID_FILE", "Missing PDF file reference", null)
                } else {
                    openPdf(reference, result)
                }
            } else if (call.method == "publishPdfToDownloads") {
                val sourcePath = call.argument<String>("sourcePath")
                val fileName = call.argument<String>("fileName")
                if (sourcePath.isNullOrBlank() || fileName.isNullOrBlank()) {
                    result.error("INVALID_ARGUMENTS", "Missing sourcePath or fileName", null)
                } else {
                    publishPdfToDownloads(sourcePath, fileName, result)
                }
            } else if (call.method == "getExistingDownloadFileNames") {
                result.success(existingDownloadFileNames())
            } else if (call.method == "initialLink") {
                val initialUrl = initialLink()
                if (initialUrl != null) {
                    result.success(initialLink())
                } else {
                    result.error("UNAVAILABLE", "No deep link found", null)
                }
            } else if (call.method == "imageSearch") {
                startImageFinding()
            } else if (call.method == "textSearch") {
                startTextFinding()
            } else if (call.method == "dynamicLauncher") {
                val path: String? = call.arguments()
                checkLauncherType(path)
                result.success("Success")
            }
        }
    }

    private fun publishPdfToDownloads(
        sourcePath: String,
        fileName: String,
        result: MethodChannel.Result
    ) {
        val source = File(sourcePath)
        if (!source.exists()) {
            result.error("SOURCE_NOT_FOUND", "Downloaded PDF was not found", null)
            return
        }

        try {
            val savedUri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val collection = MediaStore.Downloads.EXTERNAL_CONTENT_URI
                val values = ContentValues().apply {
                    put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                    put(MediaStore.Downloads.MIME_TYPE, "application/pdf")
                    put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                    put(MediaStore.Downloads.IS_PENDING, 1)
                }
                var uri: android.net.Uri? = null
                try {
                    uri = contentResolver.insert(collection, values)
                } catch (e: Exception) {
                    // If it fails (e.g. "Failed to build unique file" due to orphaned disk file), 
                    // append a timestamp and try again.
                    val timestamp = System.currentTimeMillis()
                    val fallbackName = fileName.replace(".pdf", "_$timestamp.pdf")
                    values.put(MediaStore.Downloads.DISPLAY_NAME, fallbackName)
                    uri = contentResolver.insert(collection, values)
                }
                
                if (uri == null) {
                    throw IllegalStateException("Unable to create Downloads entry")
                }
                try {
                    contentResolver.openOutputStream(uri)?.use { output ->
                        source.inputStream().use { input -> input.copyTo(output) }
                    } ?: throw IllegalStateException("Unable to open Downloads output stream")
                    values.clear()
                    values.put(MediaStore.Downloads.IS_PENDING, 0)
                    contentResolver.update(uri, values, null, null)
                    uri
                } catch (error: Exception) {
                    contentResolver.delete(uri, null, null)
                    throw error
                }
            } else {
                val downloads = Environment.getExternalStoragePublicDirectory(
                    Environment.DIRECTORY_DOWNLOADS
                )
                if (!downloads.exists() && !downloads.mkdirs()) {
                    throw IllegalStateException("Unable to create Downloads directory")
                }
                val destination = File(downloads, fileName)
                source.copyTo(destination, overwrite = false)
                MediaScannerConnection.scanFile(
                    this,
                    arrayOf(destination.absolutePath),
                    arrayOf("application/pdf"),
                    null
                )
                FileProvider.getUriForFile(this, applicationContext.packageName, destination)
            }

            source.delete()
            result.success(savedUri.toString())
        } catch (error: Exception) {
            result.error("PUBLISH_FAILED", error.message, null)
        }
    }

    private fun existingDownloadFileNames(): List<String> {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val names = mutableListOf<String>()
            contentResolver.query(
                MediaStore.Downloads.EXTERNAL_CONTENT_URI,
                arrayOf(MediaStore.Downloads.DISPLAY_NAME),
                "${MediaStore.Downloads.DISPLAY_NAME} LIKE ?",
                arrayOf("Dina_International_Catalogue%.pdf"),
                null
            )?.use { cursor ->
                val nameColumn = cursor.getColumnIndexOrThrow(
                    MediaStore.Downloads.DISPLAY_NAME
                )
                while (cursor.moveToNext()) {
                    names.add(cursor.getString(nameColumn))
                }
            }
            names
        } else {
            val downloads = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOWNLOADS
            )
            downloads.listFiles()
                ?.filter { file ->
                    file.isFile &&
                        file.name.startsWith("Dina_International_Catalogue") &&
                        file.name.endsWith(".pdf")
                }
                ?.map { it.name }
                ?: emptyList()
        }
    }

    private fun openPdf(reference: String, result: MethodChannel.Result) {
        try {
            val uri = if (reference.startsWith("content://")) {
                Uri.parse(reference)
            } else {
                val file = File(reference)
                if (!file.exists()) {
                    result.error("FILE_NOT_FOUND", "Downloaded PDF was not found", null)
                    return
                }
                FileProvider.getUriForFile(this, applicationContext.packageName, file)
            }
            val intent = Intent(Intent.ACTION_VIEW).apply {
                setDataAndType(uri, "application/pdf")
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
            }
            if (intent.resolveActivity(packageManager) == null) {
                result.error("NO_PDF_VIEWER", "No application can open PDF files", null)
                return
            }
            startActivity(intent)
            result.success(true)
        } catch (error: Exception) {
            result.error("OPEN_FAILED", error.message, null)
        }
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 101 && resultCode == Activity.RESULT_OK) {
            methodChannelResult?.success(data?.getStringExtra(CameraSearchActivity.CAMERA_SEARCH_HELPER))
        }
    }

    fun initialLink(): String? {
        val uri = intent.data
        Log.d("adasdasda", uri.toString())
        return if (uri != null) {
            // Skip excluded routes on cold start – open in browser instead
            if (isExcludedDeepLink(uri)) {
                Log.d("MainActivity", "Excluded initial deep link – opening in browser")
                openInBrowser(uri)
                null
            } else {
                uri.toString()
            }
        } else {
            null
        }
    }

    private fun startImageFinding() {
        val intent = Intent(this, CameraSearchActivity::class.java)
        intent.putExtra(
            CameraSearchActivity.CAMERA_SELECTED_MODEL,
            CameraSearchActivity.IMAGE_LABELING
        )
        startActivityForResult(intent, 101)
    }

    private fun startTextFinding() {
        val intent = Intent(this, CameraSearchActivity::class.java)
        intent.putExtra(
            CameraSearchActivity.CAMERA_SELECTED_MODEL,
            CameraSearchActivity.TEXT_RECOGNITION
        )
        startActivityForResult(intent, 101)
    }

    private fun checkLauncherType(launcherType: String?) {
        if (launcherType.equals("1")) {
            AppSharedPref.setLauncherIcon(this, "launcherAlias.LauncherAliasOne")
            AppSharedPref.setCount(this, 1)
        } else if (launcherType.equals("2")) {
            AppSharedPref.setLauncherIcon(this, "launcherAlias.LauncherAliasTwo")
            AppSharedPref.setCount(this, 2)
        } else if (launcherType.equals("3")) {
            AppSharedPref.setLauncherIcon(this, "launcherAlias.LauncherAliasThree")
            AppSharedPref.setCount(this, 3)
        } else {
            AppSharedPref.setLauncherIcon(this, "launcherAlias.LauncherAliasDefault")
            AppSharedPref.setCount(this, 0)
        }
    }


    private fun setIcon(targetIcon: String) {
        try {
            when(targetIcon){
                "0"->{
                    // default block
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasDefault::class.java), PackageManager.COMPONENT_ENABLED_STATE_ENABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasTwo::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasTwo::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasThree::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFour::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFive::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)

                }
                "1"->{
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasOne::class.java), PackageManager.COMPONENT_ENABLED_STATE_ENABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasTwo::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasThree::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasDefault::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFour::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFive::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)

                }
                "2"->{
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasTwo::class.java), PackageManager.COMPONENT_ENABLED_STATE_ENABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasOne::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasThree::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasDefault::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFour::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFive::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)

                }
                "3"->{
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasThree::class.java), PackageManager.COMPONENT_ENABLED_STATE_ENABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasOne::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasTwo::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasDefault::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFour::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFive::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)

                }
                "4"->{
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasOne::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasTwo::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasThree::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasDefault::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFour::class.java), PackageManager.COMPONENT_ENABLED_STATE_ENABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFive::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)

                }
                "5"->{
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasOne::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasTwo::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasThree::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasDefault::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFour::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFive::class.java), PackageManager.COMPONENT_ENABLED_STATE_ENABLED,PackageManager.DONT_KILL_APP)

                }

            }
        } catch (e: Exception) {
            Log.e("Error setComponentName", e.message.toString())
        }
    }

    override fun onPause() {
        super.onPause()
        if (AppSharedPref.getCount(this) != AppSharedPref.getSavedCount(this)) {
            AppSharedPref.setSavedCount(this, AppSharedPref.getCount(this))
            Log.d("onPause test ", "Launcher screeen here")
            setIcon(AppSharedPref.getCount(this).toString())
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (AppSharedPref.getCount(this) != AppSharedPref.getSavedCount(this)) {
            AppSharedPref.setSavedCount(this, AppSharedPref.getCount(this))
            Log.d("onDestroy test ", "Launcher screeen here")
            setIcon(AppSharedPref.getCount(this).toString())
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleDeepLink(intent)
    }

    // Routes that should NOT be handled in-app – opened in the browser instead.
    private val excludedRoutes = listOf(
        "extension/module/email_verification",
        "account/forgotten",
        "account/reset"

    )

    // Check if a URI's "route" query parameter matches an excluded route.
    private fun isExcludedDeepLink(uri: Uri): Boolean {
        val route = uri.getQueryParameter("route") ?: return false
        return excludedRoutes.any { route.startsWith(it) }
    }

    // Open a URL in the external browser (not in our app).
    // Resolves the default browser package to prevent Android from
    // routing the URL back to our app via verified App Links.
    private fun openInBrowser(uri: Uri) {
        val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse("http://www.example.com"))
        val resolveInfo = packageManager.resolveActivity(browserIntent, PackageManager.MATCH_DEFAULT_ONLY)

        val intent = Intent(Intent.ACTION_VIEW, uri)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        // Set the browser package so the URL opens in Chrome/Firefox/etc, not our app
        resolveInfo?.activityInfo?.packageName?.let { browserPackage ->
            intent.setPackage(browserPackage)
        }

        try {
            startActivity(intent)
        } catch (e: Exception) {
            Log.e("MainActivity", "Failed to open in browser: ${e.message}")
        }
    }

    private fun handleDeepLink(intent: Intent) {
        val uri = intent.data
        if (uri != null) {
            val deepLink = uri.toString()
            Log.d("MainActivity", "Deep Link received: $deepLink")

            // Skip excluded routes – open them in the browser instead
            if (isExcludedDeepLink(uri)) {
                Log.d("MainActivity", "Excluded deep link route – opening in browser")
                openInBrowser(uri)
                return
            }

            MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger!!, EVENTS).invokeMethod("handleDeepLink", deepLink)
        }
    }
}
