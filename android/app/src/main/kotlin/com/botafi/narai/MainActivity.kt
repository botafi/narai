package com.botafi.narai

import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.google.gson.Gson
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

enum class Requests {
    SCAN,
//  REQUEST_IMAGE_CAPTURE,
//  REQUEST_CAMERA_PERMISSION
}

class MainActivity(): FlutterActivity() {
//  private var tempCaptureFile: File? = null
//  private val CAPTURE_FILENAME = "capture.jpg"
  private val CHANNEL = "app/main"
  private var flutterChannelResult: MethodChannel.Result? = null
  private var flutterChannel: MethodChannel? = null
//  private val options = FirebaseVisionBarcodeDetectorOptions.Builder()
//    .setBarcodeFormats(FirebaseVisionBarcode.FORMAT_QR_CODE)
//    .build()
  override fun onCreate(savedInstanceState: Bundle?) {
//    FirebaseApp.initializeApp(applicationContext)
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    flutterChannel = MethodChannel(flutterView, CHANNEL, JSONMethodCodec.INSTANCE)
    flutterChannel!!.setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
      flutterChannelResult = result
      when (call.method) {
        "capture" -> {
          //this.dispatchTakePictureIntent()
          runScannerActivity()
        }
        else -> result.notImplemented()
      }
    }
  }
  private fun runScannerActivity() {
    val intent = Intent(this, ScannerActivity::class.java).apply {
    }
    startActivityForResult(intent, Requests.SCAN.ordinal)
  }
  override fun onNewIntent (intent: Intent) {

  }
  override fun onResume() {
    super.onResume()
  }
  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    when(requestCode) {
      Requests.SCAN.ordinal -> {
        // Log.e(TAG,((data?.getSerializableExtra("qrs")) as Array<DetectedQR>)?.get(0)?.points?.get(0)?.x?.toString())
        flutterChannelResult!!.success(Gson().toJson(data?.getSerializableExtra("qrs")))
      }
    }
  }
//  private fun dispatchTakePictureIntent() {
//    val builder = StrictMode.VmPolicy.Builder()
//    StrictMode.setVmPolicy(builder.build())
//    val hasCameraPermission = checkSelfPermission(Manifest.permission.CAMERA)
//    if (hasCameraPermission != PackageManager.PERMISSION_GRANTED) {
//      requestPermissions(arrayOf(Manifest.permission.CAMERA), Requests.REQUEST_CAMERA_PERMISSION.ordinal)
//    }
//    val takePictureIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
//    if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
//      takePictureIntent.addFlags(FLAG_GRANT_READ_URI_PERMISSION);
//      takePictureIntent.addFlags(FLAG_GRANT_WRITE_URI_PERMISSION);
//      //tempCaptureFile = File(Environment.getExternalStorageDirectory(), CAPTURE_FILENAME)
//      //tempCaptureFile = File.createTempFile("capture", ".jpg")
//      tempCaptureFile = File(this.externalCacheDir, CAPTURE_FILENAME)
//      val uri = Uri.fromFile(tempCaptureFile)
//      takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
//      startActivityForResult(takePictureIntent, Requests.REQUEST_IMAGE_CAPTURE.ordinal)
//    }
//  }

//  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//    super.onActivityResult(requestCode, resultCode, data)
//    if (requestCode == Requests.REQUEST_IMAGE_CAPTURE.ordinal && resultCode == RESULT_OK && tempCaptureFile != null) {
//      val image: FirebaseVisionImage
//      try {
//        image = FirebaseVisionImage.fromFilePath(applicationContext, Uri.fromFile(tempCaptureFile))
//        val detector = FirebaseVision
//            .getInstance()
//            .getVisionBarcodeDetector(options)
//        val result = detector.detectInImage(image)
//            .addOnSuccessListener(OnSuccessListener<List<FirebaseVisionBarcode>> {
//                val barcodes = TextUtils.join(",", it.map { i -> i.getRawValue() })
//                Log.i("Vision", barcodes)
//            })
//            .addOnFailureListener(OnFailureListener {
//              Log.e("Vision", it.toString())
//            })
//
//      } catch (e: IOException) {
//        e.printStackTrace()
//      }
//    }
//  }
  companion object {
    const val TAG = "MainActivity"
  }
}
