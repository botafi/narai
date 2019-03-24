package com.botafi.narai

import android.graphics.Bitmap
import android.media.Image
import com.google.zxing.*
import com.google.zxing.common.HybridBinarizer
import com.google.zxing.multi.qrcode.QRCodeMultiReader
import java.nio.ByteBuffer
import java.util.*
import com.botafi.narai.Util.rotateNV2


class VisionProcessor(private val qrProcessor: IQRProcessor) : VisionImageProcessor {
  private val qrCodeMultiReader: QRCodeMultiReader = QRCodeMultiReader()
  private val qrCodeMultiReaderHints: Hashtable<DecodeHintType, Any> = Hashtable()
  init {
    qrCodeMultiReaderHints[DecodeHintType.TRY_HARDER] = true
  }

  override fun process(data: ByteBuffer?, frameMetadata: FrameMetadata?, graphicOverlay: GraphicOverlay?) {
    if (data != null && data.remaining() > 0 && frameMetadata != null) {
        val dataArray = ByteArray(data.remaining())
        data.get(dataArray, 0, dataArray.count())
        data.rewind()
      val width = frameMetadata.height
      val height = frameMetadata.width
        val source = PlanarYUVLuminanceSource(
            rotateNV2(dataArray, frameMetadata.width, frameMetadata.height, 90),
            width,
            height,
            0,
            0,
            width,
            height,
            false
        )
//        val bm= Bitmap.createBitmap(source.renderThumbnail(),source.thumbnailWidth,source.thumbnailHeight, Bitmap.Config.ARGB_4444)
//        graphicOverlay?.clear()
//        graphicOverlay?.add(object: GraphicOverlay.Graphic(graphicOverlay) {
//          override fun draw(canvas: Canvas?) {
//            canvas?.drawBitmap(bm,0f, 0f, Paint())
//          }
//
//        })
        val bBMap = BinaryBitmap(HybridBinarizer(source))
        try {
          gotQRs(qrs = qrCodeMultiReader.decodeMultiple(bBMap, qrCodeMultiReaderHints).map { result -> QR.fromZxingResult(result) }, graphicOverlay = graphicOverlay)
        } catch (e: NotFoundException) {

        }
    }
  }

  override fun process(bitmap: Bitmap?, graphicOverlay: GraphicOverlay?) {
    TODO("not implemented")
  }

  override fun process(bitmap: Image?, rotation: Int, graphicOverlay: GraphicOverlay?) {
    TODO("not implemented")
  }

  override fun stop() {

  }

  private fun gotQRs(qrs: Collection<QR>, graphicOverlay: GraphicOverlay?) {
    graphicOverlay!!.clear()
    qrProcessor.detect(qrs, graphicOverlay)
    //graphicOverlay.add(qrProcessor.detectedQRs.values.map { qr -> QRGraphic(graphicOverlay, qr) })
  }

}