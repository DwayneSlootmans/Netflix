//
//  ViewController.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 25/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtFavoriteActor: UITextField!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFavoriteActor: UILabel!
    
    var user:User?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        user = User.getCurrentUserDetails()
        if user != nil {
            txtUserName.text = user!.userName
            txtFavoriteActor.text = user!.favoriteActor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

