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
            self.contentView.layoutIfNeeded()
        }
    }
    override func prepareForReuse() {
            super.prepareForReuse()
            self.testImageView.image = nil
        
    }
    
    lazy var testImageView:UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .lightGray
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
        return img
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style : style, reuseIdentifier : reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.addSubview(testImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLbl)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        //Constraints
        testImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        testImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant: 16).isActive = true
        testImageView.widthAnchor.constraint(equalToConstant: 66).isActive = true
        testImageView.heightAnchor.constraint(equalToConstant: 66).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.testImageView.rightAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        descriptionLbl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        descriptionLbl.leftAnchor.constraint(equalTo: self.testImageView.rightAnchor, constant: 10).isActive = true
        descriptionLbl.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        descriptionLbl.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        super.layoutSubviews()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
