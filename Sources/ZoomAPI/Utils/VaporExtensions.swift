//
//  VaporExtensions.swift
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

extension ContentContainer {
    func decode<D1: Decodable, D2: Decodable>(_ decodables: (D1.Type, D2.Type), using decoder: ContentDecoder) throws -> (D1, D2){
        return (try decode(decodables.0, using: decoder), try decode(decodables.1, using: decoder))
    }
}
