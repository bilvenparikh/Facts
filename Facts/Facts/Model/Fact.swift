//
//  Fact.swift
//  Facts
//
//  Created by 3Embed on 18/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//

import UIKit

// MARK:- Fact Object
struct Fact: Codable {
    let descriptionField: String
    let imageHref: String?
    let title: String
    // MARK:- Coding Keys of Object
    enum CodingKeys: String, CodingKey {
        case descriptionField = "description"
        case imageHref = "imageHref"
        case title = "title"
    }
    // MARK:- Custom Init method for Object
    init(withTitle title: String, description: String, imageHref: String) {
        self.title = title
        self.descriptionField = description
        self.imageHref = imageHref
    }
    // MARK:- Init from Decoder
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField) ?? AppConstants.Messages.NoDescription
        imageHref = try values.decodeIfPresent(String.self, forKey: .imageHref)
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? AppConstants.Messages.NoTitle
    }
}

// MARK:- Main JSONFileData Object
struct JsonFileData: Codable {
    var facts: [Fact] = []
    var title: String = ""
    // MARK:- Coding keys of Object
    enum CodingKeys: String, CodingKey {
        case facts = "rows"
        case title = "title"
    }
    // MARK:- Init from Decoder
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        facts = try values.decodeIfPresent([Fact].self, forKey: .facts) ?? []
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
    }

}

