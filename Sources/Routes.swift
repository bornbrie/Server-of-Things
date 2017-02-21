//
//  Routes.swift
//  Server of Things
//
//  Created by Benjamin Heutmaker on 2/13/17.
//
//

import PerfectHTTP
import PerfectHTTPServer
import PerfectMustache

import TurnstilePerfect
import Turnstile
import TurnstileCrypto
import TurnstileWeb


public func makeThingsRoutes(_ root: String = "/api/v1") -> Routes {
    var routes = Routes(baseUri: root)
    
    routes.add(method: .get, uri: "/things", handler: ThingsHandler.retrieveAllThingsGET)
    routes.add(method: .post, uri: "/things", handler: ThingsHandler.newThingHandlerPOST)
    routes.add(method: .get, uri: "/things/{id}", handler: ThingsHandler.thingFromIdGET)
    routes.add(method: .delete, uri: "/things/{id}", handler: ThingsHandler.deleteThingDELETE)
    
    return routes
}

public func makeAttributesRoutes(_ root: String = "/api/v1") -> Routes {
    var routes = Routes(baseUri: root)
    
    routes.add(method: .get, uri: "/attributes", handler: AttributesHandler.attributesFromParentGET)
    routes.add(method: .put, uri: "/attributes/{attributeid}", handler: AttributesHandler.updateAttributeFromIdPUT)
    routes.add(method: .post, uri: "/attributes", handler: AttributesHandler.newAttributeHandlerPOST)
    routes.add(method: .get, uri: "/attributes/{attributeid}", handler: AttributesHandler.attributeFromIdGET)
    routes.add(method: .delete, uri: "/attributes/{attributeid}", handler: AttributesHandler.attributeFromIdDELETE)
    
    return routes
}

public func makeRootRoute(_ root: String = "/api/v1") -> Routes {
    var routes = Routes(baseUri: root)
    
    routes.add(method: .get, uri: "/authcheck") { (request, response) in
        response.completed()
    }
    
    routes.add(method: .get, uri: "/") { (request, response) in
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>Things</title><body><p><center>Things API is live</center></p><p><center>⚫️⬛️</center></p></body></html>")
        response.completed()
    }
    
    return routes
}
