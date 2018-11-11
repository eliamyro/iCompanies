//
//  CreateCompanyController.swift
//  iCompanies
//
//  Created by Elias Myronidis on 07/11/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate: class {
    func didAddCompany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    weak var delegate: CreateCompanyControllerDelegate?
    
    lazy var lighBlueBackgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .lightBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField =  UITextField()
        textField.placeholder = "Enter Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(lighBlueBackgroundView)
        lighBlueBackgroundView.addSubview(nameLabel)
        lighBlueBackgroundView.addSubview(nameTextField)
        
        lighBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lighBlueBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lighBlueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lighBlueBackgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: lighBlueBackgroundView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: lighBlueBackgroundView.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: lighBlueBackgroundView.bottomAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: lighBlueBackgroundView.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc private func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSave() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(nameTextField.text, forKey: "name")
        
        do {
            try context.save()
            self.dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
        } catch let saveError {
            print("Failed to save company:", saveError)
        }
    }
}
