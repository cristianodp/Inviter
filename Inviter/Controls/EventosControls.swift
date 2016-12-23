//
//  EventosControls.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 07/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation
import Firebase


class EventosControls :NSObject{
   
    var ref : FIRDatabaseReference!
    var refHandler : UInt!
    
    override init() {
        ref = FIRDatabase.database().reference()
    }
    
    func AddEvento(){
    
    }
    
    func AddConvidado(idEvento:String,convidado:Contato){
        
        self.ref.child("Eventos").child(idEvento).child("Participantes").child(eventoId).setValue(eventoId)
        
        
        
    }

}
