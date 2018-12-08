//
//  CompaniesAutoUpdateController.swift
//  iCompanies
//
//  Created by Elias Myronidis on 08/12/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController: UITableViewController {
    
    private let cellId = "cellId"
    
    lazy var fetchResultsController: NSFetchedResultsController<Company> = {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch let fetchError {
            print("Failed to fetch: ", fetchError.localizedDescription)
        }
        
        return frc
    }()
    
    lazy var refControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = .white
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        return rc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.darkblue
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.title = "Company Auto Updates"
        let addBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        let deleteBarButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
        navigationItem.leftBarButtonItems = [addBarButton, deleteBarButton]
        
//        fetchResultsController.fetchedObjects?.forEach({ (company) in
//            print("\(company.name ?? "")")
//        })
        
       
        self.refreshControl = refControl
    }
    
    @objc private func handleAdd() {
        print("Lets add a company called BMW")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = Company(context: context)
        company.name = "Toyota"
        
        do {
            try context.save()
        } catch let saveError {
            print("Failed to save company: ", saveError)
        }
    }
    
    @objc private func handleDelete() {
        print("Handle delete")
        let request: NSFetchRequest<Company> = Company.fetchRequest()
//        request.predicate = NSPredicate(format: "name CONTAINS %@", "p")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        do {
            let companiesWithB = try context.fetch(request)
            companiesWithB.forEach { (company) in
                context.delete(company)
            }
            
            do {
                try context.save()
            } catch let deleteError {
                print("Failed to delete companies: ", deleteError.localizedDescription)
            }
        } catch let fetchError {
            print("Failed to fetch companies: ", fetchError.localizedDescription)
        }
        
        
    }
    
    @objc private func handleRefresh() {
    let service = Service.shared.downloadCompaniesFromServer()
        refControl.endRefreshing()
    }
}

extension CompaniesAutoUpdateController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = CustomHeader()
        label.text = fetchResultsController.sectionIndexTitles[section]
        label.backgroundColor = UIColor.lightBlue
        
        return label
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompanyCell
        let company = fetchResultsController.object(at: indexPath)
        
        cell.company = company
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeesController = EmployeesController()
        employeesController.company = fetchResultsController.object(at: indexPath)
        navigationController?.pushViewController(employeesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension CompaniesAutoUpdateController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
