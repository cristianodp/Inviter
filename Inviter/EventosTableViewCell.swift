//
//  EventosTableViewCell.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 29/10/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit

class EventosTableViewCell: UITableViewCell {

    @IBOutlet weak var imageEvento: UIImageView!
    @IBOutlet weak var descricaoLabel: UILabel!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var horarioLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadCell(evento:Evento){
        
        imageEvento.image = UIImage(named: "position")
        descricaoLabel.text = evento.nome
        localLabel.text = evento.local
        horarioLabel.text = evento.getHourString()
        dataLabel.text = evento.getOnlyDataString()
        
    }

}
