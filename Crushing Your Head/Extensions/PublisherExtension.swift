//
//  PublisherExtension.swift
//  PublisherExtension
//
//  Created by Yonatan Mittlefehldt on 2021-27-07.
//

import Combine

extension Publisher {
    /// Creates a Sample publisher, which emits the upstream publisher's every Xth value
    /// - Parameters:
    ///   - count: how often to sample the publisher
    ///   - begin: should the emitted sample be at the beginning or the end of the group
    /// - Returns: a publisher that emits every `count` values
    func sample(every count: Int, startAtZero begin: Bool = true) -> AnyPublisher<Output, Failure> {
        if count <= 0 {
            return filter { _ in false }
                .eraseToAnyPublisher()
        } else if count == 1 {
            return self
                .eraseToAnyPublisher()
        } else {
            return scan((0, nil as Output?)) { args, value in
                (args.0 + 1, value)
            }
            .compactMap { idx, value in
                let mod = begin ? 1 : 0
                guard idx % count == mod else { return nil }
                return value
            }
            .eraseToAnyPublisher()
        }
    }
}
