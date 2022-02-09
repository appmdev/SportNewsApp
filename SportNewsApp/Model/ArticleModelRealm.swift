//
//  ArticleModelRealm.swift
//  SportNewsApp
//
//  Created by Mac on 19/01/2022.
//


import RealmSwift


class ArticleRealm: Object {
    
    @objc dynamic var id = String()
    //@objc dynamic var intId = Int()
    @objc dynamic var title = ""
    @objc dynamic var category = ""
    @objc dynamic var country = ""
    @objc dynamic var thumbnailImageName: String?
    @objc dynamic var shortDescr: String?
    @objc dynamic var fullDescr: String?
    @objc dynamic var timeAndDate: String?
    @objc dynamic var imageWebURL: String?
    
    // Return the name of the primary key property
    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(id: String, title: String, category: String, country: String, shortDescr: String, fullDescr: String, timeAndDate: String, imageWebURL: String){
        self.init()
        
        self.id = id
        //self.intId = intId
        self.title = title
        self.category = category
        self.country = country
        self.shortDescr = shortDescr
        self.fullDescr = fullDescr
        self.timeAndDate = timeAndDate
        self.imageWebURL = imageWebURL
    }
}
class ArticleRealm2: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var category = ""
    @objc dynamic var thumbnailImageName: String?
    @objc dynamic var shortDescr: String?
    @objc dynamic var fullDescr: String?
    @objc dynamic var timeAndDate: String?
    @objc dynamic var imageWebURL: String?
    
    // Return the name of the primary key property
    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(id: String, title: String, category: String, shortDescr: String, fullDescr: String, timeAndDate: String, imageWebURL: String){
        self.init()
        
        self.id = id
        self.title = title
        self.category = category
        self.shortDescr = shortDescr
        self.fullDescr = fullDescr
        self.timeAndDate = timeAndDate
        self.imageWebURL = imageWebURL
    }
}
