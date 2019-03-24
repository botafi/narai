package com.botafi.narai

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint

class QRProcessorNew : IQRProcessor {
  var detectedQRs: MutableList<DetectedQR> = mutableListOf()
  override val qrs: Array<DetectedQR> get() = detectedQRs.sortedWith(compareBy({ qr -> qr.line }, { qr -> qr.linePosition})).toTypedArray()
  val debugTextPaint = Paint()
  val qrLinePaint = Paint()
  init {
    debugTextPaint.color = Color.YELLOW
    debugTextPaint.textSize = 40f
    qrLinePaint.color = Color.LTGRAY
    qrLinePaint.strokeWidth = 4.5f
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
    val movement: Array<Point> = arrayOf(Point(0, 0), Point(0, 0), Point(0, 0), Point(0, 0))
    val newQrs = qrs.map { qr -> DetectedQR(qr) }
    var newAvgQRHeight = newQrs.map { qr -> qr.height }.sum().toFloat() / newQrs.count()
    if((newQrs.count() < detectedQRs.count() + 3) && ((newQrs.count() < 2) || (Math.abs(avgQRHeight - newAvgQRHeight) < 7.5f))) {
      val newlyDetectedQRs: MutableList<DetectedQR> = mutableListOf()
      newQrs.forEach { nQr ->
        val closest = detectedQRs
            .filter { dQr -> dQr.id == nQr.id && dQr.type == nQr.type && dQr.distanceToY(nQr) <  avgQRHeight * 1.3 && dQr.distanceToX(nQr) <  avgQRHeight * 1.75 }
            .sortedBy { dQr ->  dQr.distanceTo(nQr) }
        if (closest.count() > 0) {
          closest[0].detected(nQr.points)
          newlyDetectedQRs.add(closest[0])
          closest[0].movement.forEachIndexed { index, point ->  movement[index].x += point.x; movement[index].y += point.y }
        } else {
          detectedQRs.add(nQr)
        }
      }
      movement.forEach { point -> point.x /= detectedQRs.count(); point.y /= detectedQRs.count() }
      detectedQRs.filter { dQr -> dQr !in newlyDetectedQRs}.forEach { dQr -> dQr.undetected(movement) }
    } else {
      detectedQRs = newQrs.toMutableList()
    }

    val tbdQrs: MutableList<Int> = mutableListOf()
    detectedQRs.forEachIndexed { index, dQR ->
      if(index in tbdQrs) {
        return;
      }
      val oQRIn = detectedQRs.indexOfFirst { o -> dQR.overlapping(o) }
      if (oQRIn != -1) {
        val oQR = detectedQRs[oQRIn]
        if(dQR.undetectedFor < oQR.undetectedFor) {
          tbdQrs.add(oQRIn)
        } else if (dQR.undetectedFor > oQR.undetectedFor) {
          tbdQrs.add(index)
        }
      }
    }
    tbdQrs.forEach { detectedQRs.removeAt(it) }

    avgQRHeight = detectedQRs.map { qr -> qr.height }.sum().toFloat() / detectedQRs.count()
    roundByY = avgQRHeight * 1.15f
    val sortedQRs = detectedQRs
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
    graphicOverlay!!.add(detectedQRs.map { qr -> QRGraphic(graphicOverlay, qr) })
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
        detectedQRs
            .filter { qr -> qr.linePosition == 1 }
            .forEach { qr ->
//              canvas.drawText(qr.line.toString(), )
//              canvas.drawLine(0f, translateY(qr.centerPoint.y.toFloat() - avgQRHeight), 2000f, translateY(qr.centerPoint.y.toFloat() - avgQRHeight), qrLinePaint)
              canvas.drawLine(0f, translateY(qr.centerPoint.y.toFloat() + avgQRHeight), 2000f, translateY(qr.centerPoint.y.toFloat() + avgQRHeight), qrLinePaint)
            }
      }
    })
  }
  override fun reset() {
    detectedQRs = mutableListOf()
  }
  companion object {
    private const val TAG = "QRProcessor"
  }
}