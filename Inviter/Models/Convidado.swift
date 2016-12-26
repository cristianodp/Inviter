//
//  Participantes.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 03/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation
import SwiftyJSON

class Convidado :NSObject{
    
    //var idConvidado: String?
    var idEvento: String?
    var idPessoa: String?
    var resposta: String?
    var pessoa:Pessoa?
    var evento:Evento?

    override init(){
    
    }
    
    init?(/*idConvidado:String,*/idEvento: String,idPessoa: String,resposta: String){
       // self.idConvidado = idConvidado
        self.idEvento = idEvento
        self.idPessoa = idPessoa
        self.resposta = resposta
        
    }
    
    init?(data:[String:Any]){
        
      /*  if let value = data["idConvidado"] {
            self.idConvidado = value as? String
        }
        */
        if let value = data["idEvento"] {
            self.idEvento = value as? String
        }
        
        if let value = data["idPessoa"] {
            self.idPessoa = value as? String
        
        }
        
        if let value = data["resposta"] {
            self.resposta = value as? String
        }
        
        if let value = data["pessoa"] {
            self.pessoa = Pessoa.init(dataDic: value as! [String : Any] )
            
        }
        
        if let value = data["evento"] {
            self.evento = Evento.init(data: value as! [String : Any])
        }
        
        
        
    }
    
    init?(data:JSON){
       /*
        if let value = data["idConvidado"].string {
            self.idConvidado = value
        }
        */
        if let value = data["idEvento"].string {
            self.idEvento = value
        }
        
        if let value = data["idPessoa"].string {
            self.idPessoa = value
            
        }
        
        if let value = data["resposta"].string {
            self.resposta = value
        }
        
       /* if let value = data["pessoa"] {
            self.pessoa = Pessoa.init(dataJson: value)
            
        }
        
        if let value = data["evento"] {
            self.evento = Evento.init(data: value)
        }
        */
        
        
    }
    
    func toDictionary()->  [String : Any]{
        
        var dic = [String : Any]()
        
       /* if let value = self.idConvidado{
            dic["idConvidado"] = value
        }*/
        
        if let value = self.idEvento{
            dic["idEvento"] = value
        }
        
        if let value = self.idPessoa{
            dic["idPessoa"] = value
        }
        
        if let value = self.resposta{
            dic["resposta"] = value
        }
        
        if let value = self.pessoa?.toDictionary(){
            dic["pessoa"] = value
        }
        
        if let value = self.evento?.toDictionary(){
            dic["evento"] = value
        }
        
        return dic as  [String : Any]
    }
    
        
    
}
