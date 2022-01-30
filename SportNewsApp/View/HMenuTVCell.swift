//
//  HMenuTVCell.swift
//  SportNewsApp
//
//  Created by Mac on 30/01/2022.
//
//


import UIKit

class HMenuTVCell: UITableViewCell {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sidebar.leading")?.withRenderingMode(.alwaysOriginal)
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let textLabelDescr: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    static let identifier = "CustomTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .greenMain()
        contentView.addSubview(iconImageView)
        contentView.addSubview(textLabelDescr)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cellHeight = contentView.frame.height
        let iconImageSize = cellHeight - 20
        iconImageView.frame = CGRect(x: 10,
                                     y: (cellHeight - iconImageSize) / 2,
                                     width: iconImageSize,
                                     height: iconImageSize)
        textLabelDescr.frame = CGRect(x: iconImageSize + 30,
                                      y: 0,
                                      width: contentView.frame.width - iconImageSize - 10,
                                      height: cellHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        textLabelDescr.text = nil
    }
}
