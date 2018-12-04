//
//  CreateEmployeeController.swift
//  iCompanies
//
//  Created by Elias Myronidis on 04/12/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import UIKit

class CreateEmployeeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkblue
        
        setupCancelButtonInNavBar()
        navigationItem.title = "Create Employee"
    }
}
