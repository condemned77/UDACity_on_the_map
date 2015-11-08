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
    var studentLocations : [ParseAPIClient.StudentMapData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.studentLocations = (self.tabBarController as! MapTabbarController).studentLocations
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
        let studentName = "\(self.studentLocations![indexPath.row].firstName) \(self.studentLocations![indexPath.row].lastName)"
        cell!.textLabel?.text = studentName
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentLocations!.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = self.studentLocations![indexPath.row].mediaURL
        self.openURLInSafari(url)
    }
    
    
    func openURLInSafari(url : String) {
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
}