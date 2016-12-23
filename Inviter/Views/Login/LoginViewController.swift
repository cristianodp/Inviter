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

    @IBOutlet weak var loginDigits: UIButton!
    @IBOutlet weak var viewDadosUsuario: UIView!
    @IBOutlet weak var nomeUsuario: UITextField!
    @IBOutlet weak var emailUsuario: UITextField!
    var usuario:Usuario = Usuario()
    
    var ref : FIRDatabaseReference!
    var refHandler : UInt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        ref = FIRDatabase.database().reference()
       // autenticacaoUsuario()
        if FIRAuth.auth()?.currentUser?.uid != nil{
            mostraCadastroAdcional(sim: true)
            carregaDadosLoginUsuario()
            carregaCamposUsuario()
            
        }else{
            mostraCadastroAdcional(sim: false)
        }
        
        
    }
    
    func autenticacaoUsuario(){
    
      /*  // Swift
        let configuration = DGTAuthenticationConfiguration(accountFields: .email)
        configuration?.title = "Login to Digits"
        let digits = Digits.sharedInstance()
        digits.authenticate(with: nil, configuration: configuration!) { session, error in
            // Inspect session to access the email address of the user
        }
        */
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
                self.carregaDadosLoginUsuario()
                self.completarCadastro()
            }else{
                
                self.createUserFirebase(email: email, passwd: passwd)
                
            }
            
        })
        
    }
    
    
    func carregaDadosLoginUsuario()
    {
        if let user = FIRAuth.auth()?.currentUser{
            self.usuario.id = user.uid
            self.usuario.name = user.displayName
            self.usuario.phone = user.email?.replacingOccurrences(of: "@inviter.com.br", with: "")
        }
        
    }
    
    func createUserFirebase(email:String,passwd:String) {
     
        FIRAuth.auth()?.createUser(withEmail: email, password: passwd, completion: {(user, error) in
            
            if error == nil {
                self.carregaDadosLoginUsuario()
                self.completarCadastro()
                //self.voltaTelaAnterior()
                
            }else{
                
                AlertSimpleDialog.show(sender: self,title: "Opps!", message: (error?.localizedDescription)! )
      
            }
            
        })
    
    }
    
    func completarCadastro(){
        
        mostraCadastroAdcional(sim: true)
        carregaCamposUsuario()
    }
    
    func carregaCamposUsuario() {
        if let value = usuario.name{
            nomeUsuario.text = value
        }else{
            nomeUsuario.text = ""
        }
        
        if let value = usuario.email{
            emailUsuario.text = value
        }else{
            emailUsuario.text = ""
        }
        
    }
    
    func mostraCadastroAdcional(sim:Bool){
        viewDadosUsuario.isHidden = !sim
        loginDigits.isHidden = sim
    }
    
    
    @IBAction func loginDigitsAction(_ sender: Any) {
        
        let digits = Digits.sharedInstance()
        digits.authenticate { (session, error) in
            
            if (session != nil) {
                
                let email:String = session!.phoneNumber+"@inviter.com.br"
                let chave:String = session!.phoneNumber
                
                self.loginUserFirebase(email: email, passwd: chave)
                
            } else {
                AlertSimpleDialog.show(sender: self, title: "Opps!", message: (error?.localizedDescription)! )
            }
        
        }
        
    }
    
    
    @IBAction func salvaAction(_ sender: Any) {
 
        do
        {
            try gravarUsuario()
            
            voltaTelaAnterior()
        }catch exceptionErros.GENERIC_ERRO {
            
           AlertSimpleDialog.show(sender:self, title:"Ops!",message: "Erro informe todos os campos corretamente.")
            
        }catch _ {
        
        }
        
        
    }
    
    func gravarUsuario() throws{
        
        if let value = nomeUsuario.text {
            usuario.name = value
        }else{
            throw exceptionErros.GENERIC_ERRO(Message: "Usuario não informado")
        }
        
        if let value = emailUsuario.text {
            if !value.isEmail(){
                throw exceptionErros.GENERIC_ERRO(Message: "Email informado é inválido")
            }
            usuario.email = value
        }else{
            throw exceptionErros.GENERIC_ERRO(Message: "Email não informado")
        }
        
        if usuario.id == nil{
            throw exceptionErros.GENERIC_ERRO(Message: "Login por celular não realizado")
        }
        
        gravaUsuarioNoFirebase()
    }
    
    func gravaUsuarioNoFirebase(){
        
        self.ref.child("Usuarios").child(usuario.id!).child("Usuario").setValue(usuario.toDictionary())
    
    }
    
    func voltaTelaAnterior(){
        AlertSimpleDialog.show(sender: self,title: "Sucess!", message: "Login realizado com sucesso.", handler:{(action) in
            self.dismiss(animated: true, completion: nil)
        })
    }

    @IBAction func touchEntrer(_ sender: Any) {
        self.hideKeyboard()
    }
    
    @IBAction func endEditEmail(_ sender: Any) {
        self.hideKeyboard()
    }
    
}

