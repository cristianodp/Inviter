//
//  Usuario.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 21/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation
import SwiftyJSON

class Usuario: Person {

    var cordenadaX:Float?
    var cordenadaY:Float?
    var ultimoAcesso:String?
    
    override init() {
        super.init()
    }
    
    override init?(dataDic:[String:Any]){
        
        super.init(dataDic: dataDic)
        
        if let value = dataDic["cordenadaX"] {
            self.cordenadaX = value as? Float
        }
        
        if let value = dataDic["cordenadaY"] {
            self.cordenadaY = value as? Float
        }
        
        if let value = dataDic["ultimoAcesso"] {
            self.ultimoAcesso = value as? String
        }
        
        
        
    }

    override init?(dataJson:JSON){
        
        super.init(dataJson: dataJson)
        
        
        if let value = dataJson["cordenadaX"].float {
            self.cordenadaX = value
        }
        
        if let value = dataJson["cordenadaY"].float {
            self.cordenadaY = value
        }
        
        if let value = dataJson["ultimoAcesso"].string {
            self.ultimoAcesso = value
        }
        
    }
    
    override func toDictionary()->  [String : Any]{
        
        var dic = super.toDictionary()
        
        let cordenadaX = self.cordenadaX  ?? 0.0
        let cordenadaY = self.cordenadaY ?? 0.0
        let ultimoAcesso = self.ultimoAcesso ?? ""
        
        dic["cordenadaX"] = cordenadaX
        dic["cordenadaY"] = cordenadaY
        dic["ultimoAcesso"] = ultimoAcesso
        
        
        return dic as  [String : Any]
    }
}
