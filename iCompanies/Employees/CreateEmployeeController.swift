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
    var company: Company?
    
    lazy var lightBlueBackgroundView: UIView = {
        let view = setupLightBlueBackgroundView(height: 150)
        
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
    
    lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "dd//MM/yyyy"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var employeeTypeSegmentedControl: UISegmentedControl = {
        let types = [EmployeeType.Executive.rawValue, EmployeeType.SeniorManagement.rawValue, EmployeeType.Staff.rawValue]
        let segmentedControl = UISegmentedControl(items: types)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.darkblue
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
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
        lightBlueBackgroundView.addSubview(birthdayLabel)
        lightBlueBackgroundView.addSubview(birthdayTextField)
        lightBlueBackgroundView.addSubview(employeeTypeSegmentedControl)
        
        nameLabel.topAnchor.constraint(equalTo: lightBlueBackgroundView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: lightBlueBackgroundView.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: lightBlueBackgroundView.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayLabel.leadingAnchor.constraint(equalTo: lightBlueBackgroundView.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true
        birthdayTextField.leadingAnchor.constraint(equalTo: birthdayLabel.trailingAnchor).isActive = true
        birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
        birthdayTextField.trailingAnchor.constraint(equalTo: lightBlueBackgroundView.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
        employeeTypeSegmentedControl.leadingAnchor.constraint(equalTo: lightBlueBackgroundView.leadingAnchor, constant: 16).isActive = true
        employeeTypeSegmentedControl.trailingAnchor.constraint(equalTo: lightBlueBackgroundView.trailingAnchor, constant: -16).isActive = true
        employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
    
    @objc private func handleSaveButton() {
        guard let employeeName = nameTextField.text else { return }
        guard let company = company else { return }
        guard let birthdayText = birthdayTextField.text else { return }
        
        if birthdayText.isEmpty {
            showError(title: "Birthday Error", message: "Please enter a birthday")
        } else {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd/MM/yyyy"
            
            guard let birthdayDate = dateFormater.date(from: birthdayText) else {
                showError(title: "Wrong Birthday Format", message: "Please enter a valid birthday format")
                return
            }
            
            guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else { return }
            
            CoreDataManager.shared.createEmployee(name: employeeName, birthday: birthdayDate, employeeType: employeeType, company: company) { employee, error in
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
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
