//
//  MapViewController.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 11/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, LocationModelDelegate {

    @IBOutlet weak var mapView: MKMapView?
    
    let regionRadius: CLLocationDistance = 100

    var model: LocationModel?
    
    
    // listens to when the model gets updated (i.e. when a new opponent's location is added)
    func modelListener() {
        // check to see if this MapView is visible on screen before doing any UI stuff
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // reframe region around player
        let region = MKCoordinateRegionMakeWithDistance((model?.playerLocation!.coordinate)!, regionRadius * 2.0, regionRadius * 2.0)
        mapView?.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
