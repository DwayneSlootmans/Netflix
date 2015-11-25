//
//  HomeViewController.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 25/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var currentUser:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentUser == nil {
            currentUser = User.getCurrentUserDetails()
        }
        self.title = currentUser?.favoriteActor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
