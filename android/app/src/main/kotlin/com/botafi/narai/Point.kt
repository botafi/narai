package com.botafi.narai

import java.io.Serializable
import java.io.IOException

class Point(x: Int, y: Int) : android.graphics.Point(x, y), Serializable {
  constructor(point: Point): this(point.x, point.y)
  operator fun minus(point: Point): Point = Point(x - point.x, y - point.y)
  operator fun plus(point: Point): Point = Point(x + point.x, y + point.y)
  operator fun div(num: Int): Point = Point(x / num, y / num)
  @Throws(IOException::class)
  private fun writeObject(stream: java.io.ObjectOutputStream) {
    stream.writeInt(x)
    stream.writeInt(y)
  }
  @Throws(IOException::class, ClassNotFoundException::class)
  private fun readObject(stream: java.io.ObjectInputStream) {
    x = stream.readInt()
    y = stream.readInt()
  }
}