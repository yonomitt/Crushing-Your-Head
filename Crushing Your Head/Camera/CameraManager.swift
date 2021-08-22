//
//  CameraManager.swift
//  CameraManager
//
//  Created by Yonatan Mittlefehldt on 2021-21-07.
//

import AVFoundation

class CameraManager: ObservableObject {
    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }

    static let shared = CameraManager()

    @Published var error: CameraError?

    let session = AVCaptureSession()

    private let sessionQueue = DispatchQueue(label: "app.CrushingYourHead.SessionQ")
    private let videoOutput = AVCaptureVideoDataOutput()
    private var status = Status.unconfigured

    private init() {
        configure()
    }

    private func set(error: CameraError?) {
        DispatchQueue.main.async {
            self.error = error
        }
    }

    /// Checks camera permissions and requests them if necessary
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized {
                    self.status = .unauthorized
                    self.set(error: .deniedAuthorization)
                }
                self.sessionQueue.resume()
            }
        case .restricted:
            status = .unauthorized
            set(error: .restrictedAuthorization)
        case .denied:
            status = .unauthorized
            set(error: .deniedAuthorization)
        case .authorized:
            break
        @unknown default:
            status = .unauthorized
            set(error: .unknownAuthorization)
        }
    }

    /// Configures the `AVCaptureSession`
    private func configureCaptureSession() {
        if status == .unauthorized {
            return
        }

        session.beginConfiguration()

        defer {
            session.commitConfiguration()
        }

        let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                             for: .video,
                                             position: .back)
        guard let camera = device else {
            set(error: .cameraUnavailable)
            status = .failed
            return
        }

        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            } else {
                set(error: .cannotAddInput)
                status = .failed
                return
            }
        } catch {
            set(error: .createCaptureInput(error))
            status = .failed
            return
        }

        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)

            videoOutput.videoSettings =
            [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

            let videoConnection = videoOutput.connection(with: .video)
            videoConnection?.videoOrientation = .portrait
        } else {
            set(error: .cannotAddOutput)
            status = .failed
            return
        }

        status = .configured
    }

    func configure() {
        checkPermissions()

        sessionQueue.async {
            self.configureCaptureSession()
            self.session.startRunning()
        }
    }

    /// Sets the delegate that should receive the video sample buffers
    /// - Parameters:
    ///   - delegate: object that will receive camera data
    ///   - queue: the queue, on which the callbacks should be invoked
    func set(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate,
             queue: DispatchQueue) {
        videoOutput.setSampleBufferDelegate(delegate, queue: queue)
    }
}
