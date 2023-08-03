//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 8/1/23.
//
import NIO
import Hummingbird
import Foundation

public struct RequestContext: HBRequestContext {
    public var eventLoop: EventLoop
    public var allocator: ByteBufferAllocator
    public var remoteAddress: SocketAddress? { return nil}
}

public extension HBRequest {
    init(
        path: String,
        method: HTTPMethod = .GET,
        body: HBRequestBody = .byteBuffer(nil),
        application: HBApplication
    ) {
        self.init(head: .init(version: .http1_1, method: method, uri: path),
             body: body,
             application: application,
             context: RequestContext(
               eventLoop: MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
               allocator: ByteBufferAllocator())
            )
    }
    
}
