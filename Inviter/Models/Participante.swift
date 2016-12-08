//
//  Participantes.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 03/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation

class Participante :NSObject{
    
    var idParticipante: String?
    var idEvento: String?
    var idUsuario: String?
    var resposta: String?
   
    func getParticipante() -> Contato?{
        return nil
    }
    
    func loadValues(data:[String:Any]){
        
        if let value = data["idParticipante"] {
            self.idParticipante = value as? String
        }
        
        if let value = data["idEvento"] {
            self.idEvento = value as? String
        }
        
        if let value = data["idUsuario"] {
            self.idUsuario = value as? String
        }
        
        if let value = data["resposta"] {
            self.resposta = value as? String
        }
        
    }
    
    func toDictionary()->  [String : Any]{
        
        let idParticipante = self.idParticipante!
        let idEvento = self.idEvento!
        let idUsuario = self.idUsuario!
        let resposta = self.resposta!
        
        let dic = [ "idParticipante": idParticipante
            ,"idEvento": idEvento
            ,"idUsuario": idUsuario
            ,"resposta": resposta
            ] as [String : Any]
        
        
        return dic as  [String : Any]
    }
    
}
