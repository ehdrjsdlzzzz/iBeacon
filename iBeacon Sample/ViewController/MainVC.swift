//
//  MainVC.swift
//  iBeacon Sample
//
//  Created by 이동건 on 2018. 3. 19..
//  Copyright © 2018년 이동건. All rights reserved.
//

import UIKit
import CoreLocation

class MainVC: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var mainLabel: UILabel!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func rangeBeacons(){
        guard let uuid = UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825") else {return}
        let major:CLBeaconMajorValue = UInt16(10001)
        let minor:CLBeaconMinorValue = UInt16(19641)
        let identifier = "com.myhouse"
        let region = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
        locationManager.startRangingBeacons(in: region)
    }
}
// MARK:- Location Manager Delegate
extension MainVC {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            rangeBeacons()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard let discoverBeacon = beacons.first?.proximity else {print("Couldn't find the beacon!"); return}
        let backgroundColor: UIColor = {
            switch discoverBeacon {
            case .immediate:
                self.mainLabel.text = "immediate"
                return UIColor.green
            case .near:
                self.mainLabel.text = "near"
                return UIColor.orange
            case .far:
                self.mainLabel.text = "far"
                return UIColor.red
            case .unknown:
                self.mainLabel.text = "unknown"
                return UIColor.black
            }
        }()
        
        view.backgroundColor = backgroundColor
    }
}
