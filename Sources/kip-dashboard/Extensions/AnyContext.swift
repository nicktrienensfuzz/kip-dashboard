//
//  AnyContext.swift
//
//
//  Created by Nicholas Trienens on 6/19/23.
//

import Foundation
import Logging
import NIO

public protocol AnyContext {
    var logger: Logger { get }
    var eventLoop: EventLoop { get }
}

struct Context: AnyContext {
    let logger = Logger(label: "hi")
    var eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 2).next()
}
