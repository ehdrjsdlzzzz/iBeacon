//
//  MainVC.swift
//  iBeacon Sample
//
//  Created by 이동건 on 2018. 3. 19..
//  Copyright © 2018년 이동건. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class MainVC: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate{

    var count:Int = 0
    let locationManager = CLLocationManager()
    @IBOutlet weak var mainLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        setupLocationManager()
    }
    
    //MARK:- LocationManager Setting
    fileprivate func setupLocationManager(){
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func rangeBeacons(){
        guard let uuid = UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935") else {return}
        let major:CLBeaconMajorValue = UInt16(10001)
        let minor:CLBeaconMinorValue = UInt16(19641)
        let identifier = "com.myhouse"
        let region = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
        region.notifyEntryStateOnDisplay = true
        region.notifyOnExit = true
        region.notifyOnEntry = true
        locationManager.startRangingBeacons(in: region)
        locationManager.startMonitoring(for: region)
    }

}
//MARK:- User Notification
extension MainVC {
    func localNotification(title: String, body: String){
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
        content.sound = UNNotificationSound.default()
        let request = UNNotificationRequest(identifier: "iBeacon", content: content, trigger: nil)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
//MARK:- Location Manager Delegate
extension MainVC {
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .inside {
            localNotification(title: "Inside", body: "Your in iBeacon's Region")
            print("inside")
        }else if state == .outside {
            localNotification(title: "Outside", body: "Bye Bye")
            print("outside")
        }else if state == .unknown {
            print("unknown")
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            rangeBeacons()
        }
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard let discoverBeacon = beacons.first?.proximity else {print("Couldn't find the beacon!"); return}
        count += 1
        let backgroundColor: UIColor = {
            switch discoverBeacon {
            case .immediate:
                print("immediate")
                if count % 7 == 0 {
                    localNotification(title: "Immediate", body: "Close!")
                }
                self.mainLabel.text = "immediate"
                return UIColor.green
            case .near:
                print("near")
                if count % 7 == 0 {
                    localNotification(title: "Near", body: "Almost close!")
                }
                self.mainLabel.text = "near"
                return UIColor.orange
            case .far:
                print("far")
                if count % 7 == 0 {
                    localNotification(title: "Far", body: "Too far!")
                }
                self.mainLabel.text = "far"
                return UIColor.red
            case .unknown:
                print("unknown")
                self.mainLabel.text = "unknown"
                return UIColor.black
            }
        }()
        view.backgroundColor = backgroundColor
    }
}

