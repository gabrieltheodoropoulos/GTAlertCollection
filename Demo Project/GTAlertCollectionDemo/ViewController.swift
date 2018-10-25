//
//  ViewController.swift
//  GTAlertCollectionDemo
//
//  Created by Gabriel Theodoropoulos on 22/10/2018.
//  Copyright © 2018 Gabriel Theodoropoulos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // MARK: - Properties
    
    var alertVariationTitles = [String]()
    
    var timeout: Int = 3
    
    var updateHandler: ((_ currentItem: Int, _ totalItems: Int) -> Void)!
    
    
    
    // MARK: - Load & Appearance Default Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GTAlertCollection.shared.hostViewController = self
        
        configureTableView()
        setAlertVariations()
    }
    
    
    
    
    // MARK: - Custom Methods
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "idCustomCell")
    }
    

    func setAlertVariations() {
        alertVariationTitles.append("1-Button alert")
        alertVariationTitles.append("2-Buttons alert")
        alertVariationTitles.append("Multiple buttons alert")
        alertVariationTitles.append("Destructive alert")
        alertVariationTitles.append("Buttonless alert")
        alertVariationTitles.append("Activity alert")
        alertVariationTitles.append("Single textfield alert")
        alertVariationTitles.append("Multiple textfields alert")
        alertVariationTitles.append("Progress bar alert")
        alertVariationTitles.append("Image view alert")
        tableView.reloadData()
    }
 
    
    
    func demoSingleButtonAlert() {
        GTAlertCollection.shared.presentSingleButtonAlert(withTitle: "Welcome", message: "This is a simple alert!", buttonTitle: "Got it", actionHandler: {
            
            print("Single Button Alert - Action button was tapped")
        
        })
    }
    
    
    
    func demoTwoButtonsAlert() {
        GTAlertCollection.shared.presentAlert(withTitle: "A Question", message: "What do you think?", buttonTitles: ["Yes", "No"], cancelButtonIndex: nil, destructiveButtonIndices: nil) { (actionIndex) in
            
            if actionIndex == 0 {
                print("It's a Yes")
            } else {
                print("It's a No")
            }
            
        }
    }
    
    
    func demoMultipleButtonsAlert() {
        GTAlertCollection.shared.presentAlert(withTitle: "Your Options",
                                              message: "What would you like to do?",
                                              buttonTitles: ["Create", "Update", "Delete one", "Delete all", "Cancel"],
                                              cancelButtonIndex: 4,
                                              destructiveButtonIndices: [2, 3]) { (actionIndex) in
                                                
                                                print("You tapped on button at index \(actionIndex)")
        }
    }
    
    
    
    func demoDestructiveAlert() {
        GTAlertCollection.shared.presentAlert(withTitle: "Delete your account?", message: "This action is irreversible!", buttonTitles: ["Yes, delete", "Cancel"], cancelButtonIndex: 1, destructiveButtonIndices: [0], actionHandler: { (actionIndex) in
            
            if actionIndex == 0 {
                print("Account was deleted")
            } else {
                print("Cancelled account deletion")
            }
            
        })
    }
    
    
    
    func demoButtonlessAlert() {
        GTAlertCollection.shared.presentButtonlessAlert(withTitle: "Something Different", message: "This is a buttonless alert!\n\nIt will be self-dismissed in \(timeout) seconds.") { (success) in
            
            if success {
                // The alert controller was presented...
                
                // Auto-dismiss the alert after a few seconds.
                self.timeout = 3
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                    self.timeout -= 1
                    
                    if self.timeout != 0 {
                        if let alertController = GTAlertCollection.shared.alertController {
                            alertController.message = "This is a buttonless alert!\n\nIt will be self-dismissed in \(self.timeout) seconds."
                        }
                    } else {
                        GTAlertCollection.shared.dismissAlert(completion: nil)
                        timer.invalidate()
                    }
                    
                })
            }
        }
    }
    
    
    
    
    func demoActivityIndicatorAlert() {
        GTAlertCollection.shared.presentActivityAlert(withTitle: "Please wait", message: "You are being connected to your account...", activityIndicatorColor: .blue, showLargeIndicator: false) { (success) in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    GTAlertCollection.shared.dismissAlert(completion: {
                        
                    })
                }
            }
        }
    }
 
    
    
    
    func demoSingleTextFieldAlert() {
        GTAlertCollection.shared.presentSingleTextFieldAlert(withTitle: "Editor", message: "Feel free to type something:", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", configurationHandler: { (textField, didFinishConfiguration) in
            
            if let textField = textField {
                // Configure the textfield properties.
                
                // This is the place where you can set your view controller as the delegate
                // of the textfield if you wish so. After that, implement the UITextFieldDelegate methods
                // you need.
                 textField.delegate = self
                
                textField.placeholder = "Type here..."
                textField.textColor = UIColor.orange
                
                // More configuration...
                
                // Always call the following to let the alert controller appear.
                didFinishConfiguration()
            }
            
        }) { (textField) in
            if let textField = textField {
                print(textField.text ?? "")
            }
        }
        
    }
    
    
    
    func demoMultipleTextFieldsAlert() {
        GTAlertCollection.shared.presentMultipleTextFieldsAlert(withTitle: "Input Data", message: "Lots of stuff to type here...", doneButtonTitle: "OK", cancelButtonTitle: "Cancel", numberOfTextFields: 5, configurationHandler: { (textFields, didFinishConfiguration) in
            
            if let textFields = textFields {
                let placeholders = ["First name", "Last name", "Nickname", "Email", "Password"]
                for i in 0..<textFields.count {
                    textFields[i].placeholder = placeholders[i]
                }
                
                textFields.last?.isSecureTextEntry = true
                
                // More configuration...
                
                didFinishConfiguration()
            }
            
        }) { (textFields) in
            if let textFields = textFields {
                // Do something with the texts.
                
                for i in 0..<textFields.count {
                    print(textFields[i].text ?? "")
                }
            }
        }
    }
    
    
    
    
    
    func demoProgressBarAlert() {
        GTAlertCollection.shared.presentProgressBarAlert(withTitle: "Upload", message: "Your files are being uploaded...", progressTintColor: .red, trackTintColor: .lightGray, showPercentage: true, showStepsCount: false, updateHandler: { (updateHandler) in
            
            self.updateHandler = updateHandler
            
        }) { (success) in
            if success {
                self.updateProgress()
            }
        }
    }
    
    
    func updateProgress() {
        let totalSteps = 50
        var currentStep = 0
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
            currentStep += 1
            
            if let updateHandler = self.updateHandler {
                updateHandler(currentStep, totalSteps)
            }
            
            if currentStep == totalSteps {
                timer.invalidate()
                
                GTAlertCollection.shared.dismissAlert(completion: nil)
            }
            
        })
    }
 
    
    
    func demoImageViewAlert() {
        if let path = Bundle.main.path(forResource: "iron_man", ofType: "png") {
            if let image = UIImage(contentsOfFile: path) {
                GTAlertCollection.shared.presentImageViewAlert(withTitle: "Your Avatar", message: "What do you want to do with it?", buttonTitles: ["Change it", "Remove it", "Cancel"], cancelButtonIndex: 2, destructiveButtonIndices: [1], image: image) { (actionIndex) in
                    
                    print("You tapped on button at index \(actionIndex)")
                }
            }
        }
    }
    
    
}




// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertVariationTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "idCustomCell", for: indexPath) as? CustomCell {
            cell.customLabel.text = "\(indexPath.row + 1)) " + alertVariationTitles[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the cell.
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.setSelected(false, animated: true)
        }
        
        switch indexPath.row {
        case 0:
            demoSingleButtonAlert()
        
        case 1:
            demoTwoButtonsAlert()
            
        case 2:
            demoMultipleButtonsAlert()
            
        case 3:
            demoDestructiveAlert()
            
        case 4:
            demoButtonlessAlert()
            
        case 5:
            demoActivityIndicatorAlert()
            
        case 6:
            demoSingleTextFieldAlert()
            
        case 7:
            demoMultipleTextFieldsAlert()
            
        case 8:
            demoProgressBarAlert()
            
        default:
            demoImageViewAlert()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}




// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
