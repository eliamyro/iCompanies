//
//  EmployeesController+UITableView.swift
//  iCompanies
//
//  Created by Elias Myronidis on 04/12/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import UIKit

extension EmployeesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeesController.CELL_ID, for: indexPath)
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.textColor = UIColor.white
        
        if let birthday = employees[indexPath.row].birthday {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd MMM, yyyy"
        
            cell.textLabel?.text = "\(employees[indexPath.row].name ?? "") \(dateFormater.string(from: birthday))"
        } else {
            cell.textLabel?.text = employees[indexPath.row].name
        }
        
        return cell
    }
}
