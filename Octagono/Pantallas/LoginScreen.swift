//
//  LoginScreen.swift
//  Octagono
//
//  Created by Christian Villa Rhode on 1/31/19.
//  Copyright © 2019 Christian Villa Rhode. All rights reserved.
//

import UIKit
import TransitionButton
import TextFieldEffects
import Alamofire
import AEXML

class LoginScreen: UIViewController {
    
    typealias BatchPhotoDownloadingCompletionClosure = (_ error: NSError?) -> Void
    @IBOutlet weak var CuentaTextField: KaedeTextField!
    @IBOutlet weak var UsuarioTextField: KaedeTextField!
    @IBOutlet weak var ContraseñaTextField: KaedeTextField!
    
    var tempString:String = ""
    
    var user:usuario = usuario()
    var vehiculos: [vehiculo] = []
    var dict: [String:Any] = [:]
//    let request:URLrequest = URLrequest()
    var Server:String?
    var IP:String = "50.63.174.34"
    var link2:URL?
    let Group = DispatchGroup()
    typealias downloadComplete = () -> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        xd()
    }
//    override func viewWillAppear(_ animated: Bool) {
//        HacerAlgoConLadata()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(UserDefaults.standard.bool(forKey: "auth"))
        if(UserDefaults.standard.bool(forKey: "auth") == true)
        {
            if Reachability.isConnectedToNetwork() == false
            {
                let alert = UIAlertController(title: "Sin conexión a internet", message: "Necesita estar conectado a una red de datos para usar esta aplicación", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
            else
            {
                print("el login se hara automatico")
                let maintabviewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "tabcontroller") as! MainTabController
                maintabviewcontroller.selectedViewController = maintabviewcontroller.viewControllers?[0]
                self.present (maintabviewcontroller, animated: true, completion: nil)
                self.view.endEditing(true)
            }
            
        }
    }
    
    @IBAction func LogIn(_ sender: TransitionButton) {
        sender.startAnimation()
        self.view.endEditing(true)
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertController(title: "Sin conexión a internet", message: "Necesita estar conectado a una red de datos para usar esta aplicación", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }else
        {
            
            user.setCuenta(x: (CuentaTextField.text?.replacingOccurrences(of: " ", with: ""))!)
            user.setUsuario(x: (UsuarioTextField.text?.replacingOccurrences(of: " ", with: ""))!)
            user.setContraseña(x: (ContraseñaTextField.text?.replacingOccurrences(of: " ", with: ""))!)
            
            
            myRequest()
            
            
            run(after: 5) {
                if(self.link2 == nil)
                {
                    let alert = UIAlertController(title: "Tiempo de respuesta muy alto", message: "por favor intente mas tarde. Si los problemas persisten contactenos.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                    sender.stopAnimation(animationStyle:.shake, completion: {
                        
                    })
                }
                else{
                    print(self.link2)
                    let peticion2 = URLRequest(url: self.link2!)
                    let tarea2 = URLSession.shared.dataTask(with: peticion2) { (datos, respuesta, error) in
                        
                        if error != nil {
                            
                            print(error!)
                            
                        } else {
                            
                            do{
                                
                                var json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                
                                                    print(json["status"])
                                
                                if(json["status"] as! String == "success")
                                {
                                    json = json["obj"] as! NSDictionary
                                    
                                    self.user.setNombre(x: json["accountID"] as! String)
                                    self.user.setUltimaconnexion(x: json["lastLoginTimeAccount"] as! String)
                                    self.user.setCantidadDeCarros(x: json["cantDevices"] as! String)
                                    self.user.setNumerodeTelefono(x: json["contactPhone"] as! String)
                                    
                                    UserDefaults.standard.set(true, forKey: "auth")
                                    UserDefaults.standard.set(self.user.getCuenta(), forKey: "Cuenta")
                                    UserDefaults.standard.set(self.user.getUsuario(), forKey: "Usuario")
                                    UserDefaults.standard.set(self.user.getContraseña(), forKey: "Contraseña")
                                    UserDefaults.standard.set(self.user.getUltimaConexion(), forKey: "Conex")
                                    UserDefaults.standard.set(self.user.getCantidadDeCarros(), forKey: "Cantidad")
                                    UserDefaults.standard.set(self.user.getNumeroDeTelefono(), forKey: "Telefono")
                                    
                                    sender.stopAnimation(animationStyle: .expand, completion: {
                                        //            let secondVC = SecondViewController()
                                        //            self.present(secondVC, animated: true, completion: nil)
                                        let maintabviewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "tabcontroller") as! MainTabController
                                        maintabviewcontroller.selectedViewController = maintabviewcontroller.viewControllers?[0]
                                        self.present (maintabviewcontroller, animated: true, completion: nil)
                                    })
                                }
                                else
                                {
                                    sender.stopAnimation(animationStyle:.shake, completion: {
                                        let Alert = UIAlertController(title: "Error", message: "Usuario o contraseña incorrecta, vuelva a internarlo", preferredStyle: .alert)
                                        Alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
                                    })
                                }
                                
                                
                            }catch {
                                
                                print("El Procesamiento del JSON tuvo un error")
                                
                            }
                            
                        }
                        
                    }
                    tarea2.resume()
                }
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func run(after seconds: Int, complention: @escaping ()-> Void)
    {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            complention()
        }
    }
    
    public func myRequest()
    {
        run(after: 2) {
            Alamofire.request("http://empresarial.octagonogps.com/services/xml_rpc_checkserver.php?account="+self.user.getCuenta())
                .validate(statusCode: 200..<300)
                .validate(contentType: ["text/html"])
                .response { response in
                    // response handling code
                    let json = String(bytes: response.data!, encoding: .utf8)
                    if(json == "older")
                    {
                        print("soy viejo")
                        self.link2 = URL(string:"http://50.63.174.34/services/login_user.php?account="+self.user.getCuenta()+"&user="+self.user.getUsuario()+"&password="+self.user.getContraseña())
                        UserDefaults.standard.set("50.63.174.34", forKey: "server")
                    }
                    else
                    {
                        print("soy nuebo")
                        self.link2 = URL(string:"http://192.227.91.57/services/login_user.php?account="+self.user.getCuenta()+"&user="+self.user.getUsuario()+"&password="+self.user.getContraseña())
                        UserDefaults.standard.set("192.227.91.57", forKey: "server")
                    }
                    print(json!)
                }
                .resume()
        }
    }
    
    func xd(){
        Alamofire.request("http://192.227.91.57:8080/events/data.kml?a=octagonogps&p=180octa523&d=359710047711149&limit=1")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/vnd.google-earth.kml+xml;charset=UTF-8"])
            .response { response in
                var options = AEXMLOptions()
                options.parserSettings.shouldProcessNamespaces = false
                options.parserSettings.shouldReportNamespacePrefixes = false
                options.parserSettings.shouldResolveExternalEntities = false
                let xmlDocument = try? AEXMLDocument(xml: response.data!, options: options)
//                let popolbu = xmlDocument!.root
//                print("se supone xd k monf")
//                print(popolbu.xmlSpaces)
                let popolbu = xmlDocument!.root["Document"].all
                
                //                print(xmlDoc!.xmlSpaces)
                
                for child in popolbu! {
                                        print(child.name)
                    for value in child.children
                    {
//                        print("estoy en el for 1")
//                        print("name: "+value.name+" value: "+value.value!)
                        
                        for style in value.children
                        {
//                            print("estoy en el for 2")
                            if(style.value == nil)
                            {
//                                print("cuidao venia nil xd")
                            }
                            else{
                                if(style.name == "description")
                                {
//                                    print("name: "+style.name+" value: "+style.value!)
                                    self.tempString = style.value!
                                    self.tempString = self.tempString.replacingOccurrences(of: "<strong>", with: "")
                                    self.tempString = self.tempString.replacingOccurrences(of: "<br>", with: "")
                                    self.tempString = self.tempString.replacingOccurrences(of: "</strong>", with: ",")
                                    let infoArray : [String] = self.tempString.components(separatedBy: ",")
                                    // And then to access the individual words:
                                    print(infoArray)
//                                    print(self.tempString)
                                }
                            }
                        }
                    }
                }
        }
    }
}
