//
//  ViewController.swift
//  NameGame
//
//  Created by Arnab Sudeshna on 3/20/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timedBtn: UIButton!
    @IBOutlet weak var practiceBtn: UIButton!
    
    @IBOutlet weak var btnConstraints: NSLayoutConstraint!
    
    @IBOutlet var btnConstraint: [NSLayoutConstraint]!
    var controller : EmployeeControllerProtocol! = EmployeeController()
    var allEmployees : [Name] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timedBtn.isEnabled = false
        self.practiceBtn.isEnabled = false
        
        self.controller.download { _ in
            DispatchQueue.main.async {
                self.allEmployees = self.controller.employees
                self.timedBtn.isEnabled = true
                self.practiceBtn.isEnabled = true
               
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        timedBtn.layer.cornerRadius = 10
        practiceBtn.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
//        self.timedBtn.isEnabled = true
//        self.practiceBtn.isEnabled = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "practiceVC":
            let practicevc = segue.destination as! PracticeModeViewController
            practicevc.allemployees = allEmployees
            
        case "timedVC":
            let timedvc = segue.destination as! TimedModeViewController
            timedvc.allemployees = allEmployees
        default:
            let practicevc = segue.destination as! PracticeModeViewController
            practicevc.allemployees = allEmployees
        }
    }
}

