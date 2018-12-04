//
//  EmployeesController.swift
//  iCompanies
//
//  Created by Elias Myronidis on 04/12/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import UIKit

class EmployeesController: UITableViewController {
    
    static let CELL_ID = "cellId"
    
    var company: Company?
    var employees = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkblue
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: EmployeesController.CELL_ID)
        
        guard let companyName = company?.name else { return }
        employees = CoreDataManager.shared.fetchEmployees(companyName: companyName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.name
        
        
    }
    
    @objc private func handleAdd() {
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        let navController = UINavigationController(rootViewController: createEmployeeController)
        self.present(navController, animated: true, completion: nil)
    }
}
