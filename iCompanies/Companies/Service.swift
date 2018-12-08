//
//  Service.swift
//  iCompanies
//
//  Created by Elias Myronidis on 08/12/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import Foundation

struct Service {
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    static let shared = Service()
    
    func downloadCompaniesFromServer() {
        print("Attempting to download...")
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch companies: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            
            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                let context = CoreDataManager.shared.persistentContainer.viewContext
                
                jsonCompanies.forEach({ (jsonCompany) in
                    print(jsonCompany.name)
                    
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        print(jsonEmployee.name)
                    })
                })
                
            } catch let decodeError {
                print("Failed to decode: ", decodeError.localizedDescription)
            }
        }.resume()
        
        
    }
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let birthday: String
    let type: String
}
