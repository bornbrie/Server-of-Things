//
//  ThingsHandler.swift
//  Server of Things
//
//  Created by Benjamin Heutmaker on 2/16/17.
//
//

import PerfectLib
import PerfectHTTP
import PerfectMustache
import StORM
import Foundation

import TurnstilePerfect
import Turnstile
import TurnstileCrypto
import TurnstileWeb

import PerfectTurnstileSQLite

public class ThingsHandler {
    
    /* =================================================================================================================
     Retrieve all Things from User
     ================================================================================================================= */
    /// Retrieves all Things associated with authenticated user (GET)
    open static func retrieveAllThingsGET(request: HTTPRequest, _ response: HTTPResponse) {
        
        response.setHeader(.contentType, value: "application/json")
        
        var dict = [String:Any]()
        
        guard let userID = request.user.authDetails?.account.uniqueID else {
            response.status = .internalServerError
            dict["error"] = "Unable to retrieve user account"
            return
        }
        
        let things: [Thing] = Thing().rowsOwned(by: userID)
        
        let array: [[String:Any]] = things.map { (thing) -> [String:Any] in
            do {
                print(thing.attributes)
                let attributes: [String:Any] = try thing.attributes.jsonDecode() as! [String : Any]
                var dict = thing.asDataDict()
                dict["attributes"] = attributes
                return dict
                
            } catch {
                dict["error"] = error.localizedDescription
                return thing.asDataDict()
            }
        }
        
        dict["things"] = array
        
        do {
            try response.setBody(json: dict)
        } catch {
            response.status = .internalServerError
            dict["error"] = error.localizedDescription
        }
        
        response.completed()
    }
    /* =================================================================================================================
     Retrieve all Things
     ================================================================================================================= */
    
    
    
    /* =================================================================================================================
     Create New Thing
     ================================================================================================================= */
    /// Saves new Thing to database (POST)
    open static func newThingHandlerPOST(request: HTTPRequest, _ response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        
        var dict = [String:Any]()
        
        guard let userID = request.user.authDetails?.account.uniqueID else {
            response.status = .internalServerError
            dict["error"] = "500 INTERNAL SERVER ERROR: Unable to retrieve user account"
            return
        }
        
        guard
            let name = request.param(name: "name"),
            let icon = request.param(name: "icon")
            
            else {
                //BAD DATA
                response.status = .badRequest
                dict["error"] = "400 BAD REQUEST: Incomplete request data while posting Thing"
                response.completed()
                return
        }
        
        let thing   = Thing()
        thing.id    = UUID.init().string
        thing.name  = name
        thing.icon  = icon
        thing.owner = userID
        thing.created = Date().description
        
        do {
            try thing.create()
            dict["thing"] = thing.asDataDict()
            
        } catch {
            response.status = .internalServerError
            dict["error"] = "500 INTERNAL SERVER ERROR: " + error.localizedDescription
        }
        
        do {
            try response.setBody(json: dict)
            
        } catch {
            response.status = .internalServerError
        }
        
        response.completed()
    }
    /* =================================================================================================================
    /New Thing
    ================================================================================================================= */
    
    
    
    /* =================================================================================================================
     Retrieve Thing from ID
     ================================================================================================================= */
    /// JSON Thing from ID action (GET)
    open static func thingFromIdGET(request: HTTPRequest, _ response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        
        guard let id = request.urlVariables["id"] else {
            return
        }
        
        let thing = Thing()
        thing.id = id
        
        do {
            try thing.get()
            try response.setBody(json: thing.asDataDict())
            
        } catch {
            response.appendBody(string: error.localizedDescription)
        }
        
        response.completed()
    }
    /* =================================================================================================================
    /Retrieve Thing from ID
     ================================================================================================================= */
    
    
    
    /* =================================================================================================================
     Delete Thing
     ================================================================================================================= */
    /// Delete Thing from ID action (DELETE)
    open static func deleteThingDELETE(request: HTTPRequest, _ response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        
        guard let thingID = request.urlVariables["id"] else { return }
        
        let thing = Thing()
        thing.id = thingID
        
        do {
            try thing.delete()
            
        } catch {
            response.status = .internalServerError
            response.appendBody(string: error.localizedDescription)
        }
        
        response.completed()
    }
    /* =================================================================================================================
    /Delete Thing
     ================================================================================================================= */
}

