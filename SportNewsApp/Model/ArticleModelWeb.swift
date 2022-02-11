//
//  ArticleWebModel.swift
//  SportNewsApp
//
//  Created by Mac on 23/01/2022.
//
//


import UIKit

struct ArticlesWebS: Codable {
    
    let body: [ArticleWebS]?
}

struct ArticleWebS: Codable {
    
    let id: String
    let author: String?
    let date: String?
    let shortStory: String?
    let fullStory: String?
    let title: String?
    let descr: String?
    let category: String?
    let country: String?
    let imageThumbLink: String?
    
    enum CodingKeys: String, CodingKey {
        case id, author, date
        case shortStory = "short_story"
        case fullStory = "full_story"
        case title, descr, category, country
        case imageThumbLink = "image_thumb_link"
    }
}
