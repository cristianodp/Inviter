//
//  Usuario.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 21/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation
import SwiftyJSON

class Usuario: NSObject {

    var idUsuario:String?
    var nome:String?
    var AvatarUrl:String?
    var email:String?
    var fone:String?
    var cordenadaX:Float?
    var cordenadaY:Float?
    var ultimoAcesso:String?
    
    override init(){
        
    }
    
    init?(data:[String:Any]){
        
        
        if let value = data["idUsuario"] {
            self.idUsuario = value as? String
        }
        
        
        if let value = data["nome"] {
            self.nome = value as? String
        }
        
        if let value = data["AvatarUrl"] {
            self.AvatarUrl = value as? String
        }
        
        if let value = data["email"] {
            self.email = value as? String
        }
        
        if let value = data["fone"] {
            self.fone = value as? String
        }
        
        
        if let value = data["cordenadaX"] {
            self.cordenadaX = value as? Float ?? 0.0
        }
        
        if let value = data["cordenadaY"] {
            self.cordenadaY = value as? Float ?? 0.0
        }
        
        if let value = data["ultimoAcesso"] {
            self.ultimoAcesso = value as? String
        }
        
        
        
    }

    init?(data:JSON){
        
        if let value = data["idUsuario"].string {
            self.idUsuario = value
        }
        
        
        if let value = data["nome"].string {
            self.nome = value
        }
        
        if let value = data["AvatarUrl"].string {
            self.AvatarUrl = value
        }
        
        if let value = data["email"].string {
            self.email = value
        }
        
        if let value = data["fone"].string {
            self.fone = value
        }
        
        if let value = data["cordenadaX"].float {
            self.cordenadaX = value
        }
        
        if let value = data["cordenadaY"].float {
            self.cordenadaY = value
        }
        
        if let value = data["ultimoAcesso"].string {
            self.ultimoAcesso = value
        }
        
    }
    
    func toDictionary()->  [String : Any]{
        
        let idUsuario = self.idUsuario
        let nome = self.nome
        let AvatarUrl = self.AvatarUrl
        let email = self.email
        let fone = self.fone
        let cordenadaX = self.cordenadaX
        let cordenadaY = self.cordenadaY
        let ultimoAcesso = self.ultimoAcesso
        
        
        let dic = [ "idUsuario": idUsuario ?? ""
            ,"nome": nome ?? ""
            ,"AvatarUrl": AvatarUrl ?? ""
            ,"email": email ?? ""
            ,"fone": fone ?? ""
            ,"cordenadaX": cordenadaX ?? 0.0
            ,"cordenadaY": cordenadaY ?? 0.0
            ,"ultimoAcesso": ultimoAcesso ?? ""
            ] as [String : Any]
        
        
        return dic as  [String : Any]
    }
}
