//
//  FirstViewController.swift
//  UDACity_on_the_map
//
//  Created by jason on 25/10/15.
//  Copyright © 2015 jason. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var map: MKMapView!
    var parseAPIClient : ParseAPIClient
    var mapTabbarController : MapTabbarController?
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        self.parseAPIClient = ParseAPIClient()
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        self.parseAPIClient = ParseAPIClient()
        super.init(coder: aDecoder)
        self.mapTabbarController = self.tabBarController as? MapTabbarController
    }
    
    
    /*Process: when the map is loaded, the following process shall be handled in this method:
    1. load relevant student location data from the parseAPI.
    2. make sure  the data is valid (guards)
    3. create pins for the map (MKPointAnnotaion)
    4. Add them to the map instance.*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
        dispatch_async(dispatch_get_main_queue(), {
            self.loadStudentLocationsToMap()
        })
    }
    
    
    func loadStudentLocationsToMap() {
        parseAPIClient.requestStudentLocation() {
            (json_data, error) in
            
            guard let json_dict = json_data as? NSDictionary else {print("couldn't cast json data"); return}
            guard let student_list = json_dict["results"] as? [NSDictionary] else {print("couldn't find student data"); return}
            
            for student in student_list {
                let student_struct : ParseAPIClient.StudentMapData = ParseAPIClient.createPinAnnotation(with: student)
                (self.tabBarController as! MapTabbarController).studentLocations.append(student_struct)
                let pin_annotation = self.createPinAnnotation(fromStudentMapData: student_struct)
                self.map.addAnnotation(pin_annotation)
            }
        }
    }
    
    
    func createPinAnnotation(fromStudentMapData studentMapData :  ParseAPIClient.StudentMapData) -> MKPointAnnotation {
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: studentMapData.latitude, longitude: studentMapData.longitude)
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(studentMapData.firstName) \(studentMapData.lastName)"
        annotation.subtitle = studentMapData.mediaURL
        
        return annotation
    }

    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let urlString = annotationView.annotation?.subtitle {
                app.openURL(NSURL(string: urlString!)!)
            }
        }
    }

    
    @IBAction func pinButtonPressed (sender: UIBarButtonItem) {
        
    }
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        self.loadStudentLocationsToMap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}