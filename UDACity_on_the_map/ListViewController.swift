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
        self.refreshStudentLocations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = self.mapPinTableView.dequeueReusableCellWithIdentifier("MapPinCell")
        
        if cell == nil {
            cell = UITableViewCell()
        }
        let studentName = "\(ParseAPIClient.studentLocations[indexPath.row].firstName) \(ParseAPIClient.studentLocations[indexPath.row].lastName)"
        cell!.textLabel?.text = studentName
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseAPIClient.studentLocations.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = ParseAPIClient.studentLocations[indexPath.row].mediaURL
        self.openURLInSafari(url)
    }
    
    
    func openURLInSafari(url : String) {
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    
    func refreshStudentLocations() {
        ParseAPIClient.requestStudentLocations() {
            (studentLocations, error) in
            guard nil == error else {Helpers.showAlertView(withMessage: error!.domain, fromViewController: self, withCompletionHandler: nil); return}
        }
        self.tableView.reloadData()
        print("refreshed list")
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


    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        self.refreshStudentLocations()
    }
}