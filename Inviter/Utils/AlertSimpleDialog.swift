//
//  AlertSimpleDialog.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 25/10/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation
import UIKit

class AlertSimpleDialog{
    
    static func show( sender :UIViewController, title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel  , handler: nil)
        alertController.addAction(defaultAction)
        sender.present(alertController, animated: true, completion: nil)
    }
    
    static func show( sender :UIViewController, title:String,message:String,handler:((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler:handler ) 
        
        alertController.addAction(defaultAction)
        sender.present(alertController, animated: true, completion: nil)
        
    }
}
