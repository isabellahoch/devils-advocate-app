//
//  Article.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 4/24/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

import Foundation

struct Article {
    let title: String
    let tags: [String]
    let section: String
    let contents: String
    let author: Author
    let id: String
    let image: String
    let featured: Bool
    let edition: String
}

extension Article {
    init?(json: [String: Any]) {
        guard let title = json["title"] as? String,
            let tagsJSON = json["tags"] as? [String],
            let section = json["section"],
            let contents = json["contents"],
            let author = json["author"],
            let id = json["id"],
            let image = json["image"],
            let featured = json["featured"],
            let edition = json["edition"]
            else {
                return nil
        }
        self.title = title
        var tags = [String]()
        for tag in tagsJSON {
            tags.insert(tag, at: tags.count)
        }
        self.tags = tags
        self.section = section as! String
        self.contents = contents as! String
        self.author = Author(name: author as! String, grade: "0", id: author as! String, img: "", role: "Contributor")
        self.id = id as! String
        self.image = image as! String
        self.featured = featured as! Bool
        self.edition = edition as! String
    }
}
