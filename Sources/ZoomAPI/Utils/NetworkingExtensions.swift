//
//  NetworkingExtensions.swift
//  
//
//  Created by Varun Chitturi on 12/4/22.
//

import Foundation
import Vapor

extension URI {
    func appending(_ pathComponent: String) -> URI {
        let pathComponent = pathComponent.hasPrefix("/") || path.hasSuffix("/") ? pathComponent : "/" + pathComponent
        var uri = self
        uri.path += pathComponent
        return uri
    }
}

extension JSONDecoder {
    
}
