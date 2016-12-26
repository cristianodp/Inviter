//
//  FoneUsuario.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 23/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation
import SwiftyJSON

class FoneUsuario: NSObject {
    var fone:String?
    var idUsuario:String?
    
    
    public init?(dataDic:[String:Any]){
        
        
        if let value = dataDic["fone"] {
            self.fone = value as? String
        }
        
        
        if let value = dataDic["idUsuario"] {
            self.idUsuario = value as? String
        }
        
           }
    
    public init?(dataJson:JSON){
        
        if let value = dataJson["fone"].string {
            self.fone = value
        }
        
        if let value = dataJson["idUsuario"].string {
            self.idUsuario = value
        }
        
        
    }
    
    public func toDictionary()->  [String : Any]{
        
        var dic = [String : Any]()
        
        if let value = self.fone{
            dic["fone"] = value
        }
        
        if let value = self.idUsuario{
            dic["idUsuario"] = value
        }
        
        
        return dic as  [String : Any]
    }
    
    
}
