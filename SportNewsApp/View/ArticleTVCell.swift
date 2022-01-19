//
//  ArticleTableViewCell.swift
//  SportNewsApp
//
//  Created by Mac on 18/01/2022.
//

import UIKit

class ArticleTVCell: UITableViewCell {
    
    static let identifier = "CustomArticleTVCell"
    
    var iconImageArticle = UIImageView()
    var titleLabelArticle = UILabel()
    var shotDescriptionLabe = UILabel()
    var dateTimeLabel = UILabel()
    var imageHeight = 300
    var imageWidth = 500
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupArticleTVCellConstraints()
        setupArticleTVCellLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setArticleStaticTestInfo() {
        
        // static info for testing purpose
        
        iconImageArticle.image = UIImage(named: "news1")
        titleLabelArticle.text = "Фомин рассказал об адаптации Смолова"
        dateTimeLabel.text = "Сегодня, 12:55"
        shotDescriptionLabe.text = "Полузащитник «Динамо» объяснил, что коллектив хорошо принял Федора."
        // setting up height of iconArticleImage
        imageHeight = Int(iconImageArticle.image?.size.height ?? 300)
        imageWidth = Int(iconImageArticle.image?.size.width ?? 500)
        
        let ratio: Double = (Double(imageWidth) / Double(imageHeight))
        let widthScreen = (UIScreen.main.bounds.width - 20)
        let calcHeight = widthScreen / CGFloat(ratio)
        let imageConstraint = iconImageArticle.heightAnchor.constraint(equalToConstant: calcHeight)
        imageConstraint.priority = UILayoutPriority(999)
        imageConstraint.isActive = true
        
    }
    func setArticle(article: ArticleRealm) {
        
        iconImageArticle.image = UIImage(named: "emptyThumbnailSport")
        titleLabelArticle.text = article.title
        dateTimeLabel.text = article.timeAndDate
        shotDescriptionLabe.text = article.shortDescr
        
        if let imageWebURL = article.imageWebURL {
            iconImageArticle.loadImageUsingUrlString(urlString: imageWebURL)
        }
        // setting up height of iconArticleImage
        imageHeight = Int(iconImageArticle.image?.size.height ?? 552)
        imageWidth = Int(iconImageArticle.image?.size.width ?? 820)
        
        let ratio: Double = (Double(imageWidth) / Double(imageHeight))
        let widthScreen = (UIScreen.main.bounds.width - 60)
        let calcHeight = widthScreen / CGFloat(ratio)
        let imageConstraint = iconImageArticle.heightAnchor.constraint(equalToConstant: calcHeight)
        imageConstraint.priority = UILayoutPriority(999)
        imageConstraint.isActive = true
        
    }
    
    
    
    private func setupArticleTVCellLayouts() {
        
        titleLabelArticle.numberOfLines = 0
        titleLabelArticle.font = .boldSystemFont(ofSize: 18)
        
        dateTimeLabel.font = .systemFont(ofSize: 14)
        dateTimeLabel.textColor = .lightGray
        
        shotDescriptionLabe.font = .systemFont(ofSize: 16)
        shotDescriptionLabe.textColor = .gray
        shotDescriptionLabe.numberOfLines = 0
        
        iconImageArticle.contentMode = .scaleAspectFill
    }
    
    private func setupArticleTVCellConstraints() {
        
        addSubview(iconImageArticle)
        addSubview(titleLabelArticle)
        addSubview(dateTimeLabel)
        addSubview(shotDescriptionLabe)
        
        iconImageArticle.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: -10, width: 0, height: 0)
        
        titleLabelArticle.anchor(top: iconImageArticle.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: -30, width: 0, height: 0)
        
        dateTimeLabel.anchor(top: titleLabelArticle.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: -30, width: 0, height: 0)
        
        shotDescriptionLabe.anchor(top: dateTimeLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: -10, paddingRight: -30, width: 0, height: 0)
    }
}
