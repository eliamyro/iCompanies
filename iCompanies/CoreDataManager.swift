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
    
}
