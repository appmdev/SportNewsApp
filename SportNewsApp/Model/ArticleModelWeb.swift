//
//  ArticleWebModel.swift
//  SportNewsApp
//
//  Created by Mac on 23/01/2022.
//
//


import UIKit

struct ArticlesWeb: Codable {
    
    let body: [ArticleWeb]?
    let itemCount: Int?
}

struct ArticleWeb: Codable {
    let id: String
    let autor, date, shortStory: String?
    let title: String?
    let category: String?
    let fullStory, descr: String?
    
    enum CodingKeys: String, CodingKey {
        case id, autor, date
        case shortStory = "short_story"
        case title, category
        case fullStory = "full_story"
        case descr
    }
}
