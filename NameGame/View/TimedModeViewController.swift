//
//  TimedModeViewController.swift
//  NameGame
//
//  Created by Arnab Sudeshna on 3/22/22.
//

import UIKit

class TimedModeViewController: UIViewController {
    
    @IBOutlet weak var rightStackView: UIStackView!
    @IBOutlet weak var leftStackView: UIStackView!
    @IBOutlet var btns: [UIButton]!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var employeenameLbl: UITextField!
    @IBOutlet weak var btn1: UIButton!
    var counter = 30.0
    var nsTimer = Timer()
   // var controller : EmployeeControllerProtocol! = EmployeeController()
    
    var randm = Int()
    var allemployees : [Name] = []
    var sixEmployees =  [Name]()
    var correctEmployee: Name?
    var networker = DecodableNetwork()
    var score = Int()
    
    lazy var pictureService: PictureService = {
        return PictureService(networker)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Timed Mode"

        randm = Int.random(in: 0...5)
        chooseEmployees()
        correctEmployee = sixEmployees[randm]
        DispatchQueue.main.async {
            self.employeenameLbl.text = (self.correctEmployee?.firstname)! + " " + (self.correctEmployee?.lastname)!
        }
        timerLbl.text = "\(counter)"
        if !nsTimer.isValid{
            nsTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        timerLbl.text = "\(counter)"
        self.setupImage()
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.nsTimer.invalidate()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate( alongsideTransition: { (context) -> Void in
            let orientation = UIApplication.shared.statusBarOrientation
            if orientation.isPortrait{
                self.rightStackView.axis = .vertical
                self.leftStackView.axis = .vertical
            } else {
                self.rightStackView.axis = .horizontal
                self.leftStackView.axis = .horizontal
            }
        }, completion: nil)
    }
    
    @IBAction func btnClickAction(_ sender: Any) {
        matchTheImage(sender: sender as! UIButton)
    }
    
    @objc func updateTime() {
        counter = counter - 0.1
       // let hours = Int(counter) / 3600
        let minutes = Int(counter) / 60 % 60
        let seconds = Int(counter) % 60
        
        timerLbl.text = String(format:"%2i:%2i", minutes, seconds)
        if Int(counter) == 0 {
            nsTimer.invalidate()
            let alert = UIAlertController(title: "NameGame", message: "Finished. Score: \(score)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
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
            let alert = UIAlertController(title: "NameGame", message: "Right Answer!!Play Again", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { [self](action:UIAlertAction!) in
                print("Action")
                self.playAgain()
                self.setupImage()
                self.score = score + 10
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            sender.setImage(UIImage(named: "wrong"), for: .normal)
        }
    }
    
    func setupImage(){
        for i in 0..<sixEmployees.count{
            setImagetoBtn(self.btns[i], employee: sixEmployees[i])
        }
    }
    
    func setImagetoBtn(_ sender: UIButton, employee: Name){
        let u: String = (employee.headShot.url)!
        if let url = URL(string: u){
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
        employeenameLbl.text = (correctEmployee?.firstname)! + " " + (correctEmployee?.lastname)!
    }
   
}
