//
//  main.swift
//  Server of Things
//
//  Created by Benjamin Heutmaker on 1/25/17.
//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import SQLite
import SQLiteStORM

import TurnstilePerfect
import PerfectTurnstileSQLite

// Used later in script for the Realm and how the user authenticates.
let pturnstile = TurnstilePerfectRealm()

// Set the connection variable
SQLiteConnector.db = "/Users/benheutmaker/Documents/Developer/Exoteric Design/Server of Things/Sources/thingsdb.db"

// Initialize the AccessTokenStore
tokenStore = AccessTokenStore()

// Setup all SQLite3 Tables
do {
    try Thing.init().setupTable()
    try Attribute.init().setupTable()
    try AuthAccount.init().setupTable()
    try AccessTokenStore.init().setupTable()
    try tokenStore?.setup()
    
} catch {
    fatalError("failed to set up SQLite table")
}

// Create HTTP Server
let server = HTTPServer()

// Register routes and handlers
let root = makeRootRoute()

let thingsRoutes = makeThingsRoutes()
let attributesRoutes = makeAttributesRoutes()

let authWebRoutes = makeWebAuthRoutes()
let authJSONRoutes = makeJSONAuthRoutes("/api/v1")


// Add the routes to the server.
server.addRoutes(root)

server.addRoutes(thingsRoutes)
server.addRoutes(attributesRoutes)

server.addRoutes(authWebRoutes)
server.addRoutes(authJSONRoutes)


// add routes to be checked for auth
var authenticationConfig = AuthenticationConfig()
authenticationConfig.include("/api/v1/*")
authenticationConfig.exclude("/api/v1/login")
authenticationConfig.exclude("/api/v1/register")

let authFilter = AuthFilter(authenticationConfig)

// Note that order matters when the filters are of the same priority level
server.setRequestFilters([pturnstile.requestFilter])
server.setResponseFilters([pturnstile.responseFilter])

server.setRequestFilters([(authFilter, .high)])

server.serverPort = 8681

// Where to serve static files from
server.documentRoot = "./webroot"

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
