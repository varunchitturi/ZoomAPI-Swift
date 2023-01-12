//
//  Accounts.swift
//  
//
//  Created by Varun Chitturi on 12/7/22.
//

import Foundation
import Vapor

extension ZoomClient {
    
    static let accountsEndpoint = ZoomClient.apiUrl.appending("accounts")
    
    /// Returns an account's [managed domains](https://support.zoom.us/hc/en-us/articles/203395207)
    /// - Parameters:
    ///   - tokenSet: A user's credentials
    ///   - accountId: A managed account's Id or `"me"` for master account
    /// - Returns: A dictionary where the key is a managed domain and the value is the status
    public func getManagedDomains(_ credentials: BearerTokenSet, accountId: String = "me") async throws -> [String: String] {
        
        struct ManagedDomainsResponse: Content {
            struct Domain: Content {
                let domain: String
                let status: String
            }
            
            let domains: [Domain]
            let totalRecords: Int
        }
        
        let managedDomainsResponse = try await get(ZoomClient.accountsEndpoint.appending(accountId).appending("managed_domains"), decoding: ManagedDomainsResponse.self, credentials: credentials)
        var domains = [String: String]()
        managedDomainsResponse.domains.forEach({domains[$0.domain] = $0.status})
        return domains
    }
    
    
}
