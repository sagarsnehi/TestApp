//
//  Webservice.swift
//  WiproTest
//
//  Created by sagar snehi on 09/12/19.
//  Copyright © 2019 sagar snehi. All rights reserved.
//

import Foundation
import UIKit.UIImage


///HTTP Mesthods
public enum HttpMethod<Body> {
    case get
    case post(Body)
}

internal extension HttpMethod {
    /// returns String for respective HttpMethod
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
    
    /// Maps body with HTTP Method
    func map<B>(f: (Body) -> B) -> HttpMethod<B> {
        switch self {
        case .get: return .get
        case .post(let body):
            return .post(f(body))
        }
        
    }
}

///Extension of URLSession for consuming APIs
public extension URLSession {
    
    static let imageCache = NSCache<NSURL, UIImage>()
    // make API call
    func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A>) -> ()) -> URLSessionDataTask {
        let request = URLRequest(resource: resource)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(Result.error(
                    ResourceError.serverError(data: data)
                ))
                return
            }
            /// Get response headers
            guard let data = data else {
                completion(Result.error(ResourceError.noDataError))
                return
            }
            /// Success
            if 200...299 ~= httpResponse.statusCode{
                if let parseResult = resource.parse(data) {
                    completion(Result.success(parseResult))
                } else {
                    completion(Result.error(ResourceError.parseError(data: data)))
                }
            } else if httpResponse.statusCode == 503 {
                completion(Result.error(ResourceError.downForMaintenance))
            } else {
                /// Prepare error dictionary
                completion(Result.error(ResourceError.serverError(data: data)))
            }
            return
        })
        task.resume()
        return task
    }
    
    //Load image asynchronously
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask?{
        if let image = URLSession.imageCache.object(forKey: url as NSURL)
        {
            DispatchQueue.main.async {
                completion(image)
            }
        }
        else
        {
            let task = URLSession.init(configuration: .ephemeral).dataTask(with: url) { (imageData, _, _) in
                guard let imageData = imageData,
                    let image = UIImage(data: imageData)
                    else {
                        completion(nil)
                        return
                }
                URLSession.imageCache.setObject(image, forKey: url as NSURL)
                completion(image)
                
            }
            task.resume()
            return task
        }
        return nil
    }
}

///Extension of URLRequest
public extension URLRequest{
    /**
     Initializer which create the URLRequest by assigning URL, HTTPMethod, and other HTTPHeaderField.
     - Parameters:
     - resource: Takes a resource of Type.A and assigns the URL, Method type from Resource.
     */
    init<A>(resource: Resource<A>) {
        self.init(url: resource.url)
        self.httpMethod = resource.method.method
        if case let .post(data) = resource.method {
            self.httpBody = data
        }
        guard resource.headers != nil else {
            return
        }
        for (key, value) in resource.headers! {
            self.setValue(value, forHTTPHeaderField: key)
        }
    }
}
