//
//  CreateEmployeeController.swift
//  iCompanies
//
//  Created by Elias Myronidis on 04/12/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import UIKit
import CoreData

protocol CreateEmployeeControllerDelegate: class {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    weak var delegate: CreateEmployeeControllerDelegate?
    
    
    lazy var lightBlueBackgroundView: UIView = {
        let view = setupLightBlueBackgroundView(height: 50)
        
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
        
        view.backgroundColor = UIColor.darkblue
        
        navigationItem.title = "Create Employee"
        setupCancelButtonInNavBar()
        setupSaveButtonInNavBar(selector: #selector(handleSaveButton))
        
        setupUI()
    }
    
    private func setupUI() {
        
        lightBlueBackgroundView.addSubview(nameLabel)
        lightBlueBackgroundView.addSubview(nameTextField)
        
        nameLabel.topAnchor.constraint(equalTo: lightBlueBackgroundView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: lightBlueBackgroundView.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: lightBlueBackgroundView.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc private func handleSaveButton() {
        guard let employeeName = nameTextField.text else { return }
        CoreDataManager.shared.createEmployee(name: employeeName) { employee, error in
            if let error = error {
                print("Failed to save employee: ", error.localizedDescription)
                return
            }
            
            self.dismiss(animated: true, completion: {
                if let employee = employee {
                    self.delegate?.didAddEmployee(employee: employee)
                }
            })
        }
    }
}
