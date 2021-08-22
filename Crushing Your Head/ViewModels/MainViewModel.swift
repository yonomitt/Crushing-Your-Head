//
//  MainViewModel.swift
//  MainViewModel
//
//  Created by Yonatan Mittlefehldt on 2021-21-07.
//

import Combine
import CoreImage

class MainViewModel: ObservableObject {
    @Published var error: Error?
    @Published var frame: CGImage?
    @Published var pinch: Pinch?
    @Published var heads = [Head]()
    @Published var score = 0

    /// Keeps track of the UUIDs of heads that have been crushed
    private var crushedHeads = Set<UUID>()

    private let cameraManager = CameraManager.shared
    private let frameManager = FrameManager.shared

    /// Single storage property for `Combine` subscriptions
    private var subscriptions = Set<AnyCancellable>()

    init() {
        setupSubscriptions()
    }

    /// Sets up all `Combine` subscriptions in one convenient place
    private func setupSubscriptions() {
        setupErrorHandling()

        // represents the most recent camera frame captured, removing any
        // `nil` values
        let currFrame = frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .share()

        // Creates a `CGImage` from the current frame to be displayed
        currFrame
            .compactMap { buffer in
                CGImage.create(from: buffer)
            }
            .assign(to: &$frame)

        // Runs every other frame through the hand pose detector for performance
        // reasons. Generates a pinch, for every frame with a detected HUMAN hand
        currFrame
            .sample(every: 2)
            .compactMap { buffer in
                do {
                    return try HandPoseDetector.shared.process(image: buffer)
                } catch {
                    self.error = error
                    return nil
                }
            }
            .assign(to: &$pinch)

        // Runs every other frame through the face detector/tracker for performance
        // reasons. Creates a head for each detected head
        currFrame
            .sample(every: 2)
            .compactMap { buffer in
                do {
                    let objects = try FaceDetector.shared.process(image: buffer)
                    return objects.map { Head(detectedObject: $0, crushed: self.crushedHeads.contains($0.id)) }
                } catch {
                    self.error = error
                    return nil
                }
            }
            .assign(to: &$heads)

        // The main pinch logic in the app. To determine a pinch, it looks to see if the previous
        // pinch was open and the current one is closed. Then it compares against the location
        // of any uncrushed heads to determine if a successful head crushing occured
        $pinch
            .nwise(2)
            .zip($heads)
            .sink { pinches, heads in
                guard let first = pinches[0],
                      let second = pinches[1],
                      first.isOpen && second.isClosed else {
                          return
                      }

                let uncrushedHeads = heads.filter { !self.crushedHeads.contains($0.id) }

                for head in uncrushedHeads {
                    if head.bbox.contains(first.center) {
                        self.crushedHeads.insert(head.id)
                        self.score += 100
                        break
                    }
                }
            }
            .store(in: &subscriptions)
    }

    /// Sets up subscriptions for error handling `Combine` pipelines
    private func setupErrorHandling() {
        cameraManager.$error
            .receive(on: RunLoop.main)
            .sink { self.error = $0 }
            .store(in: &subscriptions)

        frameManager.$error
            .receive(on: RunLoop.main)
            .sink { self.error = $0 }
            .store(in: &subscriptions)

        // Reset the error after 10 seconds of no new error
        $error
            .debounce(for: .seconds(10), scheduler: DispatchQueue.main)
            .sink { _ in self.error = nil }
            .store(in: &subscriptions)
    }
}
