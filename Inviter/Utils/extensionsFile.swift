//
//  extensionsFile.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 20/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

extension String {
    
    func isEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]+$", options: NSRegularExpression.Options.caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
        } catch { return false }
    }
    
}

extension Image {
    
    func loadImage(fromUrl:String)->Image?{
        var imgReturn:Image?
        Alamofire.request(fromUrl).responseImage(completionHandler: { (response) in
            
            if let img = response.result.value {
                imgReturn = img
            }
            
        })
        return imgReturn
    }

}
