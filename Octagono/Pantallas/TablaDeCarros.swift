//
//  TablaDeCarros.swift
//  Octagono
//
//  Created by Christian Villa Rhode on 2/2/19.
//  Copyright © 2019 Christian Villa Rhode. All rights reserved.
//

import UIKit
import Alamofire
import AEXML

class TablaDeCarros: UITableViewController, UISearchBarDelegate{
    
    var user:usuario = usuario()
    var vehiculos: [vehiculo] = []
    var Vehiculos2:[vehiculo] = []
    var tempString:String = ""
    var infoArray:[String] = ["Err","Err","Err","Err","Err"]
    
    @IBOutlet weak var BarraBusqueda: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        //        cargartabla()
        BarraBusqueda.delegate = self
        let backgroundImage = UIImage(named: "IMG_1432")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        //        ultimopuntos()
        //        nav?.tintColor = UIColor.white
    }
    
    @IBAction func Salir(_ sender: UIBarButtonItem) {
        //        let maintabviewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginScreen
        //        UserDefaults.standard.set(false, forKey: "auth")
        //        self.present (maintabviewcontroller, animated: true, completion: nil)
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        //         var gameTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(cargartabla2), userInfo: nil, repeats: true)
        cargartabla()
    }
    
    // MARK: - Table view data source
    
    @objc func cargartabla2()
    {
        //        print("se llamo el web service")
        self.vehiculos = []
        self.Vehiculos2 = self.vehiculos
        user.setCuenta(x: UserDefaults.standard.string(forKey: "Cuenta")!)
        user.setUsuario(x: UserDefaults.standard.string(forKey: "Usuario")!)
        user.setContraseña(x: UserDefaults.standard.string(forKey: "Contraseña")!)
        let server = UserDefaults.standard.string(forKey: "server")
        let urlinfo3 = URL(string:"http://"+server!+"/services/getDevices.php?user="+self.user.getUsuario()+"&password="+self.user.getContraseña()+"&account="+self.user.getCuenta())
        let peticion3 = URLRequest(url: urlinfo3!)
        let tarea3 = URLSession.shared.dataTask(with: peticion3){datos,respuesta,error in
            if error != nil {
                print(error!)
            } else {
                
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                    
                    let carrosDIC = json["devices"] as! NSArray
                    
                    
                    UserDefaults.standard.set(json["devices"], forKey: "carros")
                    
                    
                    var indice:Int = 0;
                    while(indice < carrosDIC.count)
                    {
                        let test = carrosDIC[indice] as! NSDictionary
                        
                        self.StatusVehiculo(x: test["deviceID"] as! String)
                        
                        let carrotemp:vehiculo = vehiculo()
                        carrotemp.setdeviceID(x: test["deviceID"] as! String)
                        carrotemp.setaccoundID(x: test["accountID"] as! String)
                        carrotemp.setdescription(x: test["description"] as! String)
                        carrotemp.setlastOdometerKM(x: test["lastOdometerKM"] as! String)
                        carrotemp.setlastOdometerKM(x: test["odometerOffsetKM"] as! String)
                        carrotemp.setLastvalidLT(x: test["lastValidLatitude"] as! String)
                        carrotemp.setLastvalidLG(x: test["lastValidLongitude"] as! String)
                        carrotemp.setLastEventTimestrap(x: test["lastEventTimestamp"] as! String)
                        carrotemp.setvehicleID(x: test["vehicleID"] as! String)
                        carrotemp.setLicensePlate(x: test["licensePlate"] as! String)
                        carrotemp.setLastnotifytime(x: test["lastNotifyTime"] as! String)
                        carrotemp.setNumero(x: test["simPhoneNumber"] as! String)
                        
                        carrotemp.setStatus(x: self.infoArray[0])
                        carrotemp.setDireccion(x: self.infoArray[2])
                        carrotemp.setVelocidad(x: self.infoArray[3])
                        
                        //                        print(carrotemp)
                        self.vehiculos.append(carrotemp)
                        self.Vehiculos2 = self.vehiculos
                        DispatchQueue.main.sync (execute:{
                            self.tableView.reloadData()
                        })
                        indice += 1
                    }
                    //                    print(self.vehiculos)
                    //                    UserDefaults.standard.set(self.ArreglodeArreglos, forKey: "XD")
                    
                }catch {
                    
                    print("El Procesamiento del JSON tuvo un error")
                    
                }
                
            }
            
        }
        tarea3.resume()
    }
    
    func cargartabla()
    {
        print("se llamo el web service")
        self.vehiculos = []
        self.Vehiculos2 = self.vehiculos
        user.setCuenta(x: UserDefaults.standard.string(forKey: "Cuenta")!)
        user.setUsuario(x: UserDefaults.standard.string(forKey: "Usuario")!)
        user.setContraseña(x: UserDefaults.standard.string(forKey: "Contraseña")!)
        let server = UserDefaults.standard.string(forKey: "server")
        let urlinfo3 = URL(string:"http://"+server!+"/services/getDevices.php?user="+self.user.getUsuario()+"&password="+self.user.getContraseña()+"&account="+self.user.getCuenta())
        let peticion3 = URLRequest(url: urlinfo3!)
        let tarea3 = URLSession.shared.dataTask(with: peticion3){datos,respuesta,error in
            if error != nil {
                print(error!)
            } else {
                
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                    
                    let carrosDIC = json["devices"] as! NSArray
                    
                    
                    UserDefaults.standard.set(json["devices"], forKey: "carros")
                    
                    
                    var indice:Int = 0;
                    while(indice < carrosDIC.count)
                    {
                        let test = carrosDIC[indice] as! NSDictionary
                        
                        //                        self.StatusVehiculo(x: test["deviceID"] as! String)
                        
                        let carrotemp:vehiculo = vehiculo()
                        carrotemp.setdeviceID(x: test["deviceID"] as! String)
                        carrotemp.setaccoundID(x: test["accountID"] as! String)
                        carrotemp.setdescription(x: test["description"] as! String)
                        carrotemp.setlastOdometerKM(x: test["lastOdometerKM"] as! String)
                        carrotemp.setlastOdometerKM(x: test["odometerOffsetKM"] as! String)
                        carrotemp.setLastvalidLT(x: test["lastValidLatitude"] as! String)
                        carrotemp.setLastvalidLG(x: test["lastValidLongitude"] as! String)
                        carrotemp.setLastEventTimestrap(x: test["lastEventTimestamp"] as! String)
                        carrotemp.setvehicleID(x: test["vehicleID"] as! String)
                        carrotemp.setLicensePlate(x: test["licensePlate"] as! String)
                        carrotemp.setLastnotifytime(x: test["lastNotifyTime"] as! String)
                        carrotemp.setNumero(x: test["simPhoneNumber"] as! String)
                        
                        //                        carrotemp.setDireccion(x: self.infoArray[2])
                        //                        carrotemp.setVelocidad(x: self.infoArray[3])
                        //                        carrotemp.setStatus(x: self.infoArray[0])
                        
                        //                        print(carrotemp)
                        Alamofire.request("http://192.227.91.57:8080/events/data.kml?a=\(self.user.getCuenta())&p=180octa523&d=\(carrotemp.getdeviceID())&limit=1")
                            .validate(statusCode: 200..<300)
                            .validate(contentType: ["application/vnd.google-earth.kml+xml;charset=UTF-8"])
                            .response { response in
                                var options = AEXMLOptions()
                                options.parserSettings.shouldProcessNamespaces = false
                                options.parserSettings.shouldReportNamespacePrefixes = false
                                options.parserSettings.shouldResolveExternalEntities = false
                                let xmlDocument = try? AEXMLDocument(xml: response.data!, options: options)
                                
                                let popolbu = xmlDocument!.root["Document"].all
                                
                                if(popolbu != nil)
                                {
                                    for child in popolbu! {
                                        //                        print(child.name)
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
                                                        self.tempString = self.tempString.replacingOccurrences(of: "</strong>", with: "&")
                                                        self.infoArray  = self.tempString.components(separatedBy: "&")
                                                        
                                                        
                                                        carrotemp.setStatus(x: self.infoArray[0])
                                                        
                                                        carrotemp.setDireccion(x: self.infoArray[2])
                                                        
//                                                        print(self.infoArray)
                                                        
                                                        if(self.infoArray[2].contains("Speed :"))
                                                        {
                                                            carrotemp.setVelocidad(x: self.infoArray[2])
                                                        }
                                                        else
                                                        {
                                                            carrotemp.setVelocidad(x: self.infoArray[3])
                                                        }
                                                        
                                                            if(self.infoArray[0] == "Status : En Movimiento" && self.infoArray[2].contains("Speed :"))
                                                            {
                                                                let x = self.infoArray[2].replacingOccurrences(of: "Speed :", with: "").components(separatedBy: " ")
                                                                if(Float(x[1]) ?? 0.0 >= 10){
                                                                    carrotemp.setVelocidad(x: self.infoArray[2])
                                                                    carrotemp.setcolor(x: "verde")
                                                                }
                                                            }else if(self.infoArray[0] == "Status : En Movimiento" && self.infoArray[3].contains("Speed :"))
                                                            {
                                                                let x = self.infoArray[2].replacingOccurrences(of: "Speed :", with: "").components(separatedBy: " ")
                                                                if(Float(x[1]) ?? 0.0 >= 10){
                                                                    carrotemp.setVelocidad(x: self.infoArray[3])
                                                                    carrotemp.setcolor(x: "verde")
                                                                }
                                                            }
                                                            //                                                                cell.ultimavex.text = temp
                                                        
                                                        
                                                        //                                            if(self.infoArray[2].contains("Speed :"))
                                                        //                                            {
                                                        //                                                let x = self.infoArray[2].replacingOccurrences(of: "Speed :", with: "").components(separatedBy: " ")
                                                        ////                                                print(Float(x[1]) ?? 0.0)
                                                        //
                                                        //                                            }
                                                        //                                            else if(self.infoArray[6].contains("Speed :")){
                                                        //                                                let x = self.infoArray[6].replacingOccurrences(of: "Speed :", with: "").components(separatedBy: " ")
                                                        ////                                                print(Float(x[1]) ?? 0.0)
                                                        //                                            }
                                                        
                                                        
                                                        
                                                        //                                    print(self.tempString)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    self.infoArray = ["Err","Err","Err","Err","Err"]
                                }
                        }
                        
                        
                        self.vehiculos.append(carrotemp)
                        self.Vehiculos2 = self.vehiculos
                        DispatchQueue.main.sync (execute:{
                            self.tableView.reloadData()
                        })
                        indice += 1
                    }
                    //                    print(self.vehiculos)
                    
                    
                    //                    UserDefaults.standard.set(self.ArreglodeArreglos, forKey: "XD")
                    
                }catch {
                    
                    print("El Procesamiento del JSON tuvo un error")
                    
                }
                
            }
            
        }
        tarea3.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Vehiculos2.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CeldaCustomTablaCarros
        
        
        // Configure the cell...
        //        Alamofire.request("http://199.89.53.25/SmartDelivery/api/v1/reverseGeocode?latitud=\(Vehiculos2[indexPath.row].getlastvalidlatitude())&longitud=\(Vehiculos2[indexPath.row].getlastvalidlongitude())")
        //            .validate(statusCode: 200..<300)
        //            .validate(contentType: ["application/json"])
        //            .responseJSON(completionHandler: { response in
        //                if let json = response.result.value as? [String: String] {
        //                    cell.placa.text = json["posts"] // serialized json response
        //                    self.Vehiculos2[indexPath.row].setDireccion(x: json["posts"]!)
        //                }
        //            })
        //            .resume()
        //        n = n + 1
        //
        //        if(n >= Vehiculos2.count)
        //        {
        //            print(n)
        //            n = 0
        //        }
        //        UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
        //
        //        print("se ejecuta xd")
        //        Alamofire.request("http://192.227.91.57:8080/events/data.kml?a=\(self.user.getCuenta())&p=180octa523&d=\(Vehiculos2[indexPath.row].getdeviceID())&limit=1")
        //            .validate(statusCode: 200..<300)
        //            .validate(contentType: ["application/vnd.google-earth.kml+xml;charset=UTF-8"])
        //            .response { response in
        //                var options = AEXMLOptions()
        //                options.parserSettings.shouldProcessNamespaces = false
        //                options.parserSettings.shouldReportNamespacePrefixes = false
        //                options.parserSettings.shouldResolveExternalEntities = false
        //                let xmlDocument = try? AEXMLDocument(xml: response.data!, options: options)
        //
        //                let popolbu = xmlDocument!.root["Document"].all
        //
        //                if(popolbu != nil)
        //                {
        //                    for child in popolbu! {
        ////                        print(child.name)
        //                        for value in child.children
        //                        {
        //                            //                        print("estoy en el for 1")
        //                            //                        print("name: "+value.name+" value: "+value.value!)
        //
        //                            for style in value.children
        //                            {
        //                                //                            print("estoy en el for 2")
        //                                if(style.value == nil)
        //                                {
        //                                    //                                print("cuidao venia nil xd")
        //                                }
        //                                else{
        //                                    if(style.name == "description")
        //                                    {
        //                                        //                                    print("name: "+style.name+" value: "+style.value!)
        //                                        self.tempString = style.value!
        //                                        self.tempString = self.tempString.replacingOccurrences(of: "<strong>", with: "")
        //                                        self.tempString = self.tempString.replacingOccurrences(of: "<br>", with: "")
        //                                        self.tempString = self.tempString.replacingOccurrences(of: "</strong>", with: "&")
        //                                        self.infoArray  = self.tempString.components(separatedBy: "&")
        //                                        // And then to access the individual words:
        ////                                        print(self.infoArray)
        //
        //                                        if(self.Vehiculos2.count != 0)
        //                                        {
        ////                                            print("el indice es "+String(indexPath.row))
        ////                                            print(self.Vehiculos2[indexPath.row])
        ////                                            print(self.infoArray[2])
        //
        //                                            self.Vehiculos2[indexPath.row].setDireccion(x: self.infoArray[2])
        //                                            let temp = self.Vehiculos2[indexPath.row].getSeconds()
        //                                            let cant = self.Vehiculos2[indexPath.row].getSecondsPass()
        //                                            self.Vehiculos2[indexPath.row].setStatus(x: self.infoArray[0])
        //
        ////                                                print(self.Vehiculos2[indexPath.row].getdireccion())
        //                                                cell.placa.text = self.Vehiculos2[indexPath.row].getdireccion()
        //
        //
        //                                            if(cant >= 3600)
        //                                            {
        //                                                cell.foto.image = UIImage(named: "redcar")
        //                                                self.Vehiculos2[indexPath.row].setcolor(x: "rojo")
        //                                                //                                            break
        //                                            }
        //                                            else{
        //                                                cell.foto.image = UIImage(named: "Image")
        //                                                if(self.infoArray[0] == "Status : En Movimiento" && self.infoArray[2].contains("Speed :"))
        //                                                {
        //                                                    let x = self.infoArray[2].replacingOccurrences(of: "Speed :", with: "").components(separatedBy: " ")
        //                                                    if(Float(x[1]) ?? 0.0 >= 10){
        //                                                        self.Vehiculos2[indexPath.row].setcolor(x: "verde")
        //                                                        cell.foto.image = UIImage(named: "greencar")
        //                                                    }
        //                                                }else if(self.infoArray[0] == "Status : En Movimiento" && self.infoArray[6].contains("Speed :"))
        //                                                {
        //                                                    let x = self.infoArray[2].replacingOccurrences(of: "Speed :", with: "").components(separatedBy: " ")
        //                                                    if(Float(x[1]) ?? 0.0 >= 10){
        //                                                        self.Vehiculos2[indexPath.row].setcolor(x: "verde")
        //                                                        cell.foto.image = UIImage(named: "greencar")
        //                                                    }
        //                                                }
        //                                                cell.ultimavex.text = temp
        //                                            }
        //
        ////                                            if(self.infoArray[2].contains("Speed :"))
        ////                                            {
        ////                                                let x = self.infoArray[2].replacingOccurrences(of: "Speed :", with: "").components(separatedBy: " ")
        //////                                                print(Float(x[1]) ?? 0.0)
        ////
        ////                                            }
        ////                                            else if(self.infoArray[6].contains("Speed :")){
        ////                                                let x = self.infoArray[6].replacingOccurrences(of: "Speed :", with: "").components(separatedBy: " ")
        //////                                                print(Float(x[1]) ?? 0.0)
        ////                                            }
        //                                        }
        //
        //
        //                                        //                                    print(self.tempString)
        //                                    }
        //                                }
        //                            }
        //                        }
        //                    }
        //                }
        //                else
        //                {
        //                    self.infoArray = ["Err","Err","Err","Err","Err"]
        //                }
        //        }
        
//        print(Vehiculos2[indexPath.row].getVelocidad())
        

        
        
        cell.placa.text = Vehiculos2[indexPath.row].getdireccion()
        cell.nombre.text = Vehiculos2[indexPath.row].getdescription()
        let temp = Vehiculos2[indexPath.row].getSeconds()
        let cant = Vehiculos2[indexPath.row].getSecondsPass()
        
        cell.foto.image = UIImage(named: "Image")
        cell.ultimavex.text = temp
        
        if Vehiculos2[indexPath.row].getVelocidad().contains("Err") == false {
            let x = Vehiculos2[indexPath.row].getVelocidad().replacingOccurrences(of: "Speed :", with: "").components(separatedBy: " ")
            if(Float(x[1]) ?? 0.0 >= 10 && Vehiculos2[indexPath.row].getStatus().contains("En Movimiento")){
                cell.foto.image = UIImage(named: "greencar")
                cell.placa.text = Vehiculos2[indexPath.row].getdireccion()+Vehiculos2[indexPath.row].getVelocidad()
            }
        }
        if(cant >= 3600 && cant <= 600000)
        {
            cell.foto.image = UIImage(named: "redcar")
            cell.ultimavex.text = temp
            cell.placa.text = Vehiculos2[indexPath.row].getdireccion()
            
        }else if(cant >= 600000){
            
            cell.foto.image = UIImage(named: "redcar")
            cell.ultimavex.text = Vehiculos2[indexPath.row].getlasteventtimestrap()
            cell.placa.text = Vehiculos2[indexPath.row].getdireccion()
        }
        
        
        //        print(Vehiculos2[indexPath.row].getdeviceID())
        //        cell.ultimavex.text = Vehiculos2[indexPath.row].getlasteventtimestrap()
        //        cell.placa.text = Vehiculos2[indexPath.row].getLicenseplate()
        
        //        UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
        
        return cell
    }
    private func SetUpSerachBar()
    {
        BarraBusqueda.delegate = self
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Vehiculos2 = vehiculos.filter({ vehiculo -> Bool in
            
            switch BarraBusqueda.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true }
                return vehiculo.getdescription().lowercased().contains(searchText.lowercased()) || vehiculo.getdeviceID().lowercased().contains(searchText.lowercased()) || vehiculo.getLicenseplate().lowercased().contains(searchText.lowercased())
            default:
                return false
                
            }
        })
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let carroseleccionado = Vehiculos2[indexPath.row]
        self.performSegue(withIdentifier: "mapa", sender: carroseleccionado)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapa"
        {
            let carroseleccionadorecibido = sender as! vehiculo
            let objetopantalla3:MapaAldetalle = segue.destination as! MapaAldetalle
            objetopantalla3.VehiculoSeleccionado = carroseleccionadorecibido
        }
    }
    
    @IBAction func RecargarLista(_ sender: UIBarButtonItem) {
        cargartabla()
    }
    
    func StatusVehiculo(x:String){
        Alamofire.request("http://192.227.91.57:8080/events/data.kml?a=octagonogps&p=180octa523&d="+x+"&limit=1")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/vnd.google-earth.kml+xml;charset=UTF-8"])
            .response { response in
                var options = AEXMLOptions()
                options.parserSettings.shouldProcessNamespaces = false
                options.parserSettings.shouldReportNamespacePrefixes = false
                options.parserSettings.shouldResolveExternalEntities = false
                let xmlDocument = try? AEXMLDocument(xml: response.data!, options: options)
                
                let popolbu = xmlDocument!.root["Document"].all
                
                if(popolbu != nil)
                {
                    for child in popolbu! {
                        //                        print(child.name)
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
                                        self.infoArray  = self.tempString.components(separatedBy: ",")
                                        // And then to access the individual words:
                                        //                                        print(self.infoArray)
                                        //                                    print(self.tempString)
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    self.infoArray = ["Err","Err","Err","Err","Err"]
                }
        }
    }
}
