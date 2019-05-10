//
//  Vehiculo.swift
//  Octagono
//
//  Created by Christian Villa Rhode on 1/31/19.
//  Copyright © 2019 Christian Villa Rhode. All rights reserved.
//

import Foundation

class vehiculo{
    
    var deviceID:String?
    var accoundID:String?
    var description:String?
    var lastOdometerKM:String?
    var odometerOffsetKM:String?
    var lastValidLatitude:String?
    var lastValidLongitude:String?
    var lastEventTimestamp:String?
    var vehicleID:String?
    var licensePlate:String?
    var lastNotifyTime:String?
    var NumeroTelefono:String?
    var direccion:String = "Err"
    var color = "azul"
    
    var status:String = "Err"
    var velocidad:String = "Err"
    var UltimosPuntos:[String] = []
    
    func setcolor(x:String){
        color = x
    }
    
    func getcolor() -> String{
        return color
    }
    
    func setVelocidad(x:String){
        velocidad = x.replacingOccurrences(of: "Speed :", with: "")
    }
    
    func getVelocidad()->String{
        return velocidad
    }
    
    func setStatus(x:String){
        status = x.replacingOccurrences(of: "Status :", with: "")
    }
    
    func getStatus()->String{
        return status
    }
    
    func getdireccion() -> String
    {
        return direccion
    }
    
    func setDireccion(x:String) {
        direccion = x.replacingOccurrences(of: "Address :", with: "")
    }
    
    func setNumero(x:String)
    {
        NumeroTelefono = x
    }
    
    func GetNum() -> String
    {
        return NumeroTelefono!
    }
    
    func setdeviceID(x:String)
    {
        deviceID = x
    }
    
    func setaccoundID(x:String)
    {
        accoundID = x
    }
    
    func setdescription(x:String)
    {
        description = x
    }
    
    func setlastOdometerKM(x:String)
    {
        lastOdometerKM = x
    }
    
    func setLastvalidLT(x:String)
    {
        lastValidLatitude = x
    }
    func setLastvalidLG(x:String)
    {
        lastValidLongitude = x
    }
    func setLastEventTimestrap(x:String)
    {
        lastEventTimestamp = x
    }
    func setvehicleID(x:String)
    {
        vehicleID = x
    }
    func setLicensePlate(x:String)
    {
        licensePlate = x
    }
    func setLastnotifytime(x:String)
    {
        lastNotifyTime = x
    }
    func getdeviceID() -> String {
        return deviceID!
    }
    func getaccountID() -> String {
        return accoundID!
    }
    func getdescription() -> String {
        return description!
    }
    func getlastodometer() -> String {
        return lastOdometerKM!
    }
    func getodometerOOfset() -> String {
        return odometerOffsetKM!
    }
    func getlastvalidlatitude() -> Double {
        return Double(lastValidLatitude!)!
    }
    func getlastvalidlongitude() -> Double {
        return Double(lastValidLongitude!)!
    }
    func getlasteventtimestrap() -> String {
        let Date:DateParser = DateParser()
        return Date.DateParser(tempDate: lastEventTimestamp! as NSString)
    }
    func getvehicleID() -> String {
        return vehicleID!
    }
    func getLicenseplate() -> String {
        return licensePlate!
    }
    func getlastnotify() -> String {
        let Date:DateParser = DateParser()
        return Date.DateParser(tempDate: lastNotifyTime! as NSString)
    }
    func getSeconds() -> String{
        let Date:DateParser = DateParser()
        return Date.IntervaloDeFecha(JsonNumber:lastEventTimestamp! as NSString)
    }
    func getSecondsPass() -> Int{
        let Date:DateParser = DateParser()
        return Date.CantidadDeSegundo(x: lastEventTimestamp! as NSString)
    }
}
