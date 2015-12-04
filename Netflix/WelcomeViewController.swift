//
//  ViewController.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 25/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//

import UIKit

/*
/ Because this is such a small project I decided to just reuse this view controller for the 2 views in the storyboard.
/ I weighed the amount of work needed to show/hide the tabbar and decided to just duplicate the view in the storyboard, even though 
/ that is a duplication and not good for later changes.
*/

class WelcomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate {
    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtFavoriteActor: UITextField!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFavoriteActor: UILabel!
    
    private var user:User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        
        // Fetch user from DB and show details if present
        user = NetflixDataManager.sharedManager.getCurrentUserDetails()
        if let currentUser = user {
            txtUserName.text = currentUser.userName
            txtFavoriteActor.text = currentUser.favoriteActor
            if let profilePicture = currentUser.profilePicture {
                self.imageViewAvatar.image = UIImage(data: profilePicture)
            }
        }
        imageViewAvatar.layer.cornerRadius = imageViewAvatar.frame.width / 2
        imageViewAvatar.clipsToBounds = true
        imageViewAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageViewAvatarTapped"))
    }
    
    func imageViewAvatarTapped() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
            }
            alertController.addAction(cancelAction)
            
            let photoLibraryAction = UIAlertAction(title: "Photo Libary", style: UIAlertActionStyle.Default) { (action) in
                picker.sourceType = .SavedPhotosAlbum
                self.presentViewController(picker, animated: true, completion: nil)
            }
            alertController.addAction(photoLibraryAction)
            
            let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default) { (action) in
                picker.sourceType = .Camera
                self.presentViewController(picker, animated: true, completion: nil)
            }
            alertController.addAction(takePhotoAction)
            
            self.presentViewController(alertController, animated: true) {}
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK: inputValidations
    
    private func inputIsValid() -> Bool {
        var result = false
        if let userName = txtUserName.text {
            if userName.isEmpty {
                lblUserName.textColor = UIColor.redColor()
            } else {
                lblUserName.textColor = UIColor.blackColor()
                result = true
            }
        }
        if let favoriteActor = txtFavoriteActor.text {
            if favoriteActor.isEmpty {
                lblFavoriteActor.textColor = UIColor.redColor()
            } else {
                lblFavoriteActor.textColor = UIColor.blackColor()
                result = true
            }
        }
        return result
    }
    
    private func saveSettings() {
        user?.userName = txtUserName.text
        user?.favoriteActor = txtFavoriteActor.text
        NetflixCoreDataStack.sharedInstance.saveContext()
        self.dismissKeyboard()
    }
    
    //MARK: UIImagePicker
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageViewAvatar.image = info[UIImagePickerControllerEditedImage] as? UIImage
        if let currentUser = self.user {
            currentUser.profilePicture = UIImagePNGRepresentation(imageViewAvatar.image!);
            NetflixCoreDataStack.sharedInstance.saveContext()
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Navigation
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        inputIsValid()
        self.saveSettings()
    }
    
    @IBAction func enterButtonTapped(sender: UIButton) {
        if inputIsValid() {
            performSegueWithIdentifier("welcomeToHomeSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "welcomeToHomeSegue" {
            user?.userName = txtUserName.text
            user?.favoriteActor = txtFavoriteActor.text
            NetflixCoreDataStack.sharedInstance.saveContext()
            
            if let homeViewController = segue.destinationViewController as? HomeViewController {
                homeViewController.currentUser = user
            }
        }
    }
    
    //MARK: - TabbarController Delegate
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if let _ = viewController as? UINavigationController {
            if inputIsValid() {
                self.saveSettings()
                return true
            }
        }
        if let _ = viewController as? WelcomeViewController {
            return true
        }
        return false
    }
}

