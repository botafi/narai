package com.botafi.narai

import com.google.gson.annotations.Expose
import com.google.gson.annotations.SerializedName
import com.google.zxing.Result
import java.io.Serializable

open class QR (
    open val value: String,
    @SerializedName("pointSuper")
    @Expose(serialize = false, deserialize = false)
    open val points: Array<Point>
): Serializable {
  constructor(): this("", emptyArray())
  companion object {
    const val TOP_LEFT = 1
    const val TOP_RIGHT = 2
    const val BOTTOM_LEFT = 0
    const val BOTTOM_RIGHT = 3
    fun fromZxingResult(result: Result): QR {
      val points: MutableList<Point> = result.resultPoints.take(3).map { resultPoint ->  resultPoint.toPoint() }.toMutableList()
      points.add(BOTTOM_RIGHT, result.calculateBottomRightResultPoint().toPoint())
      return QR(result.text, points.toTypedArray())
    }
  }
  //val centerPoint get() = Point(points.sumBy { point ->  point.x } / 4, points.sumBy { point ->  point.y } / 4)
  val centerPoint get() = Point( (topLeftPoint.x + bottomRightPoint.x) / 2, (topLeftPoint.y + bottomRightPoint.y) / 2)
  val topLeftPoint get() = points[TOP_LEFT]
  val topRightPoint get() = points[TOP_RIGHT]
  val bottomLeftPoint get() = points[BOTTOM_LEFT]
  val bottomRightPoint get() = points[BOTTOM_RIGHT]
  val height get(): Int = (Math.abs(topLeftPoint.y - bottomLeftPoint.y) + Math.abs(topRightPoint.y - bottomRightPoint.y)) / 2
  val id get(): String = value.split(';')[0]
  val type get(): String {
    val ar = value.split(';')
    return if(ar.count() == 1) ar[0] else ar[1]
  }
  override fun equals(other: Any?): Boolean {
    if (this === other) return true
    if (javaClass != other?.javaClass) return false
    other as QR
    return value == other.value
  }
  override fun hashCode(): Int {
    return value.hashCode()
  }
  override fun toString(): String {
    return value;
  }
  fun distanceTo(other: QR): Double {
    return Math.sqrt(Math.pow(centerPoint.x.toDouble() - other.centerPoint.x.toDouble(), 2.0) + Math.pow(centerPoint.y.toDouble() - other.centerPoint.y.toDouble(), 2.0))
  }

  fun distanceToX(other: QR): Int {
    return Math.abs(centerPoint.x - other.centerPoint.x)
  }

  fun distanceToY(other: QR): Int {
    return Math.abs(centerPoint.y - other.centerPoint.y)
  }

  fun overlapping(other: QR, threshold: Float = 0.9f): Boolean {
    return distanceTo(other) < threshold * height;
  }
}