//
//  InformacionDeUsuario.swift
//  Octagono
//
//  Created by Christian Villa Rhode on 2/1/19.
//  Copyright © 2019 Christian Villa Rhode. All rights reserved.
//

import UIKit
import TransitionButton

class InformacionDeUsuario: UIViewController {
    
//    @IBAction func Salir(_ sender: UIBarButtonItem) {
//    }
    
    
    var user:usuario = usuario()
    @IBOutlet weak var Banner: UIImageView!
    @IBOutlet weak var NombreDeCuentaTextField: UILabel!
    @IBOutlet weak var NumeroDeTelefono: UILabel!
    @IBOutlet weak var CorreoElectronicoTextField: UILabel!
    @IBOutlet weak var CantidadDeCochesTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NombreDeCuentaTextField.text = "Cuenta: "+UserDefaults.standard.string(forKey: "Cuenta")!
        NumeroDeTelefono.text = "Telefono: "+UserDefaults.standard.string(forKey: "Telefono")!
        CorreoElectronicoTextField.text = "Ultima conexión: "+UserDefaults.standard.string(forKey: "Conex")!
        CantidadDeCochesTextField.text = "Cantidad de vehiculos: "+UserDefaults.standard.string(forKey: "Cantidad")!
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func VerCarros(_ sender: TransitionButton) {}
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue .identifier == "vehiculos"
//        {
//            let vehiculos = sender as! [vehiculo]
//            let objetopantalla3:TablaDeCarros = segue.destination as! TablaDeCarros
//            objetopantalla3.vehiculos = vehiculos
//        }
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func CERRAR(_ sender: UIButton) {
        let maintabviewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginScreen
        UserDefaults.standard.set(false, forKey: "auth")
        self.present (maintabviewcontroller, animated: true, completion: nil)
    }
    
}
