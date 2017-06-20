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
    
    func index(from: Int) -> Index {
        if from < 0 {
            return self.index(from: 0)
        }
        do{
            let ret = try self.index(startIndex, offsetBy: from)
            return ret
        }catch{
            return self.index(from: 0)
        }
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
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
