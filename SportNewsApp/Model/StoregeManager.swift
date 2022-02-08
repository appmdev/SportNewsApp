//
//  StoregeManager.swift
//  SportNewsApp
//
//  Created by Mac on 23/01/2022.
//

import RealmSwift

let realm = try! Realm()

class StoreageManager {
    
    static func saveObject(_ article: ArticleRealm) {
        try! realm.write {
            realm.create(ArticleRealm.self, value: article, update: .all)
        }
    }

    static func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}

