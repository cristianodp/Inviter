//
//  indexFone.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 24/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation
import SwiftyJSON

class IndexFone :NSObject{
    var idPessoa: String?
    var fone: String?
    
    
    init?(idPessoa: String,fone: String){

        self.idPessoa = idPessoa
        self.fone = fone
        
    }
    
    init?(data:[String:Any]){
        
        if let value = data["idPessoa"] {
            self.idPessoa = value as? String
        }
        
        if let value = data["fone"] {
            self.fone = value as? String
        }
        
    }
    
    init?(data:JSON){
        
        if let value = data["idPessoa"].string {
            self.idPessoa = value
        }
        
        if let value = data["fone"].string {
            self.fone = value
        }
        
    }
    
    func toDictionary()->  [String : Any]{
        
        var dic = [String : Any]()
      
        if let value = self.idPessoa{
            dic["idPessoa"] = value
        }
        
        if let value = self.fone{
            dic["fone"] = value
        }
      
        return dic as  [String : Any]
    }
    
    
    
}

