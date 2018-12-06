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
    
    var executives = [Employee]()
    var seniorManagement = [Employee]()
    var staff = [Employee]()
    
    var allEmployees = [[Employee]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkblue
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: EmployeesController.CELL_ID)
      
        fetchEmployees()
    }
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        executives = companyEmployees.filter({ (employee) -> Bool in
            if let type = employee.type {
                return type == "Executive"
            }
            
            return false
        })
        
        seniorManagement = companyEmployees.filter({ (employee) -> Bool in
            if let type = employee.type {
                return type == "Senior Management"
            }
            
            return false
        })
        
        staff = companyEmployees.filter({ (employee) -> Bool in
            if let type = employee.type {
                return type == "Staff"
            }
            
            return false
        })
        
        allEmployees = [executives, seniorManagement, staff]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.name
        
        
    }
    
    @objc private func handleAdd() {
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        self.present(navController, animated: true, completion: nil)
    }
}
