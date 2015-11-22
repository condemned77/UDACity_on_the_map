//
//  InformationPostingViewController.swift
//  UDACity_on_the_map
//
//  Created by jason on 11/11/15.
//  Copyright © 2015 jason. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationPostingViewController : UIViewController, UITextFieldDelegate {

    var studentLocation : ParseAPIClient.StudentMapData = ParseAPIClient.StudentMapData(with: [:])

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var whereAreYouLabel: UILabel!
    @IBOutlet weak var insertLocationView: UIView!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var locationTextField : UITextField!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    @IBOutlet weak var urlTextField: UITextField!
    
    /*Pressing the cancel button dismisses the whole view controller.*/
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func viewDidLoad() {
        self.locationTextField.delegate = CommonTextFieldDelegate.sharedInstance()
    }
    
    /*When the findOnTheMapButton is pressed, the UI has to change. The UI will be rearranged
    in such a way that the student can now enter a URL when his previously entered location
    is found. Also the button text does change to "Submit" since it's re-used for finally 
    setting his pin to the map and his data to the ParseAPI servers.*/
    @IBAction func findOnMapButtonPressed(sender: UIButton) {
        
        if self.findOnTheMapButton.titleLabel?.text == "Submit" {
            self.submitStudentPin()
        }
        else { //find on the map button text
            if let location = self.locationTextField.text {
                if location == "" {
                    Helpers.showAlertView(withMessage: "You didn't enter a location.", fromViewController: self, withCompletionHandler: nil)
                    return
                }
                self.findLocation(fromString: location)
            }
        }
    }
    
    /*The method reads the url entered in the
    corresponding textfield stores it in the student's data container and
    calls the parseAPI convenience method for posting the student data via
    HTTP.*/
    func submitStudentPin(){
        let studentURL = self.urlTextField.text
        self.studentLocation.mediaURL = studentURL
        ParseAPIClient.addStudentLocationToParseAPI(self.studentLocation) {
            (success, error) in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                Helpers.showAlertView(withMessage: "Coudln't post location: \(error)", fromViewController: self, withCompletionHandler: nil)
            }
        }
    }
        
    /*This method searches the location based on the string argument. If a location is found (via CLGecoder), the map zooms to the 
    location found. Since the CLGeocoder instance returns multiple locations, the first one returned is used, for simplicity sake.
    If the location isn't found, an alertview is presented.*/
    func findLocation(fromString location : String) {
        //search for location and set it to the map.
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.locationTextField.text!) {
            (placemarks, error) in
            Helpers.showActivityIndicator(fromViewController: self)
            guard error == nil else {
                print(error)
                Helpers.showAlertView(withMessage: "Couldn't find any location based on the string: \(self.locationTextField.text!)\n Please enter another string.", fromViewController: self, withCompletionHandler: nil)
                return
            }
            
            print("found location for \(location): \(placemarks)")
            
            if let placemark = placemarks?[0] {
                // set the student location
                self.setStudentLocation(withPlacemark: placemark, location: location, andUniqKey: UDACityClient.sharedInstance().udaCityAccountID!)
                
                
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                // zoom on the selected location
                let span = MKCoordinateSpanMake(0.01, 0.01)
                let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                self.rearrangeUIToSubmitView()
                Helpers.dismissActivityIndicator(fromViewController: self)
                
            } else {
                Helpers.showAlertView(withMessage: "Server didn't return any locations", fromViewController: self, withCompletionHandler: {self.dismissViewControllerAnimated(true, completion: nil)})
            }
            //                ActivityIndicator.shared.hide()
        }
    }
    
    
    /*Convenience method that will store passed in coordinates, location string, and a unique key to the student information
    of this class. Also the student's first and last name is taken from the UDACityClient singleton and stored for posting
    the student data to the ParseAPI servers*/
    func setStudentLocation(withPlacemark placemark : CLPlacemark, location : String, andUniqKey : String) {
        self.studentLocation.latitude   = placemark.location?.coordinate.latitude
        self.studentLocation.longitude  = placemark.location?.coordinate.longitude
        self.studentLocation.uniqueKey  = andUniqKey
        self.studentLocation.mapString  = location
        self.studentLocation.firstName  = UDACityClient.sharedInstance().firstName
        self.studentLocation.lastName   = UDACityClient.sharedInstance().lastName
    }
    
    
    /*This method rearranges the UI according to the prerequisites by UDACity.
    The map is made visible, while the view where a location string can be inserted is hidden.
    The map spans towards to bottom of the device, while the bottom view is made transparent and
    the findOnTheMapButton text is changed to submit. Also the color of the title view is changed.*/
    func rearrangeUIToSubmitView() {
        self.mapView.hidden = false
        self.insertLocationView.hidden = true
        self.bottomView.alpha = 0.6
        self.findOnTheMapButton.setTitle("Submit", forState: .Normal)
        
        self.toggleToolbarColor()
        self.toggleTitleViewContent()
    }
    
    
    /*Convenience method for switching between two title view contents.*/
    func toggleTitleViewContent() {
        self.toggleTitleViewBackgroundColor()
        self.togglelabels()
        self.urlTextField.hidden = !self.urlTextField.hidden
        self.urlTextField.tintColor = Helpers.AppColorBlue
    }
    
    /*Convenience method for toggling the background color of the title view
    between blue and grey.*/
    func toggleTitleViewBackgroundColor() {
        if self.insertLocationView.hidden {
            self.titleView.backgroundColor = Helpers.AppColorBlue
        } else {
            self.titleView.backgroundColor = Helpers.AppColorGrey
        }
    }
    
    
    /*Convenience method for changing the toolbar colors back and forth,
    based on whether the insertLocationView is visible or not.*/
    func toggleToolbarColor() {
        if self.insertLocationView.hidden {
            self.toolbar.barTintColor = Helpers.AppColorBlue //blue
            self.cancelButton.tintColor = UIColor.whiteColor()
        } else {
            self.toolbar.barTintColor = Helpers.AppColorGrey //grey
            self.cancelButton.tintColor = Helpers.AppColorBlue
        }
    }
    
    
    /*Convenience method for hiding and showing the labels displaying:
    "where are you studying today?"*/
    func togglelabels() {
        self.whereAreYouLabel.hidden    = !self.whereAreYouLabel.hidden
        self.studyingLabel.hidden       = !self.studyingLabel.hidden
        self.todayLabel.hidden          = !self.todayLabel.hidden
    }
}