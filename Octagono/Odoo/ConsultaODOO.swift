////
////  ConsultaODOO.swift
////  Octagono
////
////  Created by Christian Villa Rhode on 1/31/19.
////  Copyright © 2019 Christian Villa Rhode. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import AlamofireXMLRPC
//import AEXML
//
//func odoorequest()
//{
//    
//    //        let paramsAuth = ["OctagonoGPS", "jromero@octagono.com.do", "25069825",[]] as [Any]
//    let paramsAuthMethod = ["octagono", "8", "25069825","res.partner", "search_read",
//                            [[["x_studio_field_ddQ6z","=",""]]],
//                            ["fields":["name","x_studio_field_ddQ6z","credit"]]] as [Any]
//    
//    
//    //        let paramsAuth = [] as [Any]
//    AlamofireXMLRPC.request("https://octagono.com.do/xmlrpc/2/object", methodName: "execute_kw", parameters: paramsAuthMethod).responseXMLRPC{
//        (response: DataResponse<XMLRPCNode>) -> Void in
//        switch response.result {
//        case .success( _):
//            print("Auth Success")
//            
//            let str = String(data: response.data!, encoding: String.Encoding.utf8) as String?
//            //            print(str!)
//            let options = AEXMLOptions()
//            let xmlDoc = try? AEXMLDocument(xml: (str?.data(using: .utf8))!, options: options)
//            //                print(xmlDoc!.xml as String)
//            for member in (xmlDoc?.root["params"]["param"]["value"]["array"]["data"]["value"]["struct"]["member"].all!)! {
//                if(member["value"]["double"].value != nil)
//                {
//                    print(member["value"]["double"].value!)
//                    self.StringObligado = member["value"]["double"].value! as String
//                }
//            }
//            //            let json = try? JSONSerialization.jsonObject(with: str, options: options)
//            //                print()
//            
//            //            print(str?.contains("abodom"))
//            break
//        case .failure(let error):
//            print("Auth Error", error)
//            //                let str = String(data:response.data!, encoding: String.Encoding.utf8) as String?
//            //                let options = AEXMLOptions()
//            //            let xmlDoc = try? AEXMLDocument(xml: (str?.data(using: .utf8))!,options: options)
//            //            print(xmlDoc!.xml)
//            break
//        }
//    }
//}
