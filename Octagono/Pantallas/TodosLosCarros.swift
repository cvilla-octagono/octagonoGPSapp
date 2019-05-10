//
//  TodosLosCarros.swift
//  Octagono
//
//  Created by Christian Villa Rhode on 2/3/19.
//  Copyright © 2019 Christian Villa Rhode. All rights reserved.
//

import UIKit
import MapKit

class TodosLosCarros: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var location:CLLocationCoordinate2D?
    var ArregloDeVehiculos:NSArray?
    var VehiculoSeleccionado:NSDictionary?
    var selectedAnnotation: MKPointAnnotation?
    var locationuser:CLLocationCoordinate2D?
    let locationManager = CLLocationManager()

    @IBOutlet weak var mapa: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ArregloDeVehiculos = UserDefaults.standard.array(forKey: "carros")! as NSArray
//        ArregloDeVehiculos = []
        mapa.delegate = self
        mapa.mapType = .hybrid
//        print(ArregloDeVehiculos![0])
        for(index,_) in (ArregloDeVehiculos?.enumerated())!
        {
            VehiculoSeleccionado = ArregloDeVehiculos![index] as? NSDictionary
//                        print(VehiculoSeleccionado!)
            ActualizarPunto(Latitude: VehiculoSeleccionado!["lastValidLatitude"] as! NSString, Longitude:  VehiculoSeleccionado!["lastValidLongitude"] as! NSString)
        }
//            mapa.showsUserLocation = false
//            locationManager.requestAlwaysAuthorization()
//            locationManager.requestWhenInUseAuthorization()
//            
//            if CLLocationManager.locationServicesEnabled() {
//                locationManager.delegate = self
//                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//                locationManager.startUpdatingLocation()
//            }
//            mapa.showsUserLocation = false
            // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
    }
    
    
    func ActualizarPunto(Latitude:NSString, Longitude:NSString)
    {
        self.location = CLLocationCoordinate2D(latitude: (Latitude).doubleValue,longitude: (Longitude).doubleValue)
        //        let span = MKCoordinateSpanMake(0.099,0.099)
        //        let region = MKCoordinateRegionMake(self.location!, span)
        //        MapView.setRegion(region, animated: true)
        let anotation = MKPointAnnotation()
        anotation.coordinate = self.location!
        anotation.title = VehiculoSeleccionado!["description"] as? String
        anotation.subtitle = VehiculoSeleccionado!["licensePlate"] as? String
        mapa.addAnnotation(anotation)
//        selectedAnnotation = anotation
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        self.selectedAnnotation = view.annotation as? MKPointAnnotation
        let span = MKCoordinateSpan(latitudeDelta: 0.003,longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: (selectedAnnotation?.coordinate)!, span: span)
        mapa.setRegion(region, animated: true)
        if((selectedAnnotation?.accessibilityElementIsFocused())!)
        {
            let alert = UIAlertController(title: "Menu", message: "Seleccione una opcion", preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))


            alert.addAction(UIAlertAction(title: "Buscar Carro", style: .default, handler: { (BucarCarro) in
                UIApplication.shared.openURL(NSURL(string: "https://www.google.com/maps/dir/?api=1&origin=\(self.locationuser!.latitude),\(self.locationuser!.longitude)+&destination=\(self.selectedAnnotation!.coordinate.latitude),\(self.selectedAnnotation!.coordinate.longitude)+&travelmode=automobile")! as URL)
            }))

            self.present(alert, animated: true)

        }
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        self.selectedAnnotation = view.annotation as? MKPointAnnotation
        let span = MKCoordinateSpan(latitudeDelta: 2.5,longitudeDelta: 2.5)
        //        print(selectedAnnotation?.coordinate)
        let region = MKCoordinateRegion(center: (selectedAnnotation?.coordinate)!, span: span)
        mapa.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var anotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if anotationView == nil {
            anotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        anotationView?.image = UIImage(named:"peke")
        
//        if (VehiculoSeleccionado?.getSecondsPass())! >= 3600
//        {
//            anotationView?.image = UIImage(named:"redcarpeke")
//        }
//        else if VehiculoSeleccionado!.getVelocidad().contains("Err") == false {
//            let x = VehiculoSeleccionado!.getVelocidad().replacingOccurrences(of: "Speed :", with: "").components(separatedBy: " ")
//            if(Float(x[1]) ?? 0.0 >= 10 && VehiculoSeleccionado!.getStatus().contains("En Movimiento")){
//                anotationView?.image = UIImage(named:"pekegreen")
//                gameTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(actualizarpunto), userInfo: nil, repeats: true)
//            }
//        }
            //        else if (VehiculoSeleccionado?.getStatus().contains("En Movimiento"))!
            //        {
            //            anotationView?.image = UIImage(named:"pekegreen")
            //            gameTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(actualizarpunto), userInfo: nil, repeats: true)
            //        }
            
//        else if VehiculoSeleccionado!.getVelocidad().contains("Err") == false {
//            let x = VehiculoSeleccionado!.getVelocidad().replacingOccurrences(of: "Speed :", with: "").components(separatedBy: " ")
//            if(Float(x[1]) ?? 0.0 >= 10 && VehiculoSeleccionado!.getStatus().contains("En Movimiento")){
//
//                anotationView?.image = UIImage(named:"pekegreen")
//                gameTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(actualizarpunto), userInfo: nil, repeats: true)
//            }
//        }
        
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
