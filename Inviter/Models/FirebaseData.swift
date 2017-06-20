//
//  FirebaseData.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 24/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation
import Firebase

class FirebaseData{
    
    var ref : FIRDatabaseReference!
    var refHandler : UInt!
    
    init() {
        ref = FIRDatabase.database().reference()
    }
    
    func add(pessoa:Pessoa)
    {
        ref.child("AppData").child("Pessoas").child(pessoa.id!).child("Pessoa").setValue(pessoa.toDictionary())
        add(fone: pessoa.fone!, idPessoa: pessoa.id!)
    }
    
    func add(evento:Evento,convidados:[Convidado])
    {
        ref.child("AppData").child("Eventos").child(evento.idEvento!).child("Evento").setValue(evento.toDictionary())
        
        for item in convidados{
            add(convidado: item, evento: evento)
        }
        
    }
    
    
    func add(convidado:Convidado,evento:Evento)
    {
        ref.child("AppData").child("Eventos").child(convidado.idEvento!).child("Convidados").child(convidado.idPessoa!).setValue(convidado.toDictionary())
        
        ref.child("AppData").child("Pessoas").child(convidado.idPessoa!).child("Eventos").child(convidado.idEvento!).child("Evento").setValue(evento.toDictionary())
    }
    
    func add(idEvento:String,idPessoa:String, resposta:String ){
        
        ref.child("AppData").child("Eventos").child(idEvento).child("Convidados").child(idPessoa).child("resposta").setValue(resposta)
        
    }
    
    
    func add(fone:String,idPessoa:String){
        let index = IndexFone.init(idPessoa: idPessoa, fone: fone)
        ref.child("AppData").child("indexesFone").child(fone).child("indexFone").setValue(index?.toDictionary())
    }
    
    func observeEventosWhere(idPessoa:String,with: @escaping (FIRDataSnapshot)->Void ){
        
        ref.child("AppData").child("Pessoas").child(idPessoa).child("Eventos").observe(.childAdded, with: with)
        
    }
    
    func observeEventos(idPessoa:String,with: @escaping (FIRDataSnapshot)->Void ){
        
        ref.child("AppData").child("Pessoas").child(idPessoa).child("Eventos").observe(.childAdded, with: with)
        
    }
    
    func observeEventosChanged(idPessoa:String,with: @escaping (FIRDataSnapshot)->Void ){
        
        ref.child("AppData").child("Pessoas").child(idPessoa).child("Eventos").observe(.childChanged, with: with)
        
    }
    
    
    func observePessoa(idPessoa:String, with: @escaping (FIRDataSnapshot)->Void ){
        
        ref.child("AppData").child("Pessoas").child(idPessoa).child("Pessoa").observe(.value, with: with)
        
    }
    
    
    func observe(idEvento:String, with: @escaping (FIRDataSnapshot)->Void ){
        
        ref.child("AppData").child("Eventos").child(idEvento).child("Evento").observe(.value, with: with)
        
    }
       
    func observeConvidados(idEvento:String, with: @escaping (FIRDataSnapshot)->Void ){
        
        ref.child("AppData").child("Eventos").child(idEvento).child("Convidados").observe(.childAdded, with: with)
        
    }
    
    func observeIndex(fone:String, with: @escaping (FIRDataSnapshot)->Void ){
        
        ref.child("AppData").child("indexesFone").child(fone).child("indexFone").observe(.value, with: with)
        
    }
    
    func getUsuarioLogado() -> FIRUser?{
        
        return FIRAuth.auth()?.currentUser
    
    }
    
    func getNewId()->String{
        return ref.childByAutoId().key
    }
    
    func observeResposta(idEvento:String,idPessoa:String, with: @escaping (FIRDataSnapshot)->Void ){
        
        ref.child("AppData").child("Eventos").child(idEvento).child("Convidados").child(idPessoa).child("resposta").observe(.value, with: with)
        
    }
    
    func addConvidadoSemUsuario(evento:Evento,contato:Pessoa){
        let currentUser = getUsuarioLogado()
        
        contato.fone = FoneUtils.retornaNumeroCompleto(fone: contato.fone!)

        let email  = contato.fone!+"@inviter.com.br"
        let passwd = contato.fone
        
        FIRAuth.auth()?.createUser(withEmail: email, password: passwd!, completion: {(user, error) in
            
            if error == nil {
                
                contato.id = user?.uid
                
                self.add(pessoa: contato)
                let convidado = Convidado.init(idEvento: evento.idEvento!, idPessoa: contato.id!, resposta: "CONVIDADO")
                
                self.add(convidado: convidado!, evento: evento)
                
                
                self.loginUserFirebase(email: (currentUser?.email)!, passwd: (currentUser?.email?.replacingOccurrences(of: "@inviter.com.br", with: ""))!)
                
            }
            
        })

        
    }
    
    
    func loginUserFirebase(email:String,passwd:String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: passwd , completion: { (user, error) in
            
            if error == nil {
                
            }
        })
    }
    
    
    func logOutFirebase(){
        do{
           try FIRAuth.auth()?.signOut()
        }catch _ {
        
        }
    }
    
    
    
}
