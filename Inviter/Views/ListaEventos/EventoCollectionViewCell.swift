//
//  EventoCollectionViewCell.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 03/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit

class EventoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tituloEvento: UILabel!
    @IBOutlet weak var localEvento: UILabel!
    @IBOutlet weak var dataEvento: UILabel!
    @IBOutlet weak var horarioEvento: UILabel!
    @IBOutlet weak var imagemEvento: UIImageView!
    @IBOutlet weak var simButton: UIButton!
    @IBOutlet weak var talvezButton: UIButton!
    @IBOutlet weak var naoButton: UIButton!
    
    var evento:Evento?
    
    var fb:FirebaseData = FirebaseData()

    @IBAction func simAction(_ sender: Any) {
        let idEvento = self.evento?.idEvento
        let idPessoa = fb.getUsuarioLogado()?.uid
        
        fb.add(idEvento: idEvento!, idPessoa: idPessoa!, resposta: "SIM")
    }
    
    @IBAction func talvezAction(_ sender: Any) {
        let idEvento = self.evento?.idEvento
        let idPessoa = fb.getUsuarioLogado()?.uid
        
        fb.add(idEvento: idEvento!, idPessoa: idPessoa!, resposta: "TALVEZ")

    }
    
    
    @IBAction func naoAction(_ sender: Any) {
        let idEvento = self.evento?.idEvento
        let idPessoa = fb.getUsuarioLogado()?.uid
        
        fb.add(idEvento: idEvento!, idPessoa: idPessoa!, resposta: "NAO")

    }

    func loadRow(evento:Evento){
        self.evento = evento
        
        if let value = evento.nome {
            tituloEvento.text = value
        }
        
        if let value = evento.local{
            localEvento.text = value
        }
        
        dataEvento.text = evento.getDateFormated()
        
        if let value = evento.getHourString() {
            horarioEvento.text = value
        }
        
        if evento.isOldest(){
            
            self.alpha = 0.5
        }else{
           self.alpha = 1.0
        }
        
        
        fb.observeResposta(idEvento: evento.idEvento!, idPessoa: (fb.getUsuarioLogado()?.uid)!) { (snapshot) in
            
            
            
            if let resp = snapshot.value{
            
                if (resp as! String).isEqual("CONVIDADO"){
                    self.simButton.backgroundColor = nil
                    self.naoButton.backgroundColor = nil
                    self.talvezButton.backgroundColor = nil
                }
            
                if (resp as! String).isEqual("TALVEZ"){
                    self.simButton.backgroundColor = nil
                    self.naoButton.backgroundColor = nil
                    self.talvezButton.backgroundColor = UIColor.yellow
                }
            
                if (resp as! String).isEqual("SIM"){
                    self.simButton.backgroundColor = UIColor.yellow
                    self.naoButton.backgroundColor = nil
                    self.talvezButton.backgroundColor = nil
                    
                }
            
                if (resp as! String).isEqual("NAO"){
                    self.simButton.backgroundColor = nil
                    self.naoButton.backgroundColor = UIColor.yellow
                    self.talvezButton.backgroundColor = nil
                }
                
            }
            
            
        }
        
        
    }

    
    
}
