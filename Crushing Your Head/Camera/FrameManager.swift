//
//  FrameManager.swift
//  FrameManager
//
//  Created by Yonatan Mittlefehldt on 2021-21-07.
//

import AVFoundation

class FrameManager: NSObject, ObservableObject {
    static let shared = FrameManager()

    @Published var error: FrameError?
    @Published var current: CVPixelBuffer?

    let videoOutputQueue = DispatchQueue(label: "app.CrushingYourHead.VideoOutputQ",
                                         qos: .userInitiated,
                                         attributes: [],
                                         autoreleaseFrequency: .workItem)

    private override init() {
        super.init()

        CameraManager.shared.set(self, queue: videoOutputQueue)
    }

    /// Sets the published error on the main thread as required by `@Published` properties
    /// - Parameter error: a error in the frame manager
    private func set(error: FrameError?) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate methods

extension FrameManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        if sampleBuffer.numSamples == 0 {
            set(error: .tooFewSamples)
            return
        } else if sampleBuffer.numSamples > 1 {
            set(error: .tooManySamples)
            return
        }

        if let buffer = sampleBuffer.imageBuffer {
            DispatchQueue.main.async {
                self.current = buffer
            }
        }
    }
}
