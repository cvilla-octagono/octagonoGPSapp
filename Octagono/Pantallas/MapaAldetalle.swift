//
//  MapaAldetalle.swift
//  Octagono
//
//  Created by Christian Villa Rhode on 2/3/19.
//  Copyright © 2019 Christian Villa Rhode. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import LocalAuthentication
import Alamofire

class MapaAldetalle: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapa: MKMapView!
    var VehiculoSeleccionado:vehiculo?
    let locationManager = CLLocationManager()
    var location:CLLocationCoordinate2D?
    var locationuser:CLLocationCoordinate2D?
    var selectedAnnotation: MKPointAnnotation?
    let server = UserDefaults.standard.string(forKey: "server")
    var gameTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        actualizarpunto()
        
        mapa.delegate = self
        
//        mapa.showsUserLocation = true
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
//        mapa.showsUserLocation = true
        mapa.mapType = .hybrid
        mappoint(x: VehiculoSeleccionado!.getlastvalidlatitude(), y: VehiculoSeleccionado!.getlastvalidlongitude())
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationuser = locValue
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        //        checkXD()
        //        print("car location: \(String(describing: carrorecibido!.lastValidLatitude)) \(String(describing: carrorecibido!.lastValidLongitude))")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var anotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if anotationView == nil {
            anotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        anotationView?.image = UIImage(named:"peke")
        
        if (VehiculoSeleccionado?.getSecondsPass())! >= 3600
        {
            anotationView?.image = UIImage(named:"redcarpeke")
        }
        else if VehiculoSeleccionado!.getVelocidad().contains("Err") == false {
            let x = VehiculoSeleccionado!.getVelocidad().replacingOccurrences(of: "Speed :", with: "").components(separatedBy: " ")
            if(Float(x[1]) ?? 0.0 >= 10 && VehiculoSeleccionado!.getStatus().contains("En Movimiento")){
                anotationView?.image = UIImage(named:"pekegreen")
                gameTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(actualizarpunto), userInfo: nil, repeats: true)
            }
        }
//        else if (VehiculoSeleccionado?.getStatus().contains("En Movimiento"))!
//        {
//            anotationView?.image = UIImage(named:"pekegreen")
//            gameTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(actualizarpunto), userInfo: nil, repeats: true)
//        }
        
        else if VehiculoSeleccionado!.getVelocidad().contains("Err") == false {
            let x = VehiculoSeleccionado!.getVelocidad().replacingOccurrences(of: "Speed :", with: "").components(separatedBy: " ")
            if(Float(x[1]) ?? 0.0 >= 10 && VehiculoSeleccionado!.getStatus().contains("En Movimiento")){
                
                anotationView?.image = UIImage(named:"pekegreen")
                gameTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(actualizarpunto), userInfo: nil, repeats: true)
            }
        }
        
//        if (VehiculoSeleccionado?.getcolor() == "verde")
//        {
//            anotationView?.image = UIImage(named:"pekegreen")
//            gameTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(actualizarpunto), userInfo: nil, repeats: true)
//        }
//        else if(VehiculoSeleccionado?.getcolor() == "azul")
//        {
//            anotationView?.image = UIImage(named:"peke")
//        }
//        else if(VehiculoSeleccionado?.getcolor() == "rojo")
//        {
//            anotationView?.image = UIImage(named:"redcarpeke")
//        }
        
        anotationView?.canShowCallout = true
        
        return anotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("anoteichon gua sele")
    }
    
    func mappoint(x:Double,y:Double)
    {
        let Lat = x
        let long = y
        self.location = CLLocationCoordinate2D(latitude: Lat,longitude: long)
        let span = MKCoordinateSpan(latitudeDelta: 0.003,longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: self.location!, span: span)
        mapa.setRegion(region, animated: true)
        let anotation = MKPointAnnotation()
        anotation.coordinate = self.location!
        anotation.title = VehiculoSeleccionado!.getdescription()
        anotation.subtitle = VehiculoSeleccionado!.getdireccion()+VehiculoSeleccionado!.getVelocidad()
        mapa.addAnnotation(anotation)
        mapa.delegate = self
        mapa.mapType = .standard
    }
    
    @objc func actualizarpunto()
    {
        Alamofire.request("http://192.227.91.57/services/getDevice.php?deviceID="+(VehiculoSeleccionado?.getdeviceID())!)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response { response in
                let json = try? JSONSerialization.jsonObject(with: response.data! , options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                let carrosDIC = json!["devices"] as! NSArray
                let xd = carrosDIC[0] as! NSDictionary
                
                self.VehiculoSeleccionado?.setLastvalidLT(x: xd["lastValidLatitude"] as! String)
                self.VehiculoSeleccionado?.setLastvalidLG(x: xd["lastValidLongitude"] as! String)
                
                let allAnnotations = self.mapa.annotations
                self.mapa.removeAnnotations(allAnnotations)
                
                self.mappoint(x: self.VehiculoSeleccionado!.getlastvalidlatitude(), y: self.VehiculoSeleccionado!.getlastvalidlongitude())
                
//                print(carrosDIC["lastValidLatitude"])
//                print(carrosDIC["lastValidLongitude"])
        }
    }
    
    private func addAnotations(){
        let popola = MKPointAnnotation()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        gameTimer?.invalidate()
    }
    
    @IBAction func MasInformacion(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: VehiculoSeleccionado!.getdescription(), message: "Seleccione una opcion", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        //        alert.addAction(UIAlertAction(title: "Apagar Carro", style: .default, handler: { (ApagarCarro) in
        //            let localAuthenticationContext = LAContext()
        //
        //            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Estas seguro que quieres apagar el carro?") {_,_ in
        //
        //
        //
        //        }))
        
//        alert.addAction(UIAlertAction(title: "Mas Informacion", style: .default, handler: { (TabladeInformacion) in
////            self.performSegue(withIdentifier: "InformacionDelCarro", sender: self.VehiculoSeleccionado)
//        }))
        self.present(alert, animated: true)
        
        alert.addAction(UIAlertAction(title: "Buscar Carro", style: .default, handler: { (BucarCarro) in
            UIApplication.shared.openURL(NSURL(string: "https://www.google.com/maps/dir/?api=1&origin=\(self.locationuser!.latitude),\(self.locationuser!.longitude)+&destination=\(self.location!.latitude),\(self.location!.longitude)+&travelmode=automobile")! as URL)
        }))
        
        alert.addAction(UIAlertAction(title: "Apagar Carro", style: .default, handler: { (Apagar) in
                        let localAuthenticationContext = LAContext()
            
                        localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Este coando envia un codigo para apagar el carro") {_,_ in
            
                            let alert = UIAlertController(title: self.VehiculoSeleccionado?.getaccountID(), message: "Esta seguro que desea Apagar?", preferredStyle: .alert)
                            
                            //2. Add the text field. You can configure it however you need.
                            alert.addTextField { (textField) in
                                textField.placeholder = "Contraseña"
                            }
                            
                            // 3. Grab the value from the text field, and print it when the user clicks OK.
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                                let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                                var tempString = UserDefaults.standard.string(forKey: "Telefono")!
                                tempString = String(tempString.reversed())
                                tempString = String(tempString.dropLast())
                                tempString = String(tempString.dropLast())
                                tempString = String(tempString.dropLast())
                                tempString = String(tempString.dropLast())
                                tempString = String(tempString.dropLast())
                                tempString = String(tempString.dropLast())
                                tempString = String(tempString.reversed())
                                print(tempString)
                                
                                if(textField.text == tempString)
                                {
                                    //                    print("Text field: \(textField.text)")
                                    let tempaccount = UserDefaults.standard.string(forKey: "Cuenta")!
                                    
                                    Alamofire.request("http://50.63.174.34/services/sms/smsapi.php?sim=1\(self.VehiculoSeleccionado!.GetNum())&message=stop123456")
                                        .validate(statusCode: 200..<300)
                                        .validate(contentType: ["text/html"])
                                        .resume()
                                    
                                    
                                    Alamofire.request("http://50.63.174.34/services/sms/smsapi.php?sim=18499133708&message=\(tempaccount)+apago+el+dispositivo+\(self.VehiculoSeleccionado!.getdeviceID())+\(self.location!.latitude)+\(self.location!.longitude)")
                                        .resume()
                                    
                                    let alerta = UIAlertController(title: self.VehiculoSeleccionado!.getdescription(), message: "El comando se ha ejecutado de manera satisfactoria", preferredStyle: .alert)
                                    alerta.addAction(UIAlertAction(title: "Entendido", style: .cancel, handler: nil))
                                    self.present(alerta, animated: true)
                                    
//                                    print("http://50.63.174.34/services/sms/smsapi.php?sim=\(self.VehiculoSeleccionado!.GetNum())&message=stop123456")
                                }
                                else
                                {
                                    let alerta = UIAlertController(title: self.VehiculoSeleccionado!.getdescription(), message: "Contraseña Inconrrecta", preferredStyle: .alert)
                                    alerta.addAction(UIAlertAction(title: "Entendido", style: .cancel, handler: nil))
                                    self.present(alerta, animated: true)
                                }
                                
                            }))
                            
                            // 4. Present the alert.
                            self.present(alert, animated: true, completion: nil)

        
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Reanudar Servicio", style: .default, handler: { (Apagar) in
            //1. Create the alert controller.
            let alert = UIAlertController(title: self.VehiculoSeleccionado?.getaccountID(), message: "Esta seguro que desea desbloquear el carro?", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.placeholder = "Contraseña"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                
                let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                var tempString = UserDefaults.standard.string(forKey: "Telefono")!
                
                tempString = String(tempString.reversed())
                tempString = String(tempString.dropLast())
                tempString = String(tempString.dropLast())
                tempString = String(tempString.dropLast())
                tempString = String(tempString.dropLast())
                tempString = String(tempString.dropLast())
                tempString = String(tempString.dropLast())
                tempString = String(tempString.reversed())
                
                print(tempString)
                
                if(textField.text == tempString)
                {
                    //                    print("Text field: \(textField.text)")
//                    let tempaccount = UserDefaults.standard.string(forKey: "Cuenta")!
                    
                    Alamofire.request("http://50.63.174.34/services/sms/smsapi.php?sim=1\(self.VehiculoSeleccionado!.GetNum())&message=resume123456")
                        .validate(statusCode: 200..<300)
                        .validate(contentType: ["text/html"])
                        .resume()
                    
                    
//                    Alamofire.request("http://50.63.174.34/services/sms/smsapi.php?sim=18499133708&message=\(tempaccount)+apago+el+dispositivo+\(self.VehiculoSeleccionado!.getdeviceID())+\(self.location!.latitude)+\(self.location!.longitude)")
//                        .resume()
                    
                    let alerta = UIAlertController(title: self.VehiculoSeleccionado!.getdescription(), message: "El comando se ha ejecutado de manera satisfactoria", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "Entendido", style: .cancel, handler: nil))
                    self.present(alerta, animated: true)
                    
                    //                                    print("http://50.63.174.34/services/sms/smsapi.php?sim=\(self.VehiculoSeleccionado!.GetNum())&message=stop123456")
                }
                else
                {
                    let alerta = UIAlertController(title: self.VehiculoSeleccionado!.getdescription(), message: "Contraseña Inconrrecta", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "Entendido", style: .cancel, handler: nil))
                    self.present(alerta, animated: true)
                }
                
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)

        }))
        
//        alert.addAction(UIAlertAction(title: "Enviar Comando", style: .default, handler: { (BucarCarro) in
//            
//            UIApplication.shared.openURL(NSURL(string: "https://platform.clickatell.com/messages/http/send?apiKey=Ac3oXCEYRnKsuvxC_X7HPw==&to="+(self.VehiculoSeleccionado?.getdeviceID())!+"&content=Test+message+text")! as URL)
//            
//        }))
        
        //        alert.addAction(UIAlertAction(title: "Apagar Carro", style: .default, handler: { (BucarCarro) in
        //            UIApplication.shared.openURL(NSURL(string: "https://www.google.com/maps/dir/?api=1&origin=\(self.locationuser!.latitude),\(self.locationuser!.longitude)+&destination=\(self.location!.latitude),\(self.location!.longitude)+&travelmode=automobile")! as URL)
        //        }))
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
