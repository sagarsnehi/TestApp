//
//  CustomTVC.swift
//  WiproTest
//
//  Created by sagar snehi on 10/12/19.
//  Copyright © 2019 sagar snehi. All rights reserved.
//

import UIKit

class CustomTVC: UITableViewCell {
    var imageData : RowsData? {
        didSet{
            guard let imageItem = imageData else{return}
            if let imageUrl = imageItem.imageHref{
                self.testImageView.loadImage(withUrl: URL.init(string: imageUrl)!, showActivity: true)
            }
            if let title = imageItem.title{
                self.titleLabel.text = title
            }
            if let desc = imageItem.description{
                self.descriptionLbl.text = desc
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.testImageView.image = nil
        
    }
    
    lazy var testImageView:UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .lightGray
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
        return img
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLbl: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    ///cell Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style : style, reuseIdentifier : reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.addSubview(testImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLbl)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        NSLayoutConstraint.activate([
            self.testImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0),
            self.testImageView.heightAnchor.constraint(equalToConstant: 66.0),
            self.testImageView.widthAnchor.constraint(equalToConstant: 66.0),
            self.testImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0.0),
            self.testImageView.topAnchor.constraint(greaterThanOrEqualTo: self.contentView.topAnchor, constant: 5.0),
            self.contentView.bottomAnchor.constraint(greaterThanOrEqualTo: self.testImageView.bottomAnchor, constant: 5.0),
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5.0),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.testImageView.trailingAnchor, constant: 10.0),
            self.contentView.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 10.0),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 18.0),
            self.descriptionLbl.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor, constant: 0.0),
            self.descriptionLbl.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5.0),
            self.descriptionLbl.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 0.0),
            self.contentView.bottomAnchor.constraint(equalTo: self.descriptionLbl.bottomAnchor, constant: 10.0),
            self.descriptionLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
