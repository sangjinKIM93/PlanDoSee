//
//  Encodable+Extension.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/24.
//

import Foundation

extension Decodable {
    static func decode<T: Decodable>(dictionary: [String: Any]) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [.fragmentsAllowed])
        return try JSONDecoder().decode(T.self, from: data)
    }
}
