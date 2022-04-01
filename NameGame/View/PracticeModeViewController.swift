//
//  PracticeModeViewController.swift
//  NameGame
//
//  Created by Arnab Sudeshna on 3/21/22.
//

import UIKit

class PracticeModeViewController: UIViewController {
   
    @IBOutlet weak var rightSrackView: UIStackView!
    @IBOutlet weak var leftStackView: UIStackView!
    @IBOutlet weak var employeeNameLbl: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    
    @IBOutlet weak var gapConstraint: NSLayoutConstraint!
    var controller : EmployeeControllerProtocol! = EmployeeController()
    
    var randm = Int()
    var allemployees : [Name] = []
    var sixEmployees = [Name]()
    var correctEmployee: Name?
    var networker = DecodableNetwork()
    var score = Int()
    var decoder = JSONDecoder()
   
    
    lazy var pictureService: PictureService = {
        return PictureService(networker)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Practice Mode"
        randm = Int.random(in: 0...5)
        chooseEmployees()
        self.correctEmployee = self.sixEmployees[self.randm]
        DispatchQueue.main.async {
            self.employeeNameLbl.text = (self.correctEmployee?.firstname)! + " " + (self.correctEmployee?.lastname)!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.setupImage()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate( alongsideTransition: { (context) -> Void in
            let orientation = UIApplication.shared.statusBarOrientation
            if orientation.isPortrait{
                self.rightSrackView.axis = .vertical
                self.leftStackView.axis = .vertical
            } else {
                self.rightSrackView.axis = .horizontal
                self.leftStackView.axis = .horizontal
               // self.gapConstraint.constant = 0
                
            }
        }, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @IBAction func btnClickAction(_ sender: Any) {
        matchTheImage(sender: sender as! UIButton)
    }
    
    func chooseEmployees(){
        while sixEmployees.count < 6{
            if let emp = self.allemployees.randomElement(),
               !sixEmployees.contains(where: { (item) -> Bool in
                 item == emp
               }) {
                sixEmployees.append(emp)
            }
        }
    }
    
    func matchTheImage(sender: UIButton){
        if randm == sender.tag{
            sender.setImage(UIImage(named: "correct"), for: .normal)
            let alert = UIAlertController(title: "NameGame", message: "Congratulation!! Play Again", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                print("Action")
                self.playAgain()
                self.setupImage()
                self.score = self.score + 10
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            
            sender.setImage(UIImage(named: "wrong"), for: .normal)
            
            let alert = UIAlertController(title: "Wrong Answer", message: "Score: \(score)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                print("Action")
//                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
//                self.navigationController?.pushViewController(vc!, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    func setupImage(){
        setImagetoBtn(button1, employee: sixEmployees[0])
        setImagetoBtn(button2, employee: sixEmployees[1])
        setImagetoBtn(button3, employee: sixEmployees[2])
        setImagetoBtn(button4, employee: sixEmployees[3])
        setImagetoBtn(button5, employee: sixEmployees[4])
        setImagetoBtn(button6, employee: sixEmployees[5])
    }
    
    func setImagetoBtn(_ sender: UIButton, employee: Name){
            if let u = employee.headShot.url, let url = URL(string: u){
            pictureService.get(url){ (data) in
                guard let dat = data else {
                    return
                }
                DispatchQueue.main.async { [self] in
                    sender.setImage(UIImage(data: dat), for: .normal)
                }
            }
        }
    }
    
    func playAgain(){
        randm = Int.random(in: 0...5)
        correctEmployee = sixEmployees[randm]
        employeeNameLbl.text = (correctEmployee?.firstname)! + " " + (correctEmployee?.lastname)!
    }

}
