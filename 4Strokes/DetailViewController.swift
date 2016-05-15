//
//  DetailViewController.swift
//  4Strokes
//
//  Created by Kevin Westropp on 3/13/15.
//  Copyright (c) 2015 KPW. All rights reserved.
//

import UIKit
import AddressBookUI

/**
 * Main Detail View Controller
 */
class DetailViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate {

    @IBOutlet weak var detailNavigationItem: UINavigationItem!
    @IBOutlet var tapView: UIView?
    @IBOutlet var swipeView: SmoothedBIView?
    let tapRec = UITapGestureRecognizer()
    let swipeRec = UISwipeGestureRecognizer()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
     * sets the detail item and configures view
     */
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    /**
    *   Overrides default viewDidLoad
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    /**
     *  Method to configure the view, called from viewDidLoad.
     */
    func configureView() {
        //tapRec.addTarget(self, action: "tappedView")
        //tapView?.addGestureRecognizer(tapRec)
        swipeRec.addTarget(self, action: "swipedView")
        swipeView?.addGestureRecognizer(swipeRec)
        //tapView?.userInteractionEnabled = true
        swipeView?.userInteractionEnabled = true
        swipeView?.multipleTouchEnabled = false
        
        // Update the user interface for the detail item.
        updateDetailNavItem()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pick", style: .Plain, target: self, action: Selector("didTouchUpInsidePickButton"))
    }

    func updateDetailNavItem(){
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailNavigationItem {
                label.title = detail.valueForKey("timeStamp")!.description
            }
        }
    }

    func didTouchUpInsidePickButton(item: UIBarButtonItem){
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        if picker.respondsToSelector(Selector("predicateForEnablingPerson")){
            picker.predicateForEnablingPerson = NSPredicate(format: "emailAddresses.@count > 0")
        }

        presentViewController(picker, animated: true, completion: nil)
    }

    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        let emails: ABMultiValueRef = ABRecordCopyValue(person, kABPersonEmailProperty).takeRetainedValue()
        if(ABMultiValueGetCount(emails) > 0){
            let index = 0 as CFIndex
            let email = ABMultiValueCopyValueAtIndex(emails, index).takeRetainedValue() as! String

            println("First email for selected contact = \(email)")
        }else{
            println("No email address")
        }
    }

    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, shouldContinueAfterSelectingPerson person: ABRecord!) -> Bool {
        peoplePickerNavigationController(peoplePicker, didSelectPerson: person)
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)

        return false;
    }

    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
    }

    func tappedView(){
        let tapAlert = UIAlertController(title: "Tapped", message: "You just tapped the tap view", preferredStyle: UIAlertControllerStyle.Alert)
        tapAlert.addAction(UIAlertAction(title: "Ok", style: .Destructive, handler: nil))
        self.presentViewController(tapAlert, animated: true, completion: nil)
    }

    //alert for gesture
    func swipedView(){
        let tapAlert = UIAlertController(title: "Swiped", message: "You just swiped the swipe view", preferredStyle: UIAlertControllerStyle.Alert)
        tapAlert.addAction(UIAlertAction(title: "Ok", style: .Destructive, handler: nil))
        self.presentViewController(tapAlert, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

