//
//  Usuario.swift
//  Octagono
//
//  Created by Christian Villa Rhode on 1/31/19.
//  Copyright © 2019 Christian Villa Rhode. All rights reserved.
//

import Foundation

class usuario{
    
    var Cuenta:String?
    var Usuario:String?
    var Contraseña:String?
    var CantidadDeCarros:String?
    var NumeroDeTelefono:String?
    var Nombre:String?
    var UltimaConexion:String?
    
    //Almacenamos los datos de la cuenta
    
    func setCuenta(x:String)
    {
      Cuenta = x
    }
    
    func setUsuario(x:String)
    {
        Usuario = x
    }
    
    func setContraseña(x:String)
    {
        Contraseña = x
    }
    
    func setCantidadDeCarros(x:String)
    {
        CantidadDeCarros = x
    }
    
    func setNumerodeTelefono(x:String)
    {
        NumeroDeTelefono = x
    }
    
    func setNombre(x:String)
    {
        Nombre = x
    }
    
    func setUltimaconnexion(x:String)
    {
        UltimaConexion = x
    }
    //devolvemos los datos de la cuenta
    
    func getCuenta() -> String
    {
        return Cuenta!
    }
    
    func getUsuario() -> String
    {
        return Usuario!
    }
    
    func getContraseña() -> String
    {
        return Contraseña!
    }
    
    func getCantidadDeCarros()->String
    {
        return CantidadDeCarros!
    }
    func getNumeroDeTelefono()->String
    {
        return NumeroDeTelefono!
    }
    func getNombre()->String
    {
        return Nombre!
    }
    func getUltimaConexion()->String
    {
        let Date:DateParser = DateParser()
        return Date.DateParser(tempDate: UltimaConexion! as NSString)
    }
    
}
