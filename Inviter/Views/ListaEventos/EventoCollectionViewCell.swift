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
    
    func loadRow(evento:Evento){
        self.evento = evento
        
        if let value = evento.nome {
            tituloEvento.text = value
        }
        
        if let value = evento.local{
            localEvento.text = value
        }
        
        if let value = evento.getDataString() {
            dataEvento.text = value
        }
        
        if let value = evento.getHourString() {
            horarioEvento.text = value
        }
        /*
        
        if let value = dic["imagemEvento"]{
            imagemEvento.image =  .text = value
        }
         */
        
    }
    
    @IBAction func simAction(_ sender: Any) {
        
    }
    
    @IBAction func talvezAction(_ sender: Any) {
        
    }
    
    @IBAction func naoAction(_ sender: Any) {
        
    }

    
    
}
