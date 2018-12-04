//
//  EmployeesController+CreateEmployeeDelegate.swift
//  iCompanies
//
//  Created by Elias Myronidis on 04/12/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import Foundation

extension EmployeesController: CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        
        let indextPath = IndexPath(row: employees.count - 1, section: 0)
        tableView.insertRows(at: [indextPath], with: .automatic)
    }
}
