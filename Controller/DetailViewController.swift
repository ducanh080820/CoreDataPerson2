//
//  ViewController.swift
//  CoreDataPerson2
//
//  Created by Duc Anh on 11/28/18.
//  Copyright © 2018 Duc Anh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textAge: UITextField!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textName.delegate = self
        if let dataObject = person {
            textName.text = dataObject.name
            textAge.text = String(dataObject.age)
            myImage.image = dataObject.image as? UIImage
        }
        updateSaveBtnStage()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveBtn.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveBtnStage()
         navigationItem.title = textField.text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //loai bo bo chon neu nguoi dung an huy
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        guard let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        
        myImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        textName.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveData(_ sender: UIBarButtonItem) {
        guard let name = textName.text else {return}
        guard let age = textAge.text else {return}
        guard let image = myImage.image else {return}
        if person == nil {
            person = Person(context: (DataServices.shared.fetchedResultsController.managedObjectContext))
        }
        person?.name = name
        person?.age = Int64(Int(age) ?? 0)
        person?.image = image
        
        DataServices.shared.saveData()
        navigationController?.popViewController(animated: true)
    }
    
    func updateSaveBtnStage() {
        let text = textName.text ?? ""
        saveBtn.isEnabled = !text.isEmpty
    }
    
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value)})
}

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
