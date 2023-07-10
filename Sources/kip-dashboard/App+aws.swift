//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 7/2/23.
//

import Foundation
import Hummingbird
import SotoS3
import Dependencies
 
extension HBApplication {
    public struct AWS {
        public var client: AWSClient {
            get { self.application.extensions.get(\.aws.client) }
            nonmutating set {
                application.extensions.set(\.aws.client, value: newValue) { client in
                    try client.syncShutdown()
                }
            }
        }

        public var s3: S3 {
            get { self.application.extensions.get(\.aws.s3) }
            nonmutating set { application.extensions.set(\.aws.s3, value: newValue) }
        }

        let application: HBApplication
    }

    public var aws: AWS { return .init(application: self) }
}

extension HBRequest {
    public struct AWS {
        var client: AWSClient { self.application.aws.client }
        var s3: S3 { self.application.aws.s3 }
        let application: HBApplication
    }

    public var aws: AWS { return .init(application: self.application) }
}

extension HBApplication {
    func configureS3() {
        @Dependency(\.configuration) var configuration

        self.aws.client = AWSClient(
                credentialProvider:
                        .static(
                            accessKeyId: configuration.accessKeyId,
                            secretAccessKey: configuration.secretAccessKey
                        ),
                httpClientProvider: .createNewWithEventLoopGroup(self.eventLoopGroup)
            )
        
        self.aws.s3 = S3(client: self.aws.client, region: .uswest2, endpoint: "https://s3.us-west-2.amazonaws.com" )
        
        self.middleware.add(S3FileMiddleware(bucket: "zendat", folder: "kpiDashboard/", s3: self.aws.s3))
        
    }
}
