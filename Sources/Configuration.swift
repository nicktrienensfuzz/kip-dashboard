import PathKit
import Dependencies
import AWSLambdaRuntime
import Hummingbird
import HummingbirdFoundation
import AsyncHTTPClient
import Foundation

struct Configuration {
    let openSearchEndpoint: String
    let openSearchUsername: String
    let openSearchPassword: String
    
    init() {
        let path = Path.current + Path("dev.env")
        let vars = try? DotEnv.parseEnvironment(contents: path.read())
        openSearchEndpoint = vars?["openSearchEndpoint"] ?? Lambda.env("openSearchEndpoint") ?? ""
        openSearchUsername = vars?["openSearchUsername"] ?? Lambda.env("openSearchUsername") ?? ""
        openSearchPassword = vars?["openSearchPassword"] ?? Lambda.env("openSearchPassword") ?? ""
        
    }
}

private enum ConfigurationKey: DependencyKey {
    static let liveValue: Configuration = {
        Configuration()
    }()
}

extension DependencyValues {
    var configuration: Configuration {
        get { self[ConfigurationKey.self] }
        set { self[ConfigurationKey.self] = newValue }
    }
}

private enum HTTPClientKey: DependencyKey {
    static let liveValue: HTTPClient = {
        let timeout = HTTPClient.Configuration.Timeout(
            connect: .seconds(20),
            read: .seconds(20)
        )
        let httpClient = HTTPClient(
            eventLoopGroupProvider: .createNew,
            configuration: HTTPClient.Configuration(timeout: timeout)
        )
        return httpClient
        
    }()
}



extension DependencyValues {
    var httpClient: HTTPClient {
        get { self[HTTPClientKey.self] }
        set { self[HTTPClientKey.self] = newValue }
    }
}

extension HBResponseBody {
    static func data(_ data: Data) -> HBResponseBody {
        var byteBuffer = ByteBuffer()
        byteBuffer.writeBytes(data)
        return HBResponseBody.byteBuffer(byteBuffer)
        
    }
    static func data(_ string: String) -> HBResponseBody {
        var byteBuffer = ByteBuffer()
        byteBuffer.writeBytes( string.data(using: .utf8)!)
        return  HBResponseBody.byteBuffer(byteBuffer)
    }
}
