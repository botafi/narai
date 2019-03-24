package com.botafi.narai

import android.content.Context
import android.content.pm.PackageManager
import android.os.Bundle
import android.support.v4.app.ActivityCompat
import android.support.v4.app.ActivityCompat.OnRequestPermissionsResultCallback
import android.support.v4.content.ContextCompat
import android.support.v7.app.AppCompatActivity
import android.util.Log
import android.widget.ToggleButton
import com.google.android.gms.common.annotation.KeepName
import kotlinx.android.synthetic.main.activity_scanner.*
import org.jetbrains.anko.sdk25.coroutines.onCheckedChange
import java.io.IOException
import java.util.ArrayList
import android.app.Activity
import android.content.Intent

@KeepName
class ScannerActivity : AppCompatActivity(), OnRequestPermissionsResultCallback {

  private var cameraSource: CameraSource? = null
  private var cameraSourcePreview: CameraSourcePreview? = null
  private var graphicOverlay: GraphicOverlay? = null
  private var qrProcessor: IQRProcessor = QRProcessorNew();

  private val requiredPermissions: Array<String>
    get() {
      try {
        val info = this.packageManager
            .getPackageInfo(this.packageName, PackageManager.GET_PERMISSIONS)
        val ps = info.requestedPermissions
        return if (ps != null && ps.size > 0) {
          ps
        } else {
          emptyArray()
        }
      } catch (e: Exception) {
        return emptyArray()
      }

    }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    Log.d(TAG, "onCreate")
    setContentView(R.layout.activity_scanner)
    cameraSourcePreview = preview as CameraSourcePreview
    if (preview == null) {
      Log.d(TAG, "Preview is null")
    }
    graphicOverlay = overlay as GraphicOverlay
    if (graphicOverlay == null) {
      Log.d(TAG, "graphicOverlay is null")
    }

    val facingSwitch = facingswitch as ToggleButton
    facingSwitch.onCheckedChange { buttonView, isChecked ->
      Log.d(TAG, "Set facing")
      if (cameraSource != null) {
        if (isChecked) {
          cameraSource!!.setFacing(CameraSource.CAMERA_FACING_FRONT)
        } else {
          cameraSource!!.setFacing(CameraSource.CAMERA_FACING_BACK)
        }
      }
      preview!!.stop()
      startCameraSource()
    }
    captureButton.setOnClickListener {
      val qrs = qrProcessor.qrs
      Log.w(TAG, qrs.toString())
      Log.w(TAG, qrs.count().toString())
      Log.w(TAG, qrs[0].toString())
      preview!!.stop()
      cameraSource!!.release()
      val returnIntent = Intent()
      returnIntent.putExtra("qrs", qrs)
      setResult(Activity.RESULT_OK, returnIntent)
      finish()
    }
    clearButton.setOnClickListener {
      qrProcessor.reset()
    }
    detectorSwitch.onCheckedChange { buttonView, isChecked ->
      if(isChecked && !(qrProcessor is QRProcessor)) {
        qrProcessor = QRProcessor()
      } else if(!isChecked && !(qrProcessor is QRProcessorNew)) {
        qrProcessor = QRProcessorNew()
      }
      cameraSource!!.setMachineLearningFrameProcessor(VisionProcessor(qrProcessor))
    }
    if (allPermissionsGranted()) {
      createCameraSource()
    } else {
      getRuntimePermissions()
    }
  }

  private fun createCameraSource() {
    if (cameraSource == null) {
      cameraSource = CameraSource(this, graphicOverlay)
    }
    cameraSource!!.setMachineLearningFrameProcessor(VisionProcessor(qrProcessor))
  }

  /**
   * Starts or restarts the camera source, if it exists. If the camera source doesn't exist yet
   * (e.g., because onResume was called before the camera source was created), this will be called
   * again when the camera source is created.
   */
  private fun startCameraSource() {
    if (cameraSource != null) {
      try {
        if (preview == null) {
          Log.d(TAG, "resume: Preview is null")
        }
        if (graphicOverlay == null) {
          Log.d(TAG, "resume: graphOverlay is null")
        }
        preview!!.start(cameraSource!!, graphicOverlay!!)
      } catch (e: IOException) {
        Log.e(TAG, "Unable to start camera source.", e)
        cameraSource!!.release()
        cameraSource = null
      }
    }
  }

  public override fun onResume() {
    super.onResume()
    Log.d(TAG, "onResume")
    startCameraSource()
  }

  /** Stops the camera.  */
  override fun onPause() {
    super.onPause()
    preview!!.stop()
  }

  public override fun onDestroy() {
    super.onDestroy()
    if (cameraSource != null) {
      cameraSource!!.release()
    }
  }

  private fun allPermissionsGranted(): Boolean {
    for (permission in requiredPermissions) {
      if (!isPermissionGranted(this, permission)) {
        return false
      }
    }
    return true
  }

  private fun getRuntimePermissions() {
    val allNeededPermissions = ArrayList<String>()
    for (permission in requiredPermissions) {
      if (!isPermissionGranted(this, permission)) {
        allNeededPermissions.add(permission)
      }
    }

    if (!allNeededPermissions.isEmpty()) {
      ActivityCompat.requestPermissions(
          this, allNeededPermissions.toTypedArray(), PERMISSION_REQUESTS)
    }
  }

  override fun onRequestPermissionsResult(
      requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
    Log.i(TAG, "Permission granted!")
    if (allPermissionsGranted()) {
      createCameraSource()
    }
    super.onRequestPermissionsResult(requestCode, permissions, grantResults)
  }

  companion object {
    private const val TAG = "ScannerActivity"
    private const val PERMISSION_REQUESTS = 1

    private fun isPermissionGranted(context: Context, permission: String): Boolean {
      if (ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED) {
        Log.i(TAG, "Permission granted: $permission")
        return true
      }
      Log.i(TAG, "Permission NOT granted: $permission")
      return false
    }
  }
}
