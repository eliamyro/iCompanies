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
    
    var allEmployees = [[Employee]]()
    var employeeTypes = [EmployeeType.Executive.rawValue, EmployeeType.SeniorManagement.rawValue, EmployeeType.Staff.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkblue
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: EmployeesController.CELL_ID)
      
        fetchEmployees()
    }
    
    func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
       
        allEmployees = []
        
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(
                companyEmployees.filter { $0.type == employeeType }
            )
        }
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
