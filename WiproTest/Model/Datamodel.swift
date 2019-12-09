//
//  Datamodel.swift
//  WiproTest
//
//  Created by sagar snehi on 09/12/19.
//  Copyright © 2019 sagar snehi. All rights reserved.
//

import Foundation

struct DataResponse: Codable {
    let title : String?
    let rows : [RowsData]?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case rows = "rows"
    }
    
}
struct RowsData : Codable{
    let title : String?
    let description : String?
    let imageHref : String?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case imageHref = "imageHref"
    }
    
}
