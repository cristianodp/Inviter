//
//  Participantes.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 03/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation
import SwiftyJSON
class Participante :NSObject{
    
    var idParticipante: String?
    var idEvento: String?
    var idContato: String?
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
        
        if let value = data["idContato"] {
            self.idContato = value as? String
        }
        
        if let value = data["resposta"] {
            self.resposta = value as? String
        }
        
    }
    
    func loadValues(data:JSON){
        
        if let value = data["idParticipante"].string {
            self.idParticipante = value
        }
        
        if let value = data["idEvento"].string  {
            self.idEvento = value
        }
        
        if let value = data["idContato"].string  {
            self.idContato = value
        }
        
        if let value = data["resposta"].string  {
            self.resposta = value 
        }
        
    }
    
    func toDictionary()->  [String : Any]{
        
        let idParticipante = self.idParticipante!
        let idEvento = self.idEvento!
        let idContato = self.idContato!
        let resposta = self.resposta!
        
        let dic = [ "idParticipante": idParticipante
            ,"idEvento": idEvento
            ,"idContato": idContato
            ,"resposta": resposta
            ] as [String : Any]
        
        
        return dic as  [String : Any]
    }
    
    
}
