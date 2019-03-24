package com.botafi.narai

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import com.botafi.narai.GraphicOverlay.Graphic

class QRGraphic internal constructor(overlay: GraphicOverlay, private val qr: DetectedQR) : Graphic(overlay) {
  private val rectPaint: Paint
  private val qrPaint: Paint
  private val pointPaint: Paint
  private val textPaint: Paint
  init {
    rectPaint = Paint()
    rectPaint.color = Color.WHITE
    rectPaint.style = Paint.Style.STROKE
    rectPaint.strokeWidth = 4.0f

    qrPaint = Paint()
    qrPaint.color = Color.WHITE
    qrPaint.textSize = 35.0f

    pointPaint = Paint()
    pointPaint.strokeCap = Paint.Cap.ROUND
    pointPaint.strokeWidth = 20.0f
    pointPaint.isAntiAlias = true

    textPaint = Paint()
    textPaint.color = Color.BLACK
    textPaint.textSize = 32.0f

    // Redraw the overlay, as this graphic has been added.
    postInvalidate()
  }
  override fun draw(canvas: Canvas) {
      val path = Path()
      path.setLastPoint(translateX(qr.topLeftPoint.x.toFloat()), translateY(qr.topLeftPoint.y.toFloat()))
      path.lineTo(translateX(qr.topRightPoint.x.toFloat()), translateY(qr.topRightPoint.y.toFloat()))
      path.lineTo(translateX(qr.bottomRightPoint.x.toFloat()), translateY(qr.bottomRightPoint.y.toFloat()))
      path.lineTo(translateX(qr.bottomLeftPoint.x.toFloat()), translateY(qr.bottomLeftPoint.y.toFloat()))
      path.lineTo(translateX(qr.topLeftPoint.x.toFloat()), translateY(qr.topLeftPoint.y.toFloat()))
      canvas.drawPath(path, rectPaint)

      pointPaint.color = Color.RED
      canvas.drawPoint(translateX(qr.bottomLeftPoint.x.toFloat()), translateY(qr.bottomLeftPoint.y.toFloat()), pointPaint)

      pointPaint.color = Color.GREEN
      canvas.drawPoint(translateX(qr.topLeftPoint.x.toFloat()), translateY(qr.topLeftPoint.y.toFloat()), pointPaint)

      pointPaint.color = Color.BLUE
      canvas.drawPoint(translateX(qr.topRightPoint.x.toFloat()), translateY(qr.topRightPoint.y.toFloat()), pointPaint)

      pointPaint.color = Color.CYAN
      canvas.drawPoint(translateX(qr.bottomRightPoint.x.toFloat()), translateY(qr.bottomRightPoint.y.toFloat()), pointPaint)

      pointPaint.color = Color.YELLOW
      canvas.drawPoint(translateX(qr.centerPoint.x.toFloat()), translateY(qr.centerPoint.y.toFloat()), pointPaint)
      canvas.drawText(qr.line.toString()+", "+qr.linePosition.toString(), translateX(qr.topLeftPoint.x.toFloat()), translateY(qr.topLeftPoint.y.toFloat() - qr.height/4), qrPaint)
      canvas.drawText(qr.value.split(';').last(), translateX(qr.bottomLeftPoint.x.toFloat()) - 20, translateY(qr.bottomLeftPoint.y.toFloat()) + 30, qrPaint)

      canvas.drawText(qr.position.toString(), translateX(qr.centerPoint.x.toFloat() - qr.height * 1.25f), translateY(qr.centerPoint.y.toFloat()), qrPaint);
  }
}
