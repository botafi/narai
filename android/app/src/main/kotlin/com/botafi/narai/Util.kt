package com.botafi.narai

import kotlin.experimental.and

object Util {
  fun rotateNV2(yuv: ByteArray,
                width: Int,
                height: Int,
                rotation: Int): ByteArray {
    if (rotation == 0) return yuv
    if (rotation % 90 != 0 || rotation < 0 || rotation > 270) {
      throw IllegalArgumentException("0 <= rotation < 360, rotation % 90 == 0")
    }

    val output = ByteArray(yuv.size)
    val frameSize = width * height
    val swap = rotation % 180 != 0
    val xflip = rotation % 270 != 0
    val yflip = rotation >= 180

    for (j in 0 until height) {
      for (i in 0 until width) {
        val yIn = j * width + i
        val uIn = frameSize + (j shr 1) * width + (i and 1.inv())
        val vIn = uIn + 1

        val wOut = if (swap) height else width
        val hOut = if (swap) width else height
        val iSwapped = if (swap) j else i
        val jSwapped = if (swap) i else j
        val iOut = if (xflip) wOut - iSwapped - 1 else iSwapped
        val jOut = if (yflip) hOut - jSwapped - 1 else jSwapped

        val yOut = jOut * wOut + iOut
        val uOut = frameSize + (jOut shr 1) * wOut + (iOut and 1.inv())
        val vOut = uOut + 1

        output[yOut] = 0xff.toByte() and yuv[yIn]
        output[uOut] = 0xff.toByte() and yuv[uIn]
        output[vOut] = 0xff.toByte() and yuv[vIn]
      }
    }
    return output
  }
}
