//
//  EventoViewController.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 28/10/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit
import Firebase
class EventoViewController: UIViewController {

    @IBOutlet weak var descricaoField: UITextField!
    @IBOutlet weak var localField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var ref : FIRDatabaseReference!
    var refHandler : UInt!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()   // Do any additional setup after loading the view.
        limpaCampos()
        
    }
    
    func limpaCampos() {
        localField.text = ""
        descricaoField.text = ""
        datePicker.date = NSDate() as Date
    }
    
    @IBAction func actionSalvar(_ sender: AnyObject) {
        criarEvento()
    }
    func criarEvento(){
       
        do
        {
            try validaCampos()
            
            try incluiEvendoNoDb()
            
            self.dismiss(animated: true, completion: nil)
            
        }catch exceptionErros.GENERIC_ERRO(let err)
        {
            _ = AlertSimpleDialog.show(sender: self, title: "Error", message: err)
            
        }catch{
            _ = AlertSimpleDialog.show(sender: self, title: "Error", message: "Erro ao criar evento.")
        }
    }
    
    func validaCampos() throws{
    
        if descricaoField.text == "" {
            throw exceptionErros.GENERIC_ERRO("A descrição do evento não foi informada.")
        }
        if localField.text == "" {
            throw exceptionErros.GENERIC_ERRO("A local do evento não foi informado.")
        }
        if datePicker.date < NSDate() as Date {
            throw exceptionErros.GENERIC_ERRO("A data do evento não pode ser menor que a data correte.")
        }
    }
    
    func incluiEvendoNoDb() throws{
        
        let evento:Evento = Evento()
        
        evento.idEvento = self.ref.childByAutoId().key;
        evento.local = localField.text!
        evento.nome = descricaoField.text!
        evento.data = datePicker.date
        //evento.setDataString(dataString: dataField.text!)
        let usr = FIRAuth.auth()?.currentUser
        let usrId = usr!.uid
        
        let dic = evento.toDictionary()
        
        
        self.ref.child("Usuarios").child(usrId).child("Eventos").child(evento.idEvento!).setValue(dic as [String:Any])
        
        limpaCampos()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
