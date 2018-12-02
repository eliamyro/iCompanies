//
//  CompaniesController+CreateCompanyDelegate.swift
//  iCompanies
//
//  Created by Elias Myronidis on 02/12/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import Foundation

extension CompaniesController: CreateCompanyControllerDelegate {
    func didAddCompany(company: Company) {
        companies.append(company)
        
        let indexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func didEditCompany(company: Company) {
        let companyRow = companies.firstIndex(of: company)
        let indexPath = IndexPath(row: companyRow!, section: 0)
        tableView.reloadRows(at: [indexPath], with: .middle)
    }
}
