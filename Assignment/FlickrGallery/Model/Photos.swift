//
//  Photos.swift
//  Assignment
//
//  Created by xeadmin on 05/09/19.
//  Copyright © 2019 Manav. All rights reserved.
//

import Foundation

struct Photos :Codable{
    var id :String
    var owner :String
    var secret :String
    var server :String
    var title :String
    var farm :Int
    var ispublic :Int
    var isfriend :Int
    var isfamily :Int
    
    func getImageURL() -> URL? {
        if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg") {
            return url
        }
        return nil
    }
    
}
