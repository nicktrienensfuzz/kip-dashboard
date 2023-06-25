import PathKit
import Dependencies

struct Configuration {
    let openSearchEndpoint: String
    let openSearchUsername: String
    let openSearchPassword: String
    
    init() {
        let path = Path.current + Path("dev.env")
        let vars = try? DotEnv.parseEnvironment(contents: path.read())
        openSearchEndpoint = vars?["openSearchEndpoint"] ?? ""
        openSearchUsername = vars?["openSearchUsername"] ?? ""
        openSearchPassword = vars?["openSearchPassword"] ?? ""
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
