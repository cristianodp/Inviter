//
//  Person.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 23/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation
import SwiftyJSON

class Person: NSObject {
    
    var id:String?
    var name:String?
    var avatarUrl:String?
    var email:String?
    var phone:String?
    
    public override init() {
        
    }
    
    public init?(dataDic:[String:Any]){
        
        
        if let value = dataDic["id"] {
            self.id = value as? String
        }
        
        
        if let value = dataDic["name"] {
            self.name = value as? String
        }
        
        if let value = dataDic["avatarUrl"] {
            self.avatarUrl = value as? String
        }
        
        if let value = dataDic["email"] {
            self.email = value as? String
        }
        
        
        if let value = dataDic["phone"] {
            self.phone = value as? String
        }
    }
    
    public init?(dataJson:JSON){
        
        if let value = dataJson["id"].string {
            self.id = value
        }
        
        
        if let value = dataJson["name"].string {
            self.name = value
        }
        
        if let value = dataJson["avatarUrl"].string {
            self.avatarUrl = value
        }
        
        if let value = dataJson["email"].string {
            self.email = value
        }
        
        
        if let value = dataJson["phone"].string {
            self.phone = value
        }
    }
    
    public func toDictionary()->  [String : Any]{
        
        var dic = [String : Any]()
        
        if let value = self.id{
            dic["id"] = value
        }
        
        if let value = self.name{
            dic["name"] = value
        }
        
        if let value = self.avatarUrl{
            dic["avatarUrl"] = value
        }
        
        if let value = self.email{
            dic["email"] = value
        }
        
        if let value = self.phone{
            dic["phone"] = value
        }
        
        
        return dic as  [String : Any]
    }


}
