//
//  SecondViewController.swift
//  UDACity_on_the_map
//
//  Created by jason on 25/10/15.
//  Copyright © 2015 jason. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mapPinTableView: UITableView!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        print("list view did appear")
//        self.refreshStudentLocations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*Callback methdo for populating table view cells.*/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = self.mapPinTableView.dequeueReusableCellWithIdentifier("MapPinCell")
        
        if cell == nil {
            cell = UITableViewCell()
        }
        let studentName = "\(ParseAPIClient.studentLocations[indexPath.row].firstName!) \(ParseAPIClient.studentLocations[indexPath.row].lastName!)"
        cell!.textLabel?.text = studentName
        
        return cell!
    }
    
    /*Callback method for returning the amount of table rows (corresponds to amount
    of student locations)*/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("amount of rows: \(ParseAPIClient.studentLocations.count)")
        return ParseAPIClient.studentLocations.count
    }
    
    /*Callback method for handling clicks on the table rows.*/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = ParseAPIClient.studentLocations[indexPath.row].mediaURL!
        self.openURLInSafari(url)
    }
    
    /*Convenience method for opening a URL (as string) in safari.*/
    func openURLInSafari(url : String) {
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    /*Uses the ParseAPIClient to request student locations.
    When location are received, the data is used to refresh the list content.*/
    func refreshStudentLocations() {
        ActivityIndicator.sharedInstance.showActivityIndicator(fromViewController: self)
        ParseAPIClient.requestStudentLocations() {
            (studentLocations, error) in
            guard nil == error else {Helpers.showAlertView(withMessage: error!.domain, fromViewController: self, withCompletionHandler: nil); return}
            self.refreshTableOnMainThread()
            ActivityIndicator.sharedInstance.dismissActivityIndicator(fromViewController: self)
        }
        
        print("refreshed list")
    }
    
    func refreshTableOnMainThread() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }

    /*finishing logout by dismissing the viewController from the main thread.*/
    func finishLogout() {
        dispatch_async(dispatch_get_main_queue(), { () in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    
    /*Logging out of the app, by telling the UDACityClient to logout.
    Afterwards the view is dismissed and the login view is shown again.*/
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        UDACityClient.sharedInstance().logoutFromUDACitySession() {
            (success, error) in
            guard error == nil else {
                Helpers.showAlertView(withMessage: error!.domain, fromViewController: self) {
                    self.finishLogout()
                }
                return
            }
            self.finishLogout()
        }
    }

    /*IBAction which refreshes the map data by aclling loadStudentLocationsToMap*/
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        self.refreshStudentLocations()
    }
}