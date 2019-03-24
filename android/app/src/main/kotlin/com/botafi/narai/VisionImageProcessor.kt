package com.botafi.narai

import android.graphics.Bitmap
import android.media.Image

import java.nio.ByteBuffer

interface VisionImageProcessor {

  fun process(data: ByteBuffer?, frameMetadata: FrameMetadata?, graphicOverlay: GraphicOverlay?)

  fun process(bitmap: Bitmap?, graphicOverlay: GraphicOverlay?)

  fun process(bitmap: Image?, rotation: Int, graphicOverlay: GraphicOverlay?)

  fun stop()
}
