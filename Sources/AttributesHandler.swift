//
//  AttributesHandler.swift
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

public class AttributesHandler {
    
    /* =================================================================================================================
     Create New Attribute
     ================================================================================================================= */
    /// JSON Create New Attribute action (POST)
    open static func newAttributeHandlerPOST(request: HTTPRequest, _ response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        
        guard
            let text = request.param(name: "text"),
            let type = request.param(name: "type"),
            let thingID = request.param(name: "parent")
            else {
                //BAD DATA
                print("incomplete request data")
                response.status = .badRequest
                response.appendBody(string: "incomplete request data while posting Attribute")
                response.completed()
                return
        }
        
        let attribute = Attribute()
        
        attribute.parent = thingID
        attribute.text = text
        attribute.id = UUID.init().string
        attribute.type = type
        
        do {
            try attribute.create()
            try response.setBody(json: attribute.asDataDict())
            
        } catch {
            print(error.localizedDescription)
            response.status = .internalServerError
            response.appendBody(string: error.localizedDescription)
        }
        
        response.completed()
    }
    /* =================================================================================================================
    /Create New Attribute
     ================================================================================================================= */
    
    
    
    /* =================================================================================================================
     Retrieve Attribute from ID
     ================================================================================================================= */
    /// JSON Attribute from ID action (GET)
    open static func attributeFromIdGET(request: HTTPRequest, _ response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        
        guard let thingID = request.urlVariables["thingid"] else {
            response.status = .badRequest
            response.appendBody(string: "Invalid id given for requested Thing")
            response.completed()
            return
        }
        
        guard let attributeID = request.urlVariables["attributeid"] else {
            response.status = .badRequest
            response.completed()
            return
        }
        
        let thing = Thing()
        thing.id = thingID
        
        do {
            try thing.get()
            
            if thing.attributes.contains(attributeID) {
                
                let attribute = Attribute()
                attribute.id = attributeID
                
                try attribute.get()
                
                try response.setBody(json: attribute.asDataDict())
                response.completed()
            }
            
        } catch {
            response.status = .internalServerError
            response.appendBody(string: error.localizedDescription)
            response.completed()
        }
    }
    /* =================================================================================================================
     /Retrieve Attribute from ID
     ================================================================================================================= */
    
    
    
    /* =================================================================================================================
     Attributes From Parent
     ================================================================================================================= */
    /// Retrieve all Attributes owned by given parent Thing (GET)
    open static func attributesFromParentGET(request: HTTPRequest, _ response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        
        guard let parent = request.param(name: "parent") else {
            response.status = .badRequest
            response.completed()
            return
        }
        
        let array: [[String:Any]] = Attribute().rowsOwned(by: parent)
        
        do {
            try response.setBody(json: ["attributes" : array])
            
        } catch {
            response.status = .internalServerError
            response.appendBody(string: error.localizedDescription)
        }
        
        response.completed()
    }
    /* =================================================================================================================
     Attributes From Parent
     ================================================================================================================= */
    
    open static func updateAttributeFromIdPUT(request: HTTPRequest, _ response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        
        var dict = [String:Any]()
        
        guard let attributeID = request.urlVariables["attributeid"] else {
            response.status = .badRequest
            dict["error"] = "400 BAD REQUEST: No ID in URL Parameters"
            response.completed()
            return
        }
        
        guard
            let text = request.param(name: "text")
            else {
                response.status = .badRequest
                dict["error"] = "400 BAD REQUEST: No Text parameter found in PUT"
                response.completed()
                return
        }
        
        let attribute = Attribute()
        attribute.id = attributeID
        
        do {
            try attribute.get()
        } catch {
            response.status = .badRequest
            dict["error"] = "400 BAD REQUEST: No Attribute for found for given attributeID. Error: \(error.localizedDescription)"
        }
        
        attribute.text = text
        
        do {
            try attribute.save()
            dict = attribute.asDataDict()
            
        } catch {
            response.status = .internalServerError
            dict["error"] = "500 INTERNAL SERVER ERROR: Failed to save Attribute to server-side database. Error: \(error.localizedDescription)"
        }
        
        do {
            try response.setBody(json: dict)
        } catch {
            response.status = .internalServerError
        }
        
        response.completed()
    }
    
    /* =================================================================================================================
     Delete Attribute
     ================================================================================================================= */
    /// JSON Delete Attribute action (DELETE)
    open static func attributeFromIdDELETE(request: HTTPRequest, _ response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        
        guard let attributeID = request.urlVariables["attributeid"] else { return }
        
        let attribute = Attribute()
        attribute.id = attributeID
        
        do {
            try attribute.delete()
            
        } catch {
            response.status = .internalServerError
            response.appendBody(string: error.localizedDescription)
        }
        
        response.completed()
    }
    /* =================================================================================================================
    /Delete Attribute
     ================================================================================================================= */
}
