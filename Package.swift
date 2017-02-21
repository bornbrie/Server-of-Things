// Generated automatically by Perfect Assistant Application
// Date: 2017-02-13 04:14:41 +0000
import PackageDescription
let package = Package(
    name: "Server of Things",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTP.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-SQLite.git", majorVersion: 2),
        .Package(url: "https://github.com/SwiftORM/SQLite-StORM.git", majorVersion: 1),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Turnstile-SQLite.git", majorVersion: 1),
        .Package(url: "https://github.com/JustHTTP/Just.git", majorVersion: 0),
    ]
)