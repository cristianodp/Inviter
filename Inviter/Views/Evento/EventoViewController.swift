//
//  EventoViewController.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 04/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit

class EventoViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {


    
    var participantesList = [Participante]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participantesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "participanteCell", for: indexPath)
        
        //cell.imageView?.image = UI
        let item = participantesList[indexPath.row]
        
        cell.textLabel?.text = item.getParticipante()?.name
        
        return cell
        
    }
}
