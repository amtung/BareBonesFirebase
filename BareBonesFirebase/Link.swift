//
//  Link.swift
//  BareBonesFirebase
//
//  Created by Annie Tung on 2/13/17.
//  Copyright © 2017 Annie Tung. All rights reserved.
//

import Foundation

class Link {
    let key: String
    let url: String
    let comment: String
    
    init(key: String, url: String, comment: String) {
        self.key = key
        self.url = url
        self.comment = comment
    }
    
    var asDictionary: [String: String] {
        // sending back to firebase where it already has a key
        return ["url" : url,
                "comment" : comment]
    }
}
