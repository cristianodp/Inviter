//
//  Evento.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 28/10/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation

class Evento :NSObject{
    
    var idEvento: String?
    var nome: String?
    var local:String?
    var data:Date?
    
    func loadValues(data:[String:Any]){
        
        if let value = data["idEvento"] {
            self.idEvento = value as? String
        }
        
        if let value = data["nome"] {
            self.nome = value as? String
        }
        
        if let value = data["local"] {
            self.local = value as? String
        }
        
        if let value = data["data"] {
            self.setDataString(dataString: (value as? String)!)
        }
    
    }
    
    func setDataString(dataString:String){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.date(from: dataString)
        self.data = formatter.date(from: dataString)!
    }
    
    
    func getDataString() -> String?{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        //"EEEE MMMM dd, aaaa 'at' HH:mm um zz"
        //formatter.date(from: dataString)
        //formatter.date(from: dataString)!
        if let data = self.data{
            return formatter.string(from: data)
        }else{
            return nil
        }
        
    }
    
    
    func getHourString() -> String?{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        //"EEEE MMMM dd, aaaa 'at' HH:mm um zz"
        //formatter.date(from: dataString)
        //formatter.date(from: dataString)!
        if let data = self.data{
            return formatter.string(from: data)
        }else{
            return nil
        }
        
    }
    
    func getOnlyDataString() -> String?{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        //"EEEE MMMM dd, aaaa 'at' HH:mm um zz"
        //formatter.date(from: dataString)
        //formatter.date(from: dataString)!
        if let data = self.data{
            return formatter.string(from: data)
        }else{
            return nil
        }
        
    }

    
    func toDictionary()->  [String : Any]{
        
        let id = self.idEvento!
        let nome = self.nome!
        let local = self.local!
        let data:String = getDataString()!
        
        let dic = [ "idEvento": id
            ,"nome": nome
            ,"local": local
            ,"data": data
            ] as [String : Any]
        
        
        return dic as  [String : Any]
    }
    
    
}
