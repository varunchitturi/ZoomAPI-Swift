//
//  PersistentKeyValue.swift
//  
//
//  Created by Varun Chitturi on 12/6/22.
//

import Foundation
import Fluent
import FluentSQLiteDriver

public final class PersistentKeyValue: Model {
    public static let schema = "persistent_values"
    
    var key: String? {
        self.id
    }
    
    @ID(custom: "key", generatedBy: .user)
    public var id: String?
    
    @Field(key: "value")
    var value: String
    
    public init() { }
    
    public init(key: String, value: String) {
            self.id = key
            self.value = value
        }
}

struct PersistentKeyValueMigration: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema(PersistentKeyValue.schema)
            .field("key", .string, .identifier(auto: false))
            .field("value", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema(PersistentKeyValue.schema)
            .delete()
    }
    
    
}
