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

    private let cameraManager = CameraManager.shared
    private let frameManager = FrameManager.shared

    private var subscriptions = Set<AnyCancellable>()

    init() {
        setupSubscriptions()
    }

    private func setupSubscriptions() {
        setupErrorHandling()
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
