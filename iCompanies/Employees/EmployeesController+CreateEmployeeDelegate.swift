//
//  EmployeesController+CreateEmployeeDelegate.swift
//  iCompanies
//
//  Created by Elias Myronidis on 04/12/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import UIKit

extension EmployeesController: CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        guard let section = employeeTypes.firstIndex(of: employee.type!) else { return }
        let row = allEmployees[section].count
        let indexPath = IndexPath(row: row, section: section)

        allEmployees[section].append(employee)        
        tableView.insertRows(at: [indexPath], with: .middle)
    }
}
