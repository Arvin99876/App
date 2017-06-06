//
//  AddRestaurantController.swift
//  App
//
//  Created by 康錦豐 on 2017/6/4.
//  Copyright © 2017年 appcoda. All rights reserved.
//

import UIKit
import CoreData

class AddRestaurantController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var typeTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    
    var isVisited = true
    
    var restaurant:RestaurantMo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                imagePicker.delegate = self
                
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
        let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: photoImageView.superview, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: photoImageView.superview, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: photoImageView.superview, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: photoImageView.superview, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        bottomConstraint.isActive = true
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func save(snder: AnyObject) {
        
        if nameTextField.text == "" || typeTextField.text == "" || locationTextField.text == "" {
        let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields in blank, Please note that all fields are required.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        }
        
        print("Name: \(nameTextField.text)")
        print("Type: \(typeTextField.text)")
        print("Location: \(locationTextField.text)")
        print("phone: \(phoneTextField.text)")
        print("Have you been here: \(isVisited)")
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            restaurant = RestaurantMo(context: appDelegate.persistentContainer.viewContext)
            restaurant.name = nameTextField.text
            restaurant.type = typeTextField.text
            restaurant.location = locationTextField.text
            restaurant.phone = phoneTextField.text
            restaurant.isVisited = isVisited
            
            if let restaurantImage = photoImageView.image {
                if let imageData = UIImagePNGRepresentation(restaurantImage) {
                    restaurant.image = NSData(data: imageData)
                }
            }
            print("Saving data to context...")
            appDelegate.saveContext()
        }
        
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func toggleBeenHereButton(sender: UIButton) {
    
    //
    if sender == yesButton {
    isVisited = true
        yesButton.backgroundColor = UIColor(red: 218.0/255, green: 100.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        noButton.backgroundColor = UIColor(red: 218.0/255.0, green: 223.0/255.0, blue: 225.0/255.0, alpha: 1.0)
    } else if sender == noButton {
        isVisited = false
        yesButton.backgroundColor = UIColor(red: 218.0/255.0, green: 223.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        noButton.backgroundColor = UIColor(red: 218.0/255, green: 100.0/255.0, blue: 70.0/255.0, alpha: 1.0)

        }
    }
}
