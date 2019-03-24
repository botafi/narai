package com.botafi.narai

import com.google.zxing.Result
import java.io.Serializable

class DetectedQR(
    value: String,
    points: Array<Point>
) : QR(value, points), Serializable {
  constructor(qr: QR): this(qr.value, qr.points)
  constructor(): this("", emptyArray())
  var undetectedFor: Int = 0
  var position: Int? = null
  var linePosition: Int? = null
  var line: Int? = null
  var lastPoints: Array<Point> = points
  var lastDetectedPoints: Array<Point> = points
  var detectedLast: Boolean = true
  override var points = points
    set(value) {
      lastPoints = points
      field = value
    }
  val movement: Array<Point> get() = points.mapIndexed { index, point ->  Point(point - lastPoints[index] ) }.toTypedArray()
  fun detected(points: Array<Point>): DetectedQR {
    lastDetectedPoints = points
    this.points = points
    detectedLast = true
    undetectedFor = 0
    return this
  }
  fun detected(result: Result): DetectedQR {
    val points = result.resultPoints.take(3).map { resultPoint ->  resultPoint.toPoint() }.toMutableList()
    points.add(BOTTOM_RIGHT, result.calculateBottomRightResultPoint().toPoint())
    val pointsArray = points.toTypedArray()
    this.detected(pointsArray)
    return this
  }
  fun undetected(compensations: Array<Point>): DetectedQR {
    undetectedFor++
    detectedLast = false
    points = points.mapIndexed { index, point ->
      val compensation = compensations[index]
      Point(point.x + compensation.x, point.y + compensation.y)
    }.toTypedArray()
    return this
  }
  companion object {
    fun fromZxingResult(result: Result): DetectedQR {
      val points: MutableList<Point> = result.resultPoints.take(3).map { resultPoint ->  resultPoint.toPoint() }.toMutableList()
      points.add(BOTTOM_RIGHT, result.calculateBottomRightResultPoint().toPoint())
      return DetectedQR(result.text, points.toTypedArray())
    }
  }
}