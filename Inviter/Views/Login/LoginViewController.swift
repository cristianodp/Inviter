//
//  ViewController.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 23/10/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit
import Firebase
import DigitsKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        autenticacaoUsuario()
        
    }
    
    func autenticacaoUsuario(){
    
        let authButton = DGTAuthenticateButton(authenticationCompletion: { (session, error) in
            if (session != nil) {
               
                let email:String = session!.phoneNumber+"@inviter.com.br"
                let chave:String = session!.phoneNumber
                
                self.loginUserFirebase(email: email, passwd: chave)
                
            } else {
                AlertSimpleDialog.show(sender: self, title: "Opps!", message: (error?.localizedDescription)! )
            }
        })
        authButton?.center = self.view.center
        self.view.addSubview(authButton!)

    }
  
   
    func loginUserFirebase(email:String,passwd:String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: passwd , completion: { (user, error) in
            
            if error == nil {
                
                self.voltaTelaAnterior()
                
            }else{
                
                self.createUserFirebase(email: email, passwd: passwd)
                
            }
            
        })
        
    }
    
    func createUserFirebase(email:String,passwd:String) {
     
        FIRAuth.auth()?.createUser(withEmail: email, password: passwd, completion: {(user, error) in
            
            if error == nil {
                
                self.voltaTelaAnterior()
                
            }else{
                
                AlertSimpleDialog.show(sender: self,title: "Opps!", message: (error?.localizedDescription)! )
            }
            
        })
    
    }
    
    func voltaTelaAnterior(){
        AlertSimpleDialog.show(sender: self,title: "Sucess!", message: "Login realizado com sucesso.", handler:{(action) in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
        
    
}

