//
//  LocationManager.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/22.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

class LocationManager: NSObject,CLLocationManagerDelegate {
    private static var instance:LocationManager? = nil
    private static var onceToken:dispatch_once_t = 0
    var manager:CLLocationManager? = nil
    var currentLocation:String? = nil
    var geoDes:String? = nil
    var geoCoder:CLGeocoder? = nil
    
    let currentUser = UserModel.getCurrentUser()
    
    class var sharedInstance: LocationManager {
        dispatch_once(&onceToken) { () -> Void in
            instance = LocationManager()
        }
        return instance!
    }
    
    func getAuthorization(){
        let status = CLLocationManager.authorizationStatus()
        switch(status){
        case .NotDetermined:
            self.manager!.requestWhenInUseAuthorization()
            
        case .AuthorizedAlways:
            print("succeed always")
            
        case .AuthorizedWhenInUse:
            print("succeed whenInUse")
            
        default:
            print("false")
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
        case .AuthorizedWhenInUse:
            self.manager!.requestWhenInUseAuthorization()
        case .AuthorizedAlways:
            self.manager!.requestAlwaysAuthorization()
        default:
            self.manager?.requestWhenInUseAuthorization()
        }
    }
    
    func setupLocation(){
        if self.manager == nil{
            self.manager = CLLocationManager()
        }
        self.manager!.delegate = self
        self.getAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.manager!.distanceFilter = 1.0
            self.manager!.desiredAccuracy = kCLLocationAccuracyBest
            self.manager!.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let coordinate = location?.coordinate
        self.currentLocation = "\(coordinate?.latitude),\(coordinate?.longitude)"
        self.getGeoDes(location!)
    }
    
    func getGeoDes(location:CLLocation) {
//        let languages = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages") as! NSArray
//        NSUserDefaults.standardUserDefaults().setObject(["en"], forKey: "AppleLanguages")
//        NSUserDefaults.standardUserDefaults().synchronize()
        geoCoder = CLGeocoder()
        geoCoder!.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if placemarks != nil {
                let mark = placemarks![0]

                self.geoDes = "\(mark.addressDictionary!["City"] as! String),\(mark.country! as String)"
                guard (self.currentUser != nil) else{
                    return
                }
                if self.currentUser?.countryName == nil || self.currentUser?.countryName == "" {
                    let country = mark.country!
                    self.currentUser?.countryName = country
                    CoreDataManager.sharedInstance.increaseOrUpdateUser(self.currentUser!)
                    self.updateItem(country)
                }
//               NSUserDefaults.standardUserDefaults().setObject(languages, forKey: "AppleLanguages")
            }
        }
    }
    
    func updateItem(country:String){
        var dic = [String:AnyObject]()
        dic["accountId"] = currentUser?.id
        dic["countryName"] = country
        SocketManager.sharedInstance.sendMsg("accountUpdate", data: dic, onProto: "accountUpdateed") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                self.currentUser?.countryName = country
                CoreDataManager.sharedInstance.increaseOrUpdateUser(self.currentUser!)
            }
        }
    }
    
    deinit{
        self.geoCoder = nil
    }
}
