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
    var mapTabbarController : MapTabbarController? {
        get {
            return self.tabBarController as? MapTabbarController
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        print("Map view did appear")
        self.loadStudentLocationsToMap()
    }
    
    
    /*When the map is loaded, the following process shall be handled in this method:
    1. load relevant student location data from the parseAPI.
    2. make sure  the data is valid (guards)
    3. create pins for the map (MKPointAnnotaion)
    4. Add them to the map instance.*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
//        dispatch_async(dispatch_get_main_queue(), {
//            self.loadStudentLocationsToMap()
//        })
    }

    
    func loadStudentLocationsToMap() {
        ParseAPIClient.requestStudentLocations() {
            (studentLocations, error) in
            guard error == nil else {
                print("error while download student locations: \(error)");
                Helpers.showAlertView(withMessage: "Error while downloading student locations", fromViewController: self, withCompletionHandler: nil)
                return
            }
            self.refreshMap(with: studentLocations)
        }
    }
    

    /*This method refreshes the map pins with the information passed in as
    argument*/
    func refreshMap(with studentLocations : [ParseAPIClient.StudentMapData]) {
        dispatch_async(dispatch_get_main_queue(), {
            self.map.removeAnnotations(self.map.annotations)
            for student_struct in studentLocations {
                let pin_annotation = self.createPinAnnotation(fromStudentMapData: student_struct)
                self.map.addAnnotation(pin_annotation)
            }
        })
        
        print("refreshed map pins")
    }

    
    func createPinAnnotation(fromStudentMapData studentMapData :  ParseAPIClient.StudentMapData) -> MKPointAnnotation {
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: studentMapData.latitude!, longitude: studentMapData.longitude!)
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(studentMapData.firstName!) \(studentMapData.lastName!)"
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
            if var urlString = annotationView.annotation?.subtitle! {
                if urlString.containsString("http://") == false {
                    urlString = "http://\(urlString)"
                }
                app.openURL(NSURL(string: urlString)!)
            }
        }
    }

    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        UDACityClient.sharedInstance().logoutFromUDACitySession() {
            (success, error) in
            guard error == nil else {
                Helpers.showAlertView(withMessage: error!.domain, fromViewController: self) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                return
            }
            self.dismissViewControllerAnimated(true, completion: nil)
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