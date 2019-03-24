package com.botafi.narai

import android.graphics.Point

operator fun Point.minus(point: Point): Point = Point(x - point.x, y - point.y)
operator fun Point.plus(point: Point): Point = Point(x + point.x, y + point.y)

operator fun Point.div(num: Int): Point = Point(x / num, y / num)