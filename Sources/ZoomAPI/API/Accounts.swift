//
//  Accounts.swift
//  
//
//  Created by Varun Chitturi on 12/7/22.
//

import Foundation
import Vapor

extension ZoomClient {
    
    static let accountsEndpoint = ZoomClient.apiURL.appending("accounts")
    
    /// Returns an account's [managed domains](https://support.zoom.us/hc/en-us/articles/203395207)
    /// - Parameters:
    ///   - tokenSet: A user's credentials
    ///   - accountID: A managed account's ID or `"me"` for master account
    /// - Returns: A dictionary where the key is a managed domain and the value is the status
    public func getManagedDomains(_ credentials: BearerTokenSet, accountID: String = "me") async throws -> [String: String] {
        
        struct ManagedDomainsResponse: Content {
            struct Domain: Content {
                let domain: String
                let status: String
            }
            
            let domains: [Domain]
            let totalRecords: Int
        }
        
        let response = try await client.get(ZoomClient.accountsEndpoint.appending(accountID).appending("managed_domains")) { req in
            req.headers.bearerAuthorization = credentials.headers
        }
        let managedDomainsResponse = try response.content.decode(ManagedDomainsResponse.self, using: responseDecoder)
        var domains = [String: String]()
        managedDomainsResponse.domains.forEach({domains[$0.domain] = $0.status})
        return domains
    }
    
    
}
