package com.botafi.narai

interface IQRProcessor {
  val qrs: Array<DetectedQR>
  val minQRHeight: Float
  var avgQRHeight: Float
  var numOfLines: Int?
  var roundByY: Float
  fun detect(qrs: Collection<QR>, graphicOverlay: GraphicOverlay?)
  fun process(qrs: Collection<QR>)
  fun draw(graphicOverlay: GraphicOverlay?)
  fun reset()
}