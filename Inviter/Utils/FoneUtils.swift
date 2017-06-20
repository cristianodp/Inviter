//
//  FoneUtils.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 23/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation

struct structFone {
    var area:String
    var ddd:String
    var numero:String
    
    init(area:String,ddd:String,numero:String) {
        self.area = area
        self.ddd = ddd
        self.numero = numero
    }
    
    func numeroCompleto()->String{
        return self.area + self.ddd + self.numero
    }
}

class FoneUtils:NSObject{
    
    static func isValid(fone:String)->Bool{
        if fone.characters.count >= 13{
            return true
        }else{
            return false
        }
    }
    
    static func NumeroFone(fone:String) -> structFone {
        
        var numeroFone = fone.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "")
        var codigos = ""
        var count = numeroFone.characters.count
        
        var numero = ""
        
        if count == 8 {
            
            let posIni = count - 8
            numero = numeroFone.substring(with: posIni..<count)
            
        }
        
        if count > 8 {
            let posIni = count - 8
            
            if numeroFone.substring(with: posIni-1..<posIni).isEqual("9"){
                numero = numeroFone.substring(with: posIni-1..<count)
                codigos = numeroFone.substring(with: 1..<posIni-1)
            }else{
                numero = numeroFone.substring(with: posIni..<count)
                codigos = numeroFone.substring(with: 1..<posIni)
            }
            
        }
        
        count = codigos.characters.count
        var ddd = ""
        var area = ""
        
        if count >= 5 {
            let posIni = count - 2
            ddd = codigos.substring(with: posIni..<count)
            
            area = numeroFone.substring(with: 1..<posIni-1)
        }else{
            let posIni = count - 2
            ddd = codigos.substring(with: posIni..<count)
            
            area = "+55"
            
        }
        
        return structFone(area: area, ddd: ddd, numero: numero)
    }
    
    
    static func retornaDDD(fone:String)->String{
        let numeroFone = FoneUtils.NumeroFone(fone: fone)
        
        return numeroFone.ddd
    }
    
    
    static func retornaCodigoArea(fone:String)->String{
        let numeroFone = FoneUtils.NumeroFone(fone: fone)
        
        return numeroFone.area
    }
    
    static func retornaNumero(fone:String)->String{
        let numeroFone = FoneUtils.NumeroFone(fone: fone)
        
        return numeroFone.numero
    }
    
    static func retornaNumeroCompleto(fone:String)->String{
        let numeroFone = FoneUtils.NumeroFone(fone: fone)
        
        return numeroFone.numeroCompleto()
    }

    
}
