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
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    weak var delegate: CreateCompanyControllerDelegate?
    
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
            
            guard let founded = company?.founded else { return }
            datePicker.date = founded
        }
    }
    
    lazy var lighBlueBackgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .lightBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "select_photo_empty"))
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return imageView
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
    
    lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.translatesAutoresizingMaskIntoConstraints = false
        
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    private func setupUI() {
        view.addSubview(lighBlueBackgroundView)
        lighBlueBackgroundView.addSubview(companyImageView)
        lighBlueBackgroundView.addSubview(nameLabel)
        lighBlueBackgroundView.addSubview(nameTextField)
        lighBlueBackgroundView.addSubview(datePicker)
        
        lighBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lighBlueBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lighBlueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lighBlueBackgroundView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        companyImageView.topAnchor.constraint(equalTo: lighBlueBackgroundView.topAnchor, constant: 8).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: lighBlueBackgroundView.centerXAnchor).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.layer.cornerRadius = 100 / 2
        companyImageView.layer.masksToBounds = true
        
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: lighBlueBackgroundView.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: lighBlueBackgroundView.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: lighBlueBackgroundView.leadingAnchor, constant: 8).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lighBlueBackgroundView.bottomAnchor, constant: 8).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: lighBlueBackgroundView.trailingAnchor, constant: 8).isActive = true
    }
    
    @objc private func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSave() {
        if company == nil {
            saveCompany()
        } else {
            updateCompany()
        }
    }
    
    private func saveCompany() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        
        do {
            try context.save()
            self.dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
        } catch let saveError {
            print("Failed to save company:", saveError)
        }
    }
    
    private func updateCompany() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        
        do {
            try context.save()
            self.dismiss(animated: true) {
                self.delegate?.didEditCompany(company: self.company!)
            }
        } catch let editError {
            print("Failed to edit company: ", editError)
        }
    }
    
    @objc private func handleSelectPhoto() {
        print("Handle select photo")
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

extension CreateCompanyController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
}
