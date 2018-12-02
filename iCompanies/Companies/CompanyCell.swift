//
//  CustomCompanyCell.swift
//  iCompanies
//
//  Created by Elias Myronidis on 25/11/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    var company: Company? {
        didSet {
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd MMM, yyyy"
            
            if let name = company?.name, let founded = company?.founded {
                let foundedDateString = dateFormater.string(from: founded)
                nameFoundedDateLabel.text = "\(name) - \(foundedDateString)"
            } else {
                nameFoundedDateLabel.text = company?.name
            }
        }
    }
    
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "select_photo_empty")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkblue.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.tealColor
        
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(companyImageView)
        addSubview(nameFoundedDateLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        companyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        nameFoundedDateLabel.leadingAnchor.constraint(equalTo: companyImageView.trailingAnchor, constant: 16).isActive = true
        nameFoundedDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16).isActive = true
        nameFoundedDateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
