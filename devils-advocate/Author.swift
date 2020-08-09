//
//  Author.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 4/24/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

import Foundation

struct Author {
    let name: String
    let grade: String
    let id: String
    let img: String
    let role: String
}

//extension Author {
//    init?(json: [String: Any]) {
//        guard let title = json["title"] as? String,
//            let tagsJSON = json["tags"] as? [String],
//            let section = json["section"],
//            let contents = json["contents"],
//            let author = json["author"],
//            let id = json["id"],
//            let image = json["image"],
//            let featured = json["featured"],
//            let edition = json["edition"]
//            else {
//                return nil
//        }
//        self.title = title
//        var tags = [String]()
//        for tag in tagsJSON {
//            tags.insert(tag, at: tags.count)
//        }
//        self.tags = tags
//        self.section = section as! String
//        self.contents = contents as! String
//        self.author = author as! String
//        self.id = id as! String
//        self.image = image as! String
//        self.featured = featured as! Bool
//        self.edition = edition as! String
//    }
//}
