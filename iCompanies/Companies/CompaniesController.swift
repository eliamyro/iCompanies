//
//  CompaniesController.swift
//  iCompanies
//
//  Created by Elias Myronidis on 07/11/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    let cellId = "cellId"
    var companies = [Company]()
    
    lazy var resetBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleResetButton))
        
        return barButtonItem
    }()
    
    lazy var doNestedUpdatedBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Nested Updates", style: .plain, target: self, action: #selector(doNestedUpdates))
        
        return barButtonItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Companies"
        
        navigationItem.leftBarButtonItems = [resetBarButton, doNestedUpdatedBarButton]
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        
        tableView.backgroundColor = .darkblue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        
        self.companies = CoreDataManager.shared.fetchCompanies()
    }
    
    @objc fileprivate func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc private func handleResetButton() {
        print("Reset button pressed")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
        } catch let deleteError {
            print("Failed to batch delete companies: ", deleteError.localizedDescription)
        }
        
        var indexPathsToRemove = [IndexPath]()
        for (index, _) in companies.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            indexPathsToRemove.append(indexPath)
        }
        
        companies.removeAll()
        tableView.deleteRows(at: indexPathsToRemove, with: .left)
    }
    
    @objc private func handleDoWork() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            (0...5).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            
            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
            } catch let saveError {
                print("Failed to save company: ", saveError.localizedDescription)
            }
        })
    }
    
    @objc private func handleDoUpdates() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            
            do {
                let companies = try backgroundContext.fetch(request)
                companies.forEach({ (company) in
                    print("\(company.name ?? "")")
                    company.name = "B: \(company.name ?? "")"
                })
                
                do {
                    try backgroundContext.save()
                    
                    // update the ui
                    DispatchQueue.main.async {
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                } catch let updateError {
                    print("Failed to update company name: ", updateError)
                }
                
            } catch let fetchError {
                print("Failed to fetch companies in the background: ", fetchError.localizedDescription)
            }
            
        }
    }
    
    @objc private func doNestedUpdates() {
        print("Trying to perform nested updates now...")
        
        DispatchQueue.global(qos: .background).async {
            // we will try our updates
            
            // first construct a custom managed object context
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            // execute update on the private context
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 3
            do {
                let companies = try privateContext.fetch(request)
                companies.forEach({ (company) in
                    print("\(company.name ?? "")")
                    company.name = "A: \(company.name ?? "")"
                })
                
                do {
                    try privateContext.save()
                    
                    DispatchQueue.main.async {
                        do {
                            let context = CoreDataManager.shared.persistentContainer.viewContext
                            if context.hasChanges {
                                try context.save()
                            }
                            self.tableView.reloadData()
                        } catch let saveError {
                            print("Failed to save: ", saveError.localizedDescription)
                        }                                            }
                } catch let saveError {
                    print("Failed to save company: ", saveError.localizedDescription)
                }
                
            } catch let fetchError {
                print("Failed to fetch companies: ", fetchError)
            }
            
        }
    }
}
