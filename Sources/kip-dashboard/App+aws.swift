//
//  File.swift
//
//
//  Created by Nicholas Trienens on 7/2/23.
//

import Dependencies
import Foundation
import Hummingbird
import SotoS3

public extension HBApplication {
    struct AWS {
        public var client: AWSClient {
            get { application.extensions.get(\.aws.client) }
            nonmutating set {
                application.extensions.set(\.aws.client, value: newValue) { client in
                    try client.syncShutdown()
                }
            }
        }

        public var s3: S3 {
            get { application.extensions.get(\.aws.s3) }
            nonmutating set { application.extensions.set(\.aws.s3, value: newValue) }
        }

        let application: HBApplication
    }

    var aws: AWS { .init(application: self) }
}

public extension HBRequest {
    struct AWS {
        var client: AWSClient { application.aws.client }
        var s3: S3 { application.aws.s3 }
        let application: HBApplication
    }

    var aws: AWS { .init(application: application) }
}

extension HBApplication {
    func configureS3() {
        @Dependency(\.configuration) var configuration

        aws.client = AWSClient(
            credentialProvider:
            .static(
                accessKeyId: configuration.accessKeyId,
                secretAccessKey: configuration.secretAccessKey
            ),
            httpClientProvider: .createNewWithEventLoopGroup(eventLoopGroup)
        )

        aws.s3 = S3(client: aws.client, region: .uswest2, endpoint: "https://s3.us-west-2.amazonaws.com")

        middleware.add(S3FileMiddleware(bucket: "zendat", folder: "kpiDashboard/", s3: aws.s3))
    }
}
