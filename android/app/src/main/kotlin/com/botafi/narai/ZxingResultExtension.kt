package com.botafi.narai

import com.google.zxing.Result
import com.google.zxing.ResultPoint

private const val TOP_LEFT = 1
private const val TOP_RIGHT = 2
private const val BOTTOM_LEFT = 0

fun Result.calculateBottomRightResultPoint(): ResultPoint = ResultPoint(
    resultPoints[TOP_RIGHT].getX()+resultPoints[BOTTOM_LEFT].getX()-resultPoints[TOP_LEFT].getX(),
    resultPoints[TOP_RIGHT].getY()+resultPoints[BOTTOM_LEFT].getY()-resultPoints[TOP_LEFT].getY()
)