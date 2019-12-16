//
//  URLFactory.swift
//  WiproTest
//
//  Created by sagar snehi on 09/12/19.
//  Copyright © 2019 sagar snehi. All rights reserved.
//

import Foundation
final class URLFactory{

static let shared = URLFactory()
private init() { }

func prepareDataURL() -> URL{
    return URL.init(string: kURL)!
}
}
