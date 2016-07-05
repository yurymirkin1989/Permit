//
//  AddPermitViewController.swift
//  Permit
//
//  Created by Miroslav on 6/28/16.
//  Copyright © 2016 Miroslav. All rights reserved.
//

import UIKit

class AddPermitViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scMain: UIScrollView!
    @IBOutlet weak var tfBuilder: UITextField!
    @IBOutlet weak var tfCustomer: UITextField!
    @IBOutlet weak var tfSiteAddress: UITextField!
    @IBOutlet weak var tfContactPhoneNumber: UITextField!
    @IBOutlet weak var tfContactCellPhoneNumber: UITextField!
    @IBOutlet weak var tfPermitNumber: UITextField!
    @IBOutlet weak var tfPermitOpenDate: UITextField!
    @IBOutlet weak var tfPermitClosedDate: UITextField!
    @IBOutlet weak var tfPermitJurisdiction: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var btDelete: UIButton!
    
    var isEdit: Bool?
    var isClickedEdit: Bool?
    
    var selectedPermit: Permit?
    
    var selectedTextField: UITextField!
    var selectedPermitOpenDate: NSDate!
    var selectedPermitClosedDate: NSDate!
    var btRight: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Customer Information"
        
        let backButton = UIBarButtonItem(image: UIImage(named: "NavBarGoBackButton"), style: UIBarButtonItemStyle.Plain, target: self, action: "goBackButtonPressed")
        navigationItem.leftBarButtonItem = backButton
        
        tfPermitOpenDate.inputView = datePicker
        tfPermitOpenDate.inputAccessoryView = toolBar
        
        tfPermitClosedDate.inputView = datePicker
        tfPermitClosedDate.inputAccessoryView = toolBar
        
        tfContactPhoneNumber.inputAccessoryView = toolBar
        tfContactCellPhoneNumber.inputAccessoryView = toolBar
        
        isClickedEdit = false
        btDelete.hidden = true
        
        btRight = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "savePermit")
        navigationItem.rightBarButtonItem = btRight

        if isEdit == true {
            
            btRight.title = "Edit"
            selectedPermitOpenDate = selectedPermit?.permit_open_date
            selectedPermitClosedDate = selectedPermit?.permit_close_date
            
            tfBuilder.text = selectedPermit?.builder
            tfCustomer.text = selectedPermit?.customer
            tfSiteAddress.text = selectedPermit?.site_address
            tfContactPhoneNumber.text = selectedPermit?.contact_phone_number
            tfContactCellPhoneNumber.text = selectedPermit?.contact_cell_phone_number
            tfPermitNumber.text = selectedPermit?.permit_number
            tfPermitJurisdiction.text = selectedPermit?.permit_jurisdiction
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM-dd-YYYY"
            tfPermitOpenDate.text = formatter.stringFromDate(selectedPermitOpenDate)
            tfPermitClosedDate.text = formatter.stringFromDate(selectedPermitClosedDate)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goBackButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func hideKeyboard() {
        tfBuilder.resignFirstResponder()
        tfCustomer.resignFirstResponder()
        tfSiteAddress.resignFirstResponder()
        tfContactPhoneNumber.resignFirstResponder()
        tfContactCellPhoneNumber.resignFirstResponder()
        tfPermitNumber.resignFirstResponder()
        tfPermitOpenDate.resignFirstResponder()
        tfPermitClosedDate.resignFirstResponder()
        tfPermitJurisdiction.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        selectedTextField = textField
        var offset = 0
        if Globals.DeviceType.IS_IPHONE_5 {
            offset = 40
        }
        else if Globals.DeviceType.IS_IPHONE_4_OR_LESS {
            offset = 80
        }

        if textField.tag != 0 {
            scMain.setContentOffset(CGPointMake(0, CGFloat(offset + textField.tag * 50)), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scMain.setContentOffset(CGPointZero, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == tfBuilder {
            tfCustomer.becomeFirstResponder()
        }
        else if textField == tfCustomer {
            tfSiteAddress.becomeFirstResponder()
        }
        else if textField == tfSiteAddress {
            tfContactPhoneNumber.becomeFirstResponder()
        }
        else if textField == tfContactPhoneNumber {
            tfContactCellPhoneNumber.becomeFirstResponder()
        }
        else if textField == tfContactCellPhoneNumber {
            tfPermitNumber.becomeFirstResponder()
        }
        else if textField == tfPermitNumber {
            tfPermitOpenDate.becomeFirstResponder()
        }
        else if textField == tfPermitOpenDate {
            tfPermitClosedDate.becomeFirstResponder()
        }
        else if textField == tfPermitClosedDate {
            tfPermitJurisdiction.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func selectedPermiteDate(date: NSDate!) {
        if selectedTextField == tfPermitOpenDate {
            selectedPermitOpenDate = date
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM-dd-YYYY"
            tfPermitOpenDate.text = formatter.stringFromDate(date)
        }
        else if selectedTextField == tfPermitClosedDate {
            selectedPermitClosedDate = date
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM-dd-YYYY"
            tfPermitClosedDate.text = formatter.stringFromDate(date)
        }
    }
    
    @IBAction func actionInputDone() {
        hideKeyboard()
        if selectedTextField == tfPermitOpenDate {
            selectedPermiteDate(datePicker.date)
        } else if selectedTextField == tfPermitClosedDate {
            selectedPermiteDate(datePicker.date)
        }
    }
    
    @IBAction func actionInputNext() {
        if selectedTextField == tfContactPhoneNumber {
            tfContactCellPhoneNumber.becomeFirstResponder()
        }
        else if selectedTextField == tfContactCellPhoneNumber {
            tfPermitNumber.becomeFirstResponder()
        }
        else if selectedTextField == tfPermitOpenDate {
            selectedPermiteDate(datePicker.date)
            tfPermitClosedDate.becomeFirstResponder()
        }
        else if selectedTextField == tfPermitClosedDate {
            selectedPermiteDate(datePicker.date)
            tfPermitJurisdiction.becomeFirstResponder()
        }
    }
    
    func savePermit() {
        hideKeyboard()
        
        if isEdit == true && isClickedEdit == false {
            btRight.title = "Save"
            btDelete.hidden = false
            isClickedEdit = true
        }
        else {
            let builder = tfBuilder.text
            let customer = tfCustomer.text
            let site_address = tfSiteAddress.text
            let contact_phone_number = tfContactPhoneNumber.text
            let contact_cell_phone_number = tfContactCellPhoneNumber.text
            let permit_number = tfPermitNumber.text
            let permit_jurisdiction = tfPermitJurisdiction.text
            
            if builder == nil || builder?.characters.count == 0 {
                Globals.presentAlertMessage("Error", message: Globals.Messages.PermitBuilderError, cancelActionText: "Ok", presentingViewContoller: self)
                return;
            }
            
            if permit_number == nil || permit_number?.characters.count == 0 {
                Globals.presentAlertMessage("Error", message: Globals.Messages.PermitNumberError, cancelActionText: "Ok", presentingViewContoller: self)
                return;
            }
            
            if selectedPermitOpenDate == nil {
                Globals.presentAlertMessage("Error", message: Globals.Messages.PermitOpenDateError, cancelActionText: "Ok", presentingViewContoller: self)
                return;
            }
            
            let p: Permit = Permit()
            p.permit_number = permit_number
            p.builder = builder
            p.customer = customer
            p.site_address = site_address
            p.contact_phone_number = contact_phone_number
            p.contact_cell_phone_number = contact_cell_phone_number
            p.permit_jurisdiction = permit_jurisdiction
            p.permit_open_date = selectedPermitOpenDate
            p.permit_close_date = selectedPermitClosedDate
            
            if isEdit == true {
                CoreHelper.sharedInstance.updatePermit(p) { (status, e) -> () in
                    if status == true {
                        self.goBackButtonPressed()
                    } else {
                        let error = e as? NSError
                        Globals.presentAlertMessage("Error", message: (error?.description)!, cancelActionText: "Ok", presentingViewContoller: self)
                    }
                }
                
            } else {
                
                p.lock_status = .OPEN
                p.permit_status = .PRE
                CoreHelper.sharedInstance.addPermit(p) { (status, e) -> () in
                    if status == true {
                        self.goBackButtonPressed()
                    } else {
                        let error = e as? NSError
                        Globals.presentAlertMessage("Error", message: (error?.description)!, cancelActionText: "Ok", presentingViewContoller: self)
                    }
                }
            }
        }
    }
    
    @IBAction func actionDelete() {
        if isEdit == true {
            
            let alertController = UIAlertController(title: "", message: "Are you sure to delete permit?", preferredStyle: .Alert)
            let yesAction = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
                CoreHelper.sharedInstance.deletePermit(self.selectedPermit!) { (status, e) -> () in
                    if status == true {
                        self.goBackButtonPressed()
                    } else {
                        let error = e as? NSError
                        Globals.presentAlertMessage("Error", message: (error?.description)!, cancelActionText: "Ok", presentingViewContoller: self)
                    }
                }
            })
            alertController.addAction(yesAction)
            
            let noAction = UIAlertAction(title: "No", style: .Default, handler: { (action) -> Void in
                
            })
            alertController.addAction(noAction)

            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
