//
//  exceptionErros.swift
//  Invater
//
//  Created by Cristiano Diniz Pinto on 23/10/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation

enum exceptionErros:Error {
    case LOGIN_INVALIDO
    case INVALID_EVENTO_ID
    case INVALID_ORGANIZADOR_ID
    case GENERIC_ERRO(Message:String)
    
    
}
