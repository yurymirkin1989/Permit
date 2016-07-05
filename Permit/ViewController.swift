//
//  ViewController.swift
//  Permit
//
//  Created by Miroslav on 6/28/16.
//  Copyright © 2016 Miroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PermitTableViewCellDelegate {
    
    @IBOutlet weak var tbList: UITableView!
    var permits: [Permit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        title = "Permit List"
        let rightButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPermit")
        navigationItem.rightBarButtonItem = rightButton
        
        tbList.registerNib(UINib(nibName: "PermitTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "PermitTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadAllPermits()
    }
    
    func loadAllPermits() {
        permits = CoreHelper.sharedInstance.getAllPermits()
        tbList.reloadData()
    }
    
    func addPermit() {
        let addPermitController = self.storyboard!.instantiateViewControllerWithIdentifier("AddPermitViewController") as! AddPermitViewController
        addPermitController.isEdit = false
        addPermitController.selectedPermit = nil
        self.navigationController!.pushViewController(addPermitController, animated: true)
    }
    
    // MARK: TableView Delegate & Data source.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return permits.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: PermitTableViewCell? = tbList.dequeueReusableCellWithIdentifier("PermitTableViewCell", forIndexPath: indexPath) as? PermitTableViewCell
        if cell == nil {
            cell = PermitTableViewCell()
        }
        
        let p = permits[indexPath.row]
        cell?.setPermit(p)
        cell?.delegate = self
        return cell!
    }
    
    func viewPermit(p: Permit?) {
        let addPermitController = self.storyboard!.instantiateViewControllerWithIdentifier("AddPermitViewController") as! AddPermitViewController
        addPermitController.isEdit = true
        addPermitController.selectedPermit = p
        self.navigationController!.pushViewController(addPermitController, animated: true)
    }
    
    func editPermit(p: Permit?) {
        CoreHelper.sharedInstance.updatePermit(p!) { (status, e) -> () in
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 78
    }
}

