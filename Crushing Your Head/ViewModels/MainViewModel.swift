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

    private var crushedHeads = Set<UUID>()

    private let cameraManager = CameraManager.shared
    private let frameManager = FrameManager.shared

    private var subscriptions = Set<AnyCancellable>()

    init() {
        setupSubscriptions()
    }

    private func setupSubscriptions() {
        setupErrorHandling()

        let currFrame = frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .share()

        currFrame
            .compactMap { buffer in
                CGImage.create(from: buffer)
            }
            .assign(to: &$frame)

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

        currFrame
            .sample(every: 2)
            .compactMap { buffer in
                do {
                    return try FaceDetector.shared.process(image: buffer)
                } catch {
                    self.error = error
                    return nil
                }
            }
            .assign(to: &$heads)

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
