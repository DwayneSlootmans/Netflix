//
//  ViewController.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 25/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtFavoriteActor: UITextField!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFavoriteActor: UILabel!
    
    var user:User?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch user from DB and show details if present
        user = User.getCurrentUserDetails()
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
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
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
    
    @IBAction func enterButtonTapped(sender: UIButton) {
        if let userName = txtUserName.text {
            if userName.isEmpty {
                // Show something
                lblUserName.textColor = UIColor.redColor()
            } else {
                lblUserName.textColor = UIColor.blackColor()
                if let favoriteActor = txtFavoriteActor.text {
                    if favoriteActor.isEmpty {
                        // Show something
                        lblFavoriteActor.textColor = UIColor.redColor()
                    } else {
                        lblFavoriteActor.textColor = UIColor.blackColor()
                        performSegueWithIdentifier("welcomeToHomeSegue", sender: self)
                    }
                } else {
                    lblFavoriteActor.textColor = UIColor.redColor()
                }
            }
        } else {
            lblUserName.textColor = UIColor.redColor()
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
}

