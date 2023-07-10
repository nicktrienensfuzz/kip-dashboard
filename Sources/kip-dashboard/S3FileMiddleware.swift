//
//  S3FileProvider.swift
//  
//
//  Created by Nicholas Trienens on 7/8/23.
//

import Foundation
import Hummingbird
import SotoS3

public class S3FileMiddleware: HBMiddleware {
    
    let s3: S3
    public let bucket: String
    public let folder: String
    var files = [StaticFile]()
    
    internal init(bucket: String,
                  folder: String,
                  s3: S3,
                  files: [StaticFile] = [StaticFile]()) {
        self.bucket = bucket
        self.folder = folder
        self.files = files
        self.s3 = s3
        Task {
            try await fetchFiles()
        }
    }
    
    public func apply(to request: Hummingbird.HBRequest, next: Hummingbird.HBResponder) -> NIOCore.EventLoopFuture<Hummingbird.HBResponse> {
        var headers = HTTPHeaders()
        guard var path = request.uri.path.removingPercentEncoding else {
            return request.failure(.badRequest)
        }
        if path == "/" {
            path = "index.html"
        }
//        Task {
//            try await fetchFiles()
//        }
        return next.respond(to: request)
            .flatMapError { error in
            switch request.method {
            case .GET:
                
                if path.contains(".") {
                let key = (self.folder.withTrailingSlash + path).replacingOccurrences(of: "//", with: "/")
                print("trying: " + key)
                    return self.s3.getObject(.init(bucket: self.bucket, key: key))
                        .map { object -> HBResponse in
                            
                            let filepath = path
                            // content-type
                            if let extPointIndex = filepath.lastIndex(of: ".") {
                                let extIndex = filepath.index(after: extPointIndex)
                                let ext = String(filepath.suffix(from: extIndex))
                                if let contentType = HBMediaType.getMediaType(forExtension: ext) {
                                    headers.add(name: "content-type", value: contentType.description)
                                }
                            }
                            
                            return HBResponse(status: .ok, headers: headers, body: .data(object.body?.asData() ?? Data()))
                        }
                        .flatMapError { error in
                            return self.s3.getObject(.init(bucket: self.bucket, key: self.folder.withTrailingSlash + "index.html"))
                                .map { object in
                                    if let contentType = HBMediaType.getMediaType(forExtension: "html") {
                                        headers.add(name: "content-type", value: contentType.description)
                                    }
                                    return HBResponse(status: .ok, headers: headers, body: .data(object.body?.asData() ?? Data()))
                                }
                        }
                } else {
                    
                    print("Fallback: " + path)

                    return self.s3.getObject(.init(bucket: self.bucket, key: self.folder.withTrailingSlash + "index.html"))
                        .map { object in
                            if let contentType = HBMediaType.getMediaType(forExtension: "html") {
                                headers.add(name: "content-type", value: contentType.description)
                            }
                            return HBResponse(status: .ok, headers: headers, body: .data(object.body?.asData() ?? Data()))
                        }
                }
                
            case .HEAD:
                return request.success(HBResponse(status: .ok, headers: headers, body: .empty))
                
            default:
                return request.failure(error)
            }
        }
    }
    
    func match(_ path: String) -> String? {
        for file in files {
            if file.path.hasSuffix( path) {
                print("returning: \(file.key) ==> \(path)")
                return file.key
            }
        }
        print("failed look up: \(path)")
        return nil
    }
    
    
    func fetchFiles() async throws {
        
        let listResponse = try await s3.listObjects(.init(bucket: bucket, prefix: folder))
        
        files = listResponse.contents?.compactMap { s3File -> StaticFile? in
            do {
                let key = try s3File.key.unwrapped()
                guard key.contains(".") else {
                    return nil
                }
                return StaticFile(path:  key.replacingOccurrences(of: folder, with: "") , key: key)
            } catch {
                return nil
            }
        } ?? []
        print("loaded: \(files.count)")
        print(files)
    }
}

struct StaticFile {
    internal init(path: String, key: String, cachedData: Data? = nil) {
        self.path = path
        self.key = key
        self.cachedData = cachedData
    }
    
    let path: String
    let key: String
    let cachedData: Data?
}

extension String {
    var withTrailingSlash: String {
        if hasSuffix("/") {
            return self
        } else {
            return self + "/"
        }
    }
}
