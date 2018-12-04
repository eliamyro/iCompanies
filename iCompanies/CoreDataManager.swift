//
//  CoreDataManager.swift
//  iCompanies
//
//  Created by Elias Myronidis on 09/11/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CompaniesDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed: \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchError {
            print("Failed to fetch companies: ", fetchError.localizedDescription)
            return []
        }
    }
    
    func createEmployee(name: String, company: Company, completion: (Employee?, Error?) -> ()) {
        let context = persistentContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        employee.company = company
        employee.name = name
        
        do {
            try context.save()
            completion(employee, nil)
        } catch let saveError {
            completion(nil, saveError)
        }
    }
}
