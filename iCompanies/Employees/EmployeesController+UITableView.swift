//
//  EmployeesController+UITableView.swift
//  iCompanies
//
//  Created by Elias Myronidis on 04/12/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import UIKit

extension EmployeesController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = CustomHeader()
        
        if section == 0 {
            label.text = "Short names"
        } else if section == 1 {
            label.text = "Long names"
        } else {
            label.text = "Realy long names"
        }
        
        label.backgroundColor = UIColor.lightBlue
        label.textColor = UIColor.darkblue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeesController.CELL_ID, for: indexPath)
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.textColor = UIColor.white
        
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        if let birthday = employee.birthday {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd MMM, yyyy"
        
            cell.textLabel?.text = "\(employee.name ?? "") \(dateFormater.string(from: birthday))"
        } else {
            cell.textLabel?.text = employee.name
        }
        
        return cell
    }
}
