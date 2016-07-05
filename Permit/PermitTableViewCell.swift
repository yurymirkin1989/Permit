//
//  PermitTableViewCell.swift
//  Permit
//
//  Created by Miroslav on 6/29/16.
//  Copyright © 2016 Miroslav. All rights reserved.
//

import UIKit

@objc protocol PermitTableViewCellDelegate {
    optional func viewPermit(p: Permit?)
    optional func editPermit(p: Permit?)
}

class PermitTableViewCell: UITableViewCell {

    var delegate: PermitTableViewCellDelegate?
    
    @IBOutlet weak var lbName: UILabel?
    @IBOutlet weak var lbOpenDate: UILabel?
    @IBOutlet weak var lbPermitNumber: UILabel?
    @IBOutlet weak var btLock: UIButton?
    @IBOutlet weak var btEdit: UIButton?
    @IBOutlet weak var btView: UIButton?
    @IBOutlet weak var segmentLock: UISegmentedControl?
    @IBOutlet weak var segmentStatus: UISegmentedControl?
    
    var selectedPermit: Permit?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btEdit?.layer.cornerRadius = 3.0
        btView?.layer.cornerRadius = 3.0
        
        segmentLock?.userInteractionEnabled = false
        segmentStatus?.userInteractionEnabled = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setPermit(p: Permit) {
        selectedPermit = p
        lbName?.text = "Name - " + p.builder!
        
        let openDate = p.permit_open_date!
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd-YYYY"
        lbOpenDate?.text = "Date open - " + formatter.stringFromDate(openDate)
        lbPermitNumber?.text = "Permit #- " + p.permit_number!
        
        if p.lock_status == .OPEN {
            segmentLock?.selectedSegmentIndex = 0
        } else {
            segmentLock?.selectedSegmentIndex = 1
        }
        
        if p.permit_status == .PRE {
            segmentStatus?.selectedSegmentIndex = 0
        } else if p.permit_status == .PASSED {
            segmentStatus?.selectedSegmentIndex = 1
        } else {
            segmentStatus?.selectedSegmentIndex = 2
        }
        
        updateEditStatus()
    }
    
    func updateEditStatus() {
        segmentLock?.userInteractionEnabled = (selectedPermit?.is_edit)!
        segmentStatus?.userInteractionEnabled = (selectedPermit?.is_edit)!
        
        if selectedPermit?.is_edit == true {
            btLock?.setImage(UIImage(named: "unlock-padlock"), forState: .Normal)
            btEdit?.setTitle("Done", forState: .Normal)
        } else {
            btLock?.setImage(UIImage(named: "locked-padlock"), forState: .Normal)
            btEdit?.setTitle("Edit", forState: .Normal)
        }
    }
    
    @IBAction func actionEdit() {
        if selectedPermit?.is_edit == true {
            selectedPermit?.is_edit = false
            
            if segmentLock?.selectedSegmentIndex == 0 {
                selectedPermit?.lock_status = .OPEN
            } else {
                selectedPermit?.lock_status = .CLOSE
            }
            
            if segmentStatus?.selectedSegmentIndex == 0 {
                selectedPermit?.permit_status = .PRE
            }
            else if segmentStatus?.selectedSegmentIndex == 1 {
                selectedPermit?.permit_status = .PASSED
            }
            else {
                selectedPermit?.permit_status = .FAILED
            }
            self.delegate?.editPermit!(selectedPermit)
            
        } else {
            selectedPermit?.is_edit = true
        }
        
        updateEditStatus()
    }
    
    @IBAction func actionView() {
        self.delegate?.viewPermit!(selectedPermit)
    }
}
