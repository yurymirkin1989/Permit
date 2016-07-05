//
//  Permit.swift
//  Permit
//
//  Created by Miroslav on 6/28/16.
//  Copyright © 2016 Miroslav. All rights reserved.
//

import Foundation
import CoreData

enum Lock_Status: Int {
    case OPEN       = 0
    case CLOSE      = 1
}

enum Permit_Status: Int {
    case PRE        = 0
    case PASSED     = 1
    case FAILED     = 2
}

class Permit: NSObject {
    var builder: String?
    var customer: String?
    var site_address: String?
    var contact_phone_number: String?
    var contact_cell_phone_number: String?
    var permit_number: String?
    var permit_open_date: NSDate?
    var permit_close_date: NSDate?
    var permit_jurisdiction: String?
    var lock_status: Lock_Status?
    var permit_status: Permit_Status?
    
    var is_edit: Bool? = false
    
    convenience init(object: NSManagedObject) {
        self.init()
        self.builder = object.valueForKey("builder") as? String
        self.customer = object.valueForKey("customer") as? String
        self.site_address = object.valueForKey("site_address") as? String
        self.contact_phone_number = object.valueForKey("contact_phone_number") as? String
        self.contact_cell_phone_number = object.valueForKey("contact_cell_phone_number") as? String
        self.permit_number = object.valueForKey("permit_number") as? String
        self.permit_open_date = object.valueForKey("permit_open_date") as? NSDate
        self.permit_close_date = object.valueForKey("permit_close_date") as? NSDate
        self.permit_jurisdiction = object.valueForKey("permit_jurisdiction") as? String
        
        let lock = object.valueForKey("lock_status")?.integerValue
        if lock == 0 {
            self.lock_status = .OPEN
        } else {
            self.lock_status = .CLOSE
        }
        
        let status = object.valueForKey("permit_status")?.integerValue
        
        if status == 0 {
            self.permit_status = .PRE
        } else if status == 1 {
            self.permit_status = .PASSED
        } else {
            self.permit_status = .FAILED
        }
    }
}
