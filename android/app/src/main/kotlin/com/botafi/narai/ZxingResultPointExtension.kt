package com.botafi.narai

import com.google.zxing.ResultPoint

fun ResultPoint.toGraphicsPoint() = android.graphics.Point(Math.round(x), Math.round(y))
fun ResultPoint.toPoint(): Point = Point(Math.round(x), Math.round(y))