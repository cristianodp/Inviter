//
//  ContatoViewController.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 08/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit
import DigitsKit


class ContatoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authenticateButton = DGTAuthenticateButton { session, error in
            if session != nil {
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)  {
                    self.uploadDigitsContacts(session: session!)
                }
            }
        }
        authenticateButton?.center = self.view.center
        self.view.addSubview(authenticateButton!)


        // Do any additional setup after loading the view.
    }
        
    private func uploadDigitsContacts(session: DGTSession) {
        let digitsContacts = DGTContacts(userSession: session)
        digitsContacts?.startUpload { result, error in
            if result != nil {
                // The result object tells you how many of the contacts were uploaded.
                print("Total contacts: \(result?.totalContacts), uploaded successfully: \(result?.numberOfUploadedContacts)")
            }
            self.findDigitsFriends(session: session)
        }
    }
    
    private func findDigitsFriends(session: DGTSession) {
        let digitsContacts = DGTContacts(userSession: session)
        // looking up friends happens in batches. Pass nil as cursor to get the first batch.
        digitsContacts?.lookupContactMatches(withCursor: nil) { (matches, nextCursor, error) -> Void in
            // If nextCursor is not nil, you can continue to call lookupContactMatchesWithCursor: to retrieve even more friends.
            // Matches contain instances of DGTUser. Use DGTUser's userId to lookup users in your own database.
            print("Friends:")
            for digitsUser in matches! {
                print("Digits ID: \((digitsUser as AnyObject).userID as String )")
            }
            // Show the alert on the main thread
            DispatchQueue.main.async {
                let message = "\(matches?.count) friends found!"
                let alertController = UIAlertController(title: "Lookup complete", message: message, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "OK", style: .cancel, handler:nil)
                alertController.addAction(cancel)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
