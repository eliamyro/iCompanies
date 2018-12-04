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
            
            guard let companyImageData = company?.imageData else { return }
            companyImageView.image = UIImage(data: companyImageData)
            setupCircularImageStyle()
        }
    }
    
    lazy var lightBlueBackgroundView: UIView = {
        let view = setupLightBlueBackgroundView(height: 350)
        
        return view
    }()
    
    
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "select_photo_empty"))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
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
        
        setupCancelButtonInNavBar()
        setupSaveButtonInNavBar(selector: #selector(handleSave))
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    private func setupUI() {
        lightBlueBackgroundView.addSubview(companyImageView)
        lightBlueBackgroundView.addSubview(nameLabel)
        lightBlueBackgroundView.addSubview(nameTextField)
        lightBlueBackgroundView.addSubview(datePicker)
        
        companyImageView.topAnchor.constraint(equalTo: lightBlueBackgroundView.topAnchor, constant: 8).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: lightBlueBackgroundView.centerXAnchor).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: lightBlueBackgroundView.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: lightBlueBackgroundView.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: lightBlueBackgroundView.leadingAnchor, constant: 8).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor, constant: 8).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: lightBlueBackgroundView.trailingAnchor, constant: 8).isActive = true
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
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company.setValue(imageData, forKey: "imageData")
        }
        
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
        
        if let companyImage = companyImageView.image {
            company?.imageData = companyImage.jpegData(compressionQuality: 0.8)
        }
        
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
    
    private func setupCircularImageStyle() {
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = UIColor.darkblue.cgColor
        companyImageView.layer.borderWidth = 2
    }
}

extension CreateCompanyController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        
        setupCircularImageStyle()
        
        dismiss(animated: true, completion: nil)
    }
}
