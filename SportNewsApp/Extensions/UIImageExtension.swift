//
//  UIImageExtension.swift
//  SportNewsApp
//
//  Created by Mac on 19/01/2022.
//


import UIKit
import RealmSwift

extension UIView {
    
    func addConstraintsWithFormat(format: String, view: UIView) {
        var allConstraints: [NSLayoutConstraint] = []
        let thisView: [String: UIView] = ["v0": view]
        let constraint = NSLayoutConstraint.constraints(
            withVisualFormat: format,
            metrics: nil,
            views: thisView
        )
        allConstraints += constraint
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(allConstraints)
    }
}

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingUrlString(urlString: String) {
        
        image = nil
        let imageUrlString = urlString
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
        func downloadImageMain(from url: URL) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { [weak self] in
                    guard let imageToCache = UIImage(data: data) else { return}
                    
                    if imageUrlString == urlString{
                        
                        self?.image = UIImage(data: data)
                    }
                    imageCache.setObject(imageToCache, forKey: urlString as NSString)
                }
            }
        }
        if let url = URL(string: urlString) {
            downloadImageMain(from: url)
        } else { print("error downoad line 62")}
    }
}
