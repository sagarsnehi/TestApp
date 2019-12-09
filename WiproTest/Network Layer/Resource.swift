//
//  Resource.swift
//  WiproTest
//
//  Created by sagar snehi on 09/12/19.
//  Copyright © 2019 sagar snehi. All rights reserved.
//

import Foundation

/// An error type that will be returned for any unsuccessful fetches of resources
public enum ResourceError: Error {
    case serverError(data: Data?)
    case noDataError
    case parseError(data: Data?)
    case downForMaintenance
}

/// Enapsualtes information required to perform an API request
public struct Resource<APIType: Decodable> {
    public let url: URL
    public let method: HttpMethod<Data>
    public let headers: Dictionary<String, String>?
    public let parse: (Data) -> APIType?
}

public extension Resource {
    /**
     This prepares the resource and decode the the response
    **/
    init(url: URL, method: HttpMethod<Data> = .get, headers: Dictionary<String, String>? = nil) {
        self.url = url
        self.method = method.map { json in
            json
        }
        self.headers = headers
        self.parse = { data in
            if let _ = APIType.self as? Data.Type {
                return data as? APIType
            }
            do{
                let decoder = JSONDecoder()
                let utf8Data = String(decoding: data, as: UTF8.self).data(using: .utf8)
                let responseData = try decoder.decode(APIType.self, from: utf8Data!)
                return responseData
            } catch {
                debugPrint(error)
            }
            return nil
        }
    }
}

/// Result of API Response
public enum Result<APIType> {
    case success(APIType)
    case error(ResourceError)
}

public extension Result {
    func map<B>(_ transform: (APIType) -> B) -> Result<B> {
        switch self {
        case .success(let value): return .success(transform(value))
        case .error(let error): return .error(error)
        }
    }
}
