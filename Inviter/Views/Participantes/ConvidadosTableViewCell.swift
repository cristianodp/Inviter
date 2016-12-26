//
//  ConvidadosTableViewCell.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 23/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit

class ConvidadosTableViewCell: UITableViewCell {
    // outlets
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var contactPhoneLabel: UILabel!
    @IBOutlet weak var contactSelectedImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCircularAvatar() {
        contactImageView.layer.cornerRadius = contactImageView.bounds.size.width / 2.0
        contactImageView.layer.masksToBounds = true
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setCircularAvatar()
    }
    
    func configureWithContactEntry(_ convidado: Convidado) {
        contactNameLabel.text = convidado.pessoa?.nome
        contactEmailLabel.text = convidado.pessoa?.email ?? ""
        contactPhoneLabel.text = convidado.pessoa?.fone ?? ""
        if let image = convidado.pessoa?.image{
            contactImageView.image = image
        }else{
            contactImageView.image = UIImage(named: "userDefault")
        }
        setCircularAvatar()
    }
}
