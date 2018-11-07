//
//  CompaniesController.swift
//  iCompanies
//
//  Created by Elias Myronidis on 07/11/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import UIKit

class CompaniesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 247, green: 66, blue: 82)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationItem.title = "Companies"
    }
    
    @objc fileprivate func handleAddCompany() {
        print("Handle add company")
    }
}

