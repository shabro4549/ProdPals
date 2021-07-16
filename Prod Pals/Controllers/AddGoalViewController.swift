//
//  AddGoalViewController.swift
//  Something
//
//  Created by Shannon Brown on 2021-07-13.
//

import UIKit

class AddGoalViewController: UIViewController {

    @IBOutlet weak var goalLabel: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addFriendsButton: UIButton!
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var segmentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFriendsButton.alpha = 0
        friendsTableView.alpha = 0
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addGoalPressed(_ sender: Any) {
        print(goalLabel.text!)
        print(segmentedControl.selectedSegmentIndex)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            segmentLabel.text = "Public - goal + progress shared with supporters"
            addFriendsButton.alpha = 0
            friendsTableView.alpha = 0
        } else if sender.selectedSegmentIndex == 1 {
            segmentLabel.text = "Shared - goal + progress shared with chosen friends"
            addFriendsButton.alpha = 1
            friendsTableView.alpha = 1
        } else {
            segmentLabel.text = "Private - goal + progress is just for you"
            addFriendsButton.alpha = 0
            friendsTableView.alpha = 0
        }
    }

}
