package com.botafi.narai

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint

class QRProcessor : IQRProcessor {
  var detectedQRs: MutableMap<String, DetectedQR> = mutableMapOf()
  override val qrs: Array<DetectedQR> get() = detectedQRs.values.sortedWith(compareBy({ qr -> qr.line }, { qr -> qr.linePosition})).toTypedArray()
  val debugTextPaint = Paint()
  val qrLinePaint = Paint()
  init {
    debugTextPaint.color = Color.YELLOW
    debugTextPaint.textSize = 40f
    qrLinePaint.color = Color.MAGENTA
    qrLinePaint.strokeWidth = 5f
  }
  override fun detect(qrs: Collection<QR>, graphicOverlay: GraphicOverlay?) {
    process(qrs)
    draw(graphicOverlay)
  }
  override val minQRHeight = 20f
  override var avgQRHeight = 0f
  override var numOfLines: Int? = 0
  override var roundByY = 0f
  override fun process(qrs: Collection<QR>) {
    avgQRHeight = 0f
    val movement: Array<Point> = arrayOf(Point(0, 0), Point(0, 0), Point(0, 0), Point(0, 0))
    val detectedKeys = qrs.map {qr: QR ->
      var detectedQR: DetectedQR;
      if(detectedQRs.containsKey(qr.value)) {
        detectedQR = detectedQRs[qr.value]!!.detected(qr.points)
      } else {
        detectedQR = DetectedQR(qr)
        detectedQRs[qr.value] = detectedQR
      }
      detectedQR.movement.forEachIndexed { index, point ->  movement[index].x += point.x; movement[index].y += point.y }
      avgQRHeight += detectedQR.height
      detectedQR.value
    }
    val detectedKeysCount = detectedKeys.count()
    if(detectedKeysCount != 0) {
      avgQRHeight /= detectedKeysCount
      movement.forEach { point -> point.x /= detectedKeysCount; point.y /= detectedKeysCount }
    }
    avgQRHeight = if(avgQRHeight < minQRHeight) minQRHeight else avgQRHeight;
    detectedQRs
        .filterKeys { key -> !detectedKeys.contains(key) }
        .forEach { _, qr -> qr.undetected(compensations = movement) }

    roundByY = avgQRHeight * 1.15f
//    val roundByX = Math.round(avgQRHeight * 1)
    val sortedQRs = detectedQRs.values
//        .sortedWith(compareBy( { Math.round(it.centerPoint.y / roundByY.toFloat()) * roundByY }, { Math.round(it.centerPoint.x / roundByX.toFloat()) * roundByX } ))
          .sortedWith(compareBy({ Math.round(Math.round(it.centerPoint.y / roundByY) * roundByY) }, { it.centerPoint.x }))
    sortedQRs
        .forEachIndexed { index, detectedQR ->
          detectedQR.position = index + 1
          val lastDetectedQR = sortedQRs.getOrNull(index - 1)
          val line =  if(lastDetectedQR != null && Math.abs(lastDetectedQR.centerPoint.y - detectedQR.centerPoint.y) < avgQRHeight) lastDetectedQR.line
                            else if(lastDetectedQR != null) lastDetectedQR.line!!.plus(1)
                            else 1
          detectedQR.line = line
          numOfLines = line
//          detectedQR.linePosition = if(lastDetectedQR != null && line == lastDetectedQR.line)
//                                    lastDetectedQR.linePosition!!.plus(1) else 1
        }
    sortedQRs
        .groupBy { qr -> qr.line }
        .forEach { _, qrLine ->
          qrLine
              .sortedWith(compareBy { qr -> qr.centerPoint.x })
              .forEachIndexed { index, qr -> qr.linePosition = index +  1}
        }
  }
  override fun draw(graphicOverlay: GraphicOverlay?) {
    graphicOverlay!!.add(detectedQRs.values.map { qr -> QRGraphic(graphicOverlay, qr) })
    graphicOverlay!!.add(object : GraphicOverlay.Graphic(graphicOverlay) {
      override fun draw(canvas: Canvas) {
        canvas.drawText("QR count = " + detectedQRs.count().toString(), 5f, 40f, debugTextPaint)
        canvas.drawText("line count = " + numOfLines.toString(), 5f, 90f, debugTextPaint)
        canvas.drawText("average QR Height = " + avgQRHeight.toString() + " (min " + minQRHeight + ")", 5f, 140f, debugTextPaint)
        canvas.drawText("roundByY = " + roundByY.toString(), 5f, 190f, debugTextPaint)
      }
    })
    graphicOverlay!!.add(object : GraphicOverlay.Graphic(graphicOverlay) {
      override fun draw(canvas: Canvas) {
        detectedQRs.values
            .filter { qr -> qr.linePosition == 1 }
            .forEach { qr ->
//              canvas.drawText(qr.line.toString(), )
              canvas.drawLine(0f, translateY(qr.centerPoint.y.toFloat() - avgQRHeight), 2000f, translateY(qr.centerPoint.y.toFloat() - avgQRHeight), qrLinePaint)
              canvas.drawLine(0f, translateY(qr.centerPoint.y.toFloat() + avgQRHeight), 2000f, translateY(qr.centerPoint.y.toFloat() + avgQRHeight), qrLinePaint)
            }
      }
    })
  }
  override fun reset() {
    detectedQRs = mutableMapOf()
  }
  companion object {
    private const val TAG = "QRProcessor"
  }
}