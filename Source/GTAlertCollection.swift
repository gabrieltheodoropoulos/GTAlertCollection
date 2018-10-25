//
//  GTAlertCollection.swift
//
//  Created by Gabriel Theodoropoulos.
//
//  MIT License
//  Copyright © 2018 Gabriel Theodoropoulos
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

/// A collection of several `UIAlertController` variations gathered in one place.
///
/// With `GTAlertCollection` you can present fast, easily and efficiently:
///
/// *   One-button alert controller
/// *   Alert controller with variable number of buttons with all supported styles: Default, Cancel, Destructive
/// *   Buttonless alert controller
/// *   Alert controller with an activity indicator
/// *   Alert controller with a progress bar, including text representation of the progress (either percentage, or number of steps made)
/// *   Alert controller with a single text field
/// *   Alert controller with multiple text fields
/// *   Alert controller with an image view
///
/// See more on [GitHub](https://github.com/gabrieltheodoropoulos/gtalertcollection)
class GTAlertCollection: NSObject {

    // MARK: - Properties
    
    /// The `GTAlertCollection` shared instance.
    static let shared = GTAlertCollection()
    
    /// The presented alert controller.
    var alertController: UIAlertController!
    
    /// The view controller that the alert controller is presented to.
    var hostViewController: UIViewController!
    
    /// The activity indicator of the alert.
    var activityIndicator: UIActivityIndicatorView!
    
    /// The `UIProgressView` object that displays the progress bar.
    var progressBar: UIProgressView!
    
    /// The label right below the progress bar.
    var label: UILabel!
    
    /// The image view of the alert.
    var imageView: UIImageView!
    
    
    
    // MARK: - Initialization
    
    /// Custom `init` method that accepts the host view controller as an argument.
    ///
    /// You are advised to use this initializer when creating objects of this class and you are not
    /// using the shared instance.
    ///
    /// - Parameter hostViewController: The view controller that will present the alert controller.
    init(withHostViewController hostViewController: UIViewController) {
        super.init()
        self.hostViewController = hostViewController
    }
    
    
    /// Default `init` method.
    override init() {
        super.init()
    }
    
    
    
    // MARK: - Fileprivate Methods
    
    /// It makes the alertController property `nil` in case it's not already.
    fileprivate func cleanUpAlertController() {
        if alertController != nil {
            alertController = nil
            
            if let _ = self.progressBar { self.progressBar = nil }
            if let _ = self.label { self.label = nil }
            if let _ = self.imageView { self.imageView = nil }
        }
    }
    
    
    
    /// It creates and returns `UIAlertAction` objects for the alert controller.
    ///
    /// - Parameters:
    ///   - buttonTitles: The titles of the action buttons.
    ///   - cancelButtonIndex: The position of the Cancel-styled action among all action buttons (if any).
    ///   - destructiveButtonIndices: An array with the positions of Destructive-styled action buttons among all action buttons (if any).
    ///   - actionHandler: The action handler to be called when an action button gets tapped.
    /// - Returns: A collection with `UIAlertAction` objects that must be added to the alert controller.
    fileprivate func createAlertActions(usingTitles buttonTitles: [String], cancelButtonIndex: Int?, destructiveButtonIndices: [Int]?, actionHandler: @escaping (_ actionIndex: Int) -> Void) -> [UIAlertAction] {
        var actions = [UIAlertAction]()
        
        // Create as many UIAlertAction actions as the items in the buttonTitles array are.
        for i in 0..<buttonTitles.count {
            // By default, all action buttons will have the .default style.
            var buttonStyle: UIAlertAction.Style = .default
            
            // Check if there should be a Cancel-like button.
            if let index = cancelButtonIndex {
                // Check if the current button should be displayed using the .cancel style.
                if index == i {
                    // If so, set the proper button style.
                    buttonStyle = .cancel
                }
            }
            
            // Check if there should be destructive buttons.
            if let destructiveButtonIndices = destructiveButtonIndices {
                // Go through each destructive button index and check if the current button should be one of them.
                for index in destructiveButtonIndices {
                    if index == i {
                        // If so, apply the .destructive style.
                        buttonStyle = .destructive
                        break
                    }
                }
            }
            
            // Create a new UIAlertAction and pass the title for the current button, as well as the button style as defined above.
            let action = UIAlertAction(title: buttonTitles[i], style: buttonStyle, handler: { (action) in
                // Call the actionHandler passing the index of the current action when user taps on the current one.
                actionHandler(i)
            })
            
            // Append each new action to the actions array.
            actions.append(action)
        }
        
        
        // Return the collection of the alert actions.
        return actions
    }
    
    
    
    
    // MARK: - Public Methods
    
    /// It dismisses the alert controller.
    ///
    /// - Parameter completion: If the `completion` is not `nil`, it's called to notify that the alert has been dismissed.
    func dismissAlert(completion: (() -> Void)?) {
        DispatchQueue.main.async { [unowned self] in
            if let alertController = self.alertController {
                alertController.dismiss(animated: true) {
                    self.alertController = nil
                    
                    if let _ = self.progressBar { self.progressBar = nil }
                    if let _ = self.label { self.label = nil }
                    if let _ = self.imageView { self.imageView = nil }
                    
                    if let completion = completion {
                        completion()
                    }
                }
            }
        }
    }
    
    
    
    /// It presents the alert controller with one action button only.
    ///
    /// - Parameters:
    ///   - title: The optional title of the alert.
    ///   - message: The optional message of the alert.
    ///   - buttonTitle: The action button title. Required.
    ///   - actionHandler: It's called when the action button is tapped by the user. Use it to implement the required logic after the user has tapped on your alert's button.
    func presentSingleButtonAlert(withTitle title: String?, message: String?, buttonTitle: String, actionHandler: @escaping () -> Void) {
        // Check if the hostViewController has been set.
        if let hostVC = hostViewController {
            // Perform all actions on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController object is nil before initializing it.
                self.cleanUpAlertController()
                
                // Initialize the alertController object.
                self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                // Create one UIAlertAction using the .default style.
                let action = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { (action) in
                    // Call the actionHandler when the action button is tapped.
                    actionHandler()
                })
                
                // Add the alert action to the alert controller.
                self.alertController.addAction(action)
                
                // Present the alert controller to the host view controller.
                hostVC.present(self.alertController, animated: true, completion: nil)
            }
            
        } else {
            // The host view controller has no value.
            NSLog("[GTAlertCollection]: No host view controller was specified")
        }
    }
    
    
    
    
    
    
    /// It presents an alert controller with as many action buttons as the `buttonTitles` array items, using the provided title and message for the displayed text.
    /// It can have one *Cancel-styled* and one or more *Destructive-styled* action buttons.
    ///
    /// - Parameters:
    ///   - title: The *optional* title of the alert.
    ///   - message: The *optional* message of the alert.
    ///   - buttonTitles: The array with the action button titles. Give the titles in the order you want them to appear.
    ///   - cancelButtonIndex: If there's a *Cancel-styled* button you want to exist among buttons, then here's the place where you specify it's **position** in the `buttonTitles` array. Pass `nil` if there's no Cancel-styled button.
    ///   - destructiveButtonIndices: An array with the **position** of one or more *destructive* buttons in the collection of buttons. Pass `nil` if you have no destructive buttons to show.
    ///   - actionHandler: Use this block to determine which action button was tapped by the user. An `actionIndex` value provides you with that information.
    func presentAlert(withTitle title: String?, message: String?, buttonTitles: [String], cancelButtonIndex: Int?, destructiveButtonIndices: [Int]?, actionHandler: @escaping (_ actionIndex: Int) -> Void) {
        // Check if the host view controller has been set.
        if let hostVC = hostViewController {
            // Perform all operations on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController object is nil.
                self.cleanUpAlertController()
                
                // Initialize the alert controller using the given title and message.
                self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                // Create the action buttons and add them to the alert controller.
                let actions = self.createAlertActions(usingTitles: buttonTitles, cancelButtonIndex: cancelButtonIndex, destructiveButtonIndices: destructiveButtonIndices, actionHandler: actionHandler)
                for action in actions {
                    self.alertController.addAction(action)
                }
                
                // After having finished with the actions, present the alert controller animated.
                hostVC.present(self.alertController, animated: true, completion: nil)
            }
        } else {
            // The host view controller has no value.
            NSLog("[GTAlertCollection]: No host view controller was specified")
        }
        
    }
    
    
    
    /// It presents a buttonless alert controller.
    ///
    /// - Parameters:
    ///   - title: The optional title of the alert.
    ///   - message: The optional message of the alert.
    ///   - presentationCompletion: Called after the alert controller has been presented or when the `hostViewController` is `nil`, and indicates whether the alert controller was presented successfully or not.
    ///   - success: When `true` the alert controller has been successfully presented to the host view controller, otherwise it's `false`.
    func presentButtonlessAlert(withTitle title: String?, message: String?, presentationCompletion: @escaping (_ success: Bool) -> Void) {
        // Check if the host view controller has been set.
        if let hostVC = hostViewController {
            // Operate on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController is nil before initializing it.
                self.cleanUpAlertController()
                
                // Initialize the alert controller.
                self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                // Present the alert controller to the host view controller.
                hostVC.present(self.alertController, animated: true, completion: {
                    // Pass true to the presentationCompletion indicating that the alert controller was presented.
                    presentationCompletion(true)
                })
            }
            
        } else {
            // The host view controller is nil and the alert controller cannot be presented.
            NSLog("[GTAlertCollection]: No host view controller was specified")
            
            // Pass false to the presentationCompletion indicating that presenting the alert controller failed.
            presentationCompletion(false)
        }
    }
    
    
    
    
    
    /// It presents a buttonless alert controller with an activity indicator in it. The indicator's color and size can be optionally customized.
    ///
    /// **Implementation Example:**
    /// ```
    /// GTAlertCollection.shared.presentActivityAlert(withTitle: "Please wait",
    ///                                               message: "You are being connected to your account...",
    ///                                               activityIndicatorColor: .blue,
    ///                                               showLargeIndicator: false) { (success) in
    ///     if success {
    ///         // The alert controller was presented successfully...
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - title: The optional title of the alert.
    ///   - message: The optional message of the alert.
    ///   - activityIndicatorColor: The color of the activity indicator. By default, the color is set to *black*.
    ///   - showLargeIndicator: Pass `true` when you want to use the large indicator style, `false` when you want to display the small one. Default value is `false`.
    ///   - presentationCompletion: Called after the alert controller has been presented or when the `hostViewController` is `nil`, and indicates whether the alert controller was presented successfully or not.
    ///   - success: When `true` the alert controller has been successfully presented to the host view controller, otherwise it's `false`.
    func presentActivityAlert(withTitle title: String?, message: String?, activityIndicatorColor: UIColor = UIColor.black, showLargeIndicator: Bool = false, presentationCompletion: @escaping (_ success: Bool) -> Void) {
        // Check if the host view controller has been set.
        if let hostVC = hostViewController {
            // Operate on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController is nil before initializing it.
                self.cleanUpAlertController()
                
                // Initialize the alert controller.
                // If the alert message is not nil, then add additional spaces at the end, or if it's nil add just these spaces, so it's possible to make
                // room for the activity indicator.
                // If the large activity indicator is about to be shown, then add three spaces, otherwise two.
                self.alertController = UIAlertController(title: title, message: (message ?? "") + (showLargeIndicator ? "\n\n\n" : "\n\n"), preferredStyle: .alert)
                
                // Initialize the activity indicator as large or small according to the showLargeIndicator parameter value.
                self.activityIndicator = UIActivityIndicatorView(style: showLargeIndicator ? .whiteLarge : .gray)
                
                // Set the activity indicator color.
                self.activityIndicator.color = activityIndicatorColor
                
                // Start animating.
                self.activityIndicator.startAnimating()
                
                // Add it to the alert controller's view as a subview.
                self.alertController.view.addSubview(self.activityIndicator)
                
                // Specify the following constraints to make it appear properly.
                self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                self.activityIndicator.centerXAnchor.constraint(equalTo: self.alertController.view.centerXAnchor).isActive = true
                self.activityIndicator.bottomAnchor.constraint(equalTo: self.alertController.view.bottomAnchor, constant: -8.0).isActive = true
                self.alertController.view.layoutIfNeeded()
                
                // Present the alert controller to the host view controller.
                hostVC.present(self.alertController, animated: true, completion: {
                    // Pass true to the presentationCompletion indicating that the alert controller was presented.
                    presentationCompletion(true)
                })
            }
            
        } else {
            // The host view controller is nil and the alert controller cannot be presented.
            NSLog("[GTAlertCollection]: No host view controller was specified")
            
            // Pass false to the presentationCompletion indicating that presenting the alert controller failed.
            presentationCompletion(false)
        }
    }
    
    
    
    /// It presents an alert controller that contains a text field, and two action buttons (Done & Cancel). Title and message are included too. The action button titles are modifiable.
    ///
    /// **Implementation Example:**
    ///
    /// ```
    /// GTAlertCollection.shared.presentSingleTextFieldAlert(withTitle: "Editor",
    ///                                                      message: "Type something:",
    ///                                                      doneButtonTitle: "OK",
    ///                                                      cancelButtonTitle: "Cancel",
    ///                                                      configurationHandler: { (textField, didFinishConfiguration) in
    ///
    ///     if let textField = textField {
    ///         // Configure the textfield properties.
    ///         textField.delegate = self
    ///         textField.placeholder = "Write here"
    ///         // ... more configuration ...
    ///
    ///         // Always call the following to let the alert controller appear.
    ///         didFinishConfiguration()
    ///     }
    ///
    /// }) { (textField) in
    ///     if let textField = textField {
    ///         // Do something with the textfield's text.
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - title: The optional title of the alert.
    ///   - message: The optional message of the alert.
    ///   - doneButtonTitle: The Done button title. Default value is "Done".
    ///   - cancelButtonTitle: The Cancel button title. Default value is "Cancel".
    ///   - configurationHandler: A closure where you can configure the text field's properties before the alert is presented. The first parameter of the closure is the textfield itself, the second parameter it's a closure that must be called manually when you finish configuring the textfield, so it's possible for the alert to be presented.
    ///   - completionHandler: Called when the Done button is tapped. It contains the textfield as a parameter.
    ///   - didFinishConfiguration: Calling this closure from your code is **mandatory**. You do that after having configured the text field. If you don't make any configuration, call it directly in the `configurationHandler` closure.
    ///   - textField: The single text field of the alert. Be careful with it and always unwrap it before using it, as it can be `nil`.
    ///   - editedTextField: The single text field of the alert as returned when the Done button gets tapped. Always unwrap it before using it as it might be `nil`.
    func presentSingleTextFieldAlert(withTitle title: String?, message: String?, doneButtonTitle: String = "Done", cancelButtonTitle: String = "Cancel", configurationHandler: @escaping (_ textField: UITextField?, _ didFinishConfiguration: () -> Void) -> Void, completionHandler: @escaping (_ editedTextField: UITextField?) -> Void) {
        // Check if the host view controller has been set.
        if let hostVC = hostViewController {
            // Work on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController is nil before initializing it.
                self.cleanUpAlertController()
                
                // Initialize the alert controller.
                self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                // Add a textfield to the alert controller.
                self.alertController.addTextField(configurationHandler: { (textField) in
                    
                })
                
                // Add the two actions to the alert controller (Done & Cancel).
                self.alertController.addAction(UIAlertAction(title: doneButtonTitle, style: .default, handler: { (action) in
                    if let textFields = self.alertController.textFields {
                        if textFields.count > 0 {
                            // When the Done button is tapped, return the first textfield in the textfields collection.
                            completionHandler(textFields[0])
                        } else { completionHandler(nil) }
                    } else { completionHandler(nil) }
                }))
                
                self.alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { (action) in
                    completionHandler(nil)
                }))
                
                
                // After having added the textfield and the action buttons to the alert controller,
                // call the configurationHandler closure and pass the first textfield and the didFinishConfiguration closure.
                // When that one gets called, the alert will be presented.
                if let textFields = self.alertController.textFields {
                    if textFields.count > 0 {
                        configurationHandler(textFields[0], {
                            DispatchQueue.main.async { [unowned self] in
                                hostVC.present(self.alertController, animated: true, completion: nil)
                            }
                        })
                    } else { configurationHandler(nil, {}) }
                } else { configurationHandler(nil, {}) }
            }
            
        } else {
            // The host view controller is nil and the alert controller cannot be presented.
            NSLog("[GTAlertCollection]: No host view controller was specified")
            configurationHandler(nil, {})
        }
    }
 
    
    
    
    /// It presents an alert controller with variable number of text fields, as well as a Done and a Cancel action button. Titles of both are modifiable. Alert title and message included too.
    ///
    /// **Implementation Example:**
    ///
    /// ```
    /// GTAlertCollection.shared.presentMultipleTextFieldsAlert(withTitle: "Input Data",
    ///                                                         message: "Lots of stuff to type here...",
    ///                                                         doneButtonTitle: "OK",
    ///                                                         cancelButtonTitle: "Cancel",
    ///                                                         numberOfTextFields: 5,
    ///                                                         configurationHandler: { (textFields, didFinishConfiguration) in
    ///     if let textFields = textFields {
    ///         let placeholders = ["First name", "Last name", "Nickname", "Email", "Password"]
    ///         for i in 0..<textFields.count {
    ///             textFields[i].placeholder = placeholders[i]
    ///         }
    ///
    ///         textFields.last?.isSecureTextEntry = true
    ///
    ///         // ... more configuration ...
    ///
    ///         didFinishConfiguration()
    ///     }
    /// }) { (textFields) in
    ///     if let textFields = textFields {
    ///         // Do something with the textfields.
    ///     }
    /// }
    /// ```
    ///
    ///
    /// - Parameters:
    ///   - title: The optional title of the alert.
    ///   - message: The optional message of the alert.
    ///   - doneButtonTitle: The Done button title. Default value is "Done".
    ///   - cancelButtonTitle: The Cancel button title. Default value is "Cancel".
    ///   - numberOfTextFields: The number of textfields you want to display on the alert.
    ///   - configurationHandler: A closure where you can configure the properties of all textfields before the alert is presented. The first parameter of the closure is the collection of the textfields in the alert, the second parameter it's a closure that must be called manually when you finish configuring the textfields, so it's possible for the alert to be presented.
    ///   - completionHandler: Called when the Done button is tapped. It contains the collection of textfields as a parameter.
    ///   - didFinishConfiguration: Calling this closure from your code is **mandatory**. You do that after having configured the textfields. If you don't make any configuration, call it directly in the `configurationHandler` closure.
    ///   - textFields: The collection of the text fields in the alert. Be careful with it and always unwrap it before using it, as it can be `nil`.
    ///   - editedTextFields: The collection of the text fields in the alert as they're at the moment the Done button gets tapped. Always unwrap it before using it as it might be `nil`.
    func presentMultipleTextFieldsAlert(withTitle title: String?, message: String?, doneButtonTitle: String = "Done", cancelButtonTitle: String = "Cancel", numberOfTextFields: Int, configurationHandler: @escaping (_ textFields: [UITextField]?, _ didFinishConfiguration: () -> Void) -> Void, completionHandler: @escaping (_ editedTextFields: [UITextField]?) -> Void) {
        // Check if the host view controller has been set.
        if let hostVC = hostViewController {
            // Work on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController is nil before initializing it.
                self.cleanUpAlertController()
                
                // Initialize the alert controller.
                self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                // Add the desired number of textfields to the alert controller.
                for _ in 0..<numberOfTextFields {
                    self.alertController.addTextField(configurationHandler: { (textField) in
                        
                    })
                }
                
                // Add the two actions to the alert controller (Done & Cancel).
                self.alertController.addAction(UIAlertAction(title: doneButtonTitle, style: .default, handler: { (action) in
                    if let textFields = self.alertController.textFields {
                        if textFields.count > 0 {
                            // When the Done button is tapped, return the textfields collection.
                            completionHandler(textFields)
                        } else { completionHandler(nil) }
                    } else { completionHandler(nil) }
                }))
                
                self.alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { (action) in
                    
                }))
                
                
                // After having added the textfield and the action buttons to the alert controller,
                // call the configurationHandler closure and pass the textfields collection and the didFinishConfiguration closure.
                // When that one gets called, the alert will be presented.
                if let textFields = self.alertController.textFields {
                    if textFields.count > 0 {
                        configurationHandler(textFields, {
                            DispatchQueue.main.async { [unowned self] in
                                hostVC.present(self.alertController, animated: true, completion: nil)
                            }
                        })
                    } else { configurationHandler(nil, {}) }
                } else { configurationHandler(nil, {}) }
            }
            
        } else {
            // The host view controller is nil and the alert controller cannot be presented.
            NSLog("[GTAlertCollection]: No host view controller was specified")
            configurationHandler(nil, {})
        }
    }
    
    
    
    
    /// It presents a buttonless alert controller with a progress bar, and optionally a label indicating the progress percentage or the progress steps made out of all steps at any given moment.
    ///
    /// The default configuration of the progress view and the label taking place in this method is good enough for most cases.
    /// However, if you want to set or modify additional properties on any of those two controls, you can use the class properties `progressBar` and `label` respectively.
    ///
    /// **Implementation Example:**
    ///
    /// ```
    /// // Step 1: In your class declare the following property:
    /// var updateHandler: ((_ currentItem: Int, _ totalItems: Int) -> Void)!
    ///
    /// // Step 2: Implement the alert presentation somewhere in a method:
    /// GTAlertCollection.shared.presentProgressBarAlert(withTitle: "Upload", message: "Your files are being uploaded...", progressTintColor: .red, trackTintColor: .lightGray, showPercentage: true, showStepsCount: false, updateHandler: { (updateHandler) in
    ///
    ///     self.updateHandler = updateHandler
    ///
    /// }) { (success) in
    ///     if success {
    ///         // doRealWork() is a method that makes the actual work and updates the progress as well.
    ///         self.doRealWork()
    ///     }
    /// }
    ///
    /// // Step 3: In the doRealWork() method:
    /// func doRealWork() {
    ///     // Implement the method's logic.
    ///
    ///     // When the time comes to update the progress:
    ///     if let updateHandler = self.updateHandler {
    ///         // currentStep and totalSteps represent the progress steps.
    ///         updateHandler(currentStep, totalSteps)
    ///     }
    /// }
    ///
    /// ```
    ///
    /// - Parameters:
    ///   - title: The optional title of the alert.
    ///   - message: The optional message of the alert.
    ///   - progressTintColor: The progress tint color.
    ///   - trackTintColor: The track tint color.
    ///   - showPercentage: Make it `true` when you want the progress to be displayed as a percentage right below the progress bar. Make it `false` to show the items count, or disable the label appearance.
    ///   - showStepsCount: Make it `true` to show the steps that have been made at any given moment, or `false` when you want to either show the progress as a percentage, or totally disable the label.
    ///   - updateHandler: Use that closure to update the progress.
    ///   - currentStep: The current step represented by the progress bar among all steps.
    ///   - totalSteps: The total number of steps until the progress reaches at 100%.
    ///   - presentationCompletion: Called after the alert controller has been presented or when the `hostViewController` is `nil`, and indicates whether the alert controller was presented successfully or not.
    ///   - success: When `true` the alert controller has been successfully presented to the host view controller, otherwise it's `false`.
    func presentProgressBarAlert(withTitle title: String?, message: String?, progressTintColor: UIColor, trackTintColor: UIColor, showPercentage: Bool, showStepsCount: Bool, updateHandler: @escaping (_ updateHandler: @escaping (_ currentStep: Int, _ totalSteps: Int) -> Void) -> Void, presentationCompletion: @escaping (_ success: Bool) -> Void) {
        // Check if the host view controller has been set.
        if let hostVC = hostViewController {
            // Operate on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController is nil before initializing it.
                self.cleanUpAlertController()
                
                // Initialize the alert controller.
                self.alertController = UIAlertController(title: title, message: (message ?? "") + "\n\n", preferredStyle: .alert)
                
                // Add more space if the progress percentage or steps count should be displayed.
                if showPercentage || showStepsCount {
                    self.alertController.message! += "\n"
                }
                
                // Initialize the progress bar.
                if self.progressBar != nil {
                    self.progressBar = nil
                }
                self.progressBar = UIProgressView()
                
                // Set its color.
                self.progressBar.progressTintColor = progressTintColor
                self.progressBar.trackTintColor = trackTintColor
                
                // Set the initial progress.
                self.progressBar.progress = 0.0
                
                // Add it to the alert controller's view as a subview.
                self.alertController.view.addSubview(self.progressBar)
                
                // Specify the following constraints to make it appear properly.
                self.progressBar.translatesAutoresizingMaskIntoConstraints = false
                self.progressBar.leftAnchor.constraint(equalTo: self.alertController.view.leftAnchor, constant: 16.0).isActive = true
                self.progressBar.rightAnchor.constraint(equalTo: self.alertController.view.rightAnchor, constant: -16.0).isActive = true
                
                if showPercentage || showStepsCount {
                    self.progressBar.bottomAnchor.constraint(equalTo: self.alertController.view.bottomAnchor, constant: -28.0).isActive = true
                } else {
                    self.progressBar.bottomAnchor.constraint(equalTo: self.alertController.view.bottomAnchor, constant: -8.0).isActive = true
                }
                
                
                // Uncomment the following to change the height of the progress bar.
                // self.progressBar.heightAnchor.constraint(equalToConstant: 5.0).isActive = true
                
                
                // Create a label right below the progress view if any text status should be displayed.
                if showPercentage || showStepsCount {
                    if self.label != nil {
                        self.label = nil
                    }
                    self.label = UILabel()
                    self.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
                    self.label.textColor = UIColor.black
                    self.label.textAlignment = .center
                    
                    if showPercentage {
                        self.label.text = "\(self.progressBar.progress * 100.0)%"
                    } else {
                        self.label.text = "0 / 0"
                    }
                    
                    
                    self.alertController.view.addSubview(self.label)
                    self.label.translatesAutoresizingMaskIntoConstraints = false
                    self.label.centerXAnchor.constraint(equalTo: self.alertController.view.centerXAnchor).isActive = true
                    self.label.topAnchor.constraint(equalTo: self.progressBar.bottomAnchor, constant: 8.0).isActive = true
                    self.label.widthAnchor.constraint(equalToConstant: 180.0).isActive = true
                    self.label.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
                }
                
                self.alertController.view.layoutIfNeeded()
                
                
                // Present the alert controller to the host view controller.
                hostVC.present(self.alertController, animated: true, completion: {
                    // Call the presentation completion handler passing true to indicate that the alert was presented.
                    presentationCompletion(true)
                    
                    // Implement the updateHandler closure.
                    // In it, update the progress of the progress bar, and the label if any text output should be displayed.
                    updateHandler({ currentStep, totalSteps in
                        DispatchQueue.main.async { [unowned self] in
                            self.progressBar.setProgress(Float(currentStep)/Float(totalSteps), animated: true)
                            
                            if showPercentage {
                                self.label.text = "\(Int(self.progressBar.progress * 100.0))%"
                            } else if showStepsCount {
                                self.label.text = "\(currentStep) / \(totalSteps)"
                            }
                        }
                    })
                })
            }
            
        } else {
            // The host view controller is nil and the alert controller cannot be presented.
            NSLog("[GTAlertCollection]: No host view controller was specified")
            presentationCompletion(false)
        }
    }
    
    
    
    
    /// It presents an alert controller that contains an image view. It also displays action buttons, and the default title and message of the alert.
    ///
    /// To access the image view and set or modify additional properties, use the `imageView` class property.
    ///
    /// **Implementation example:**
    ///
    /// ```
    /// // Specify your image:
    /// // let image = ...
    ///
    /// // Present the alert.
    /// GTAlertCollection.shared.presentImageViewAlert(withTitle: "Your Avatar", message: "What do you want to do with it?", buttonTitles: ["Change it", "Remove it", "Cancel"], cancelButtonIndex: 2, destructiveButtonIndices: [1], image: image) { (actionIndex) in
    ///     // Handle the actionIndex value...
    /// }
    ///
    /// ```
    ///
    /// - Parameters:
    ///   - title: The optional title of the alert.
    ///   - message: The optional message of the alert.
    ///   - buttonTitles: The array with the action button titles. Give the titles in the order you want them to appear.
    ///   - cancelButtonIndex: If there's a *Cancel-styled* button you want to exist among buttons, then here's the place where you specify it's **position** in the `buttonTitles` array. Pass `nil` if there's no Cancel-styled button.
    ///   - destructiveButtonIndices: An array with the **position** of one or more *destructive* buttons in the collection of buttons. Pass `nil` if you have no destructive buttons to show.
    ///   - image: The image to be displayed in the image view.
    ///   - actionHandler: Use this block to determine which action button was tapped by the user. The `actionIndex` parameter provides you with that information.
    ///   - actionIndex: The index of the tapped action.
    func presentImageViewAlert(withTitle title: String?, message: String?, buttonTitles: [String], cancelButtonIndex: Int?, destructiveButtonIndices: [Int]?, image: UIImage, actionHandler: @escaping (_ actionIndex: Int) -> Void) {
        // Check if the host view controller has been set.
        if let hostVC = hostViewController {
            // Operate on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController is nil before initializing it.
                self.cleanUpAlertController()
                
                // Initialize the alert controller.
                self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                // Add a few empty lines to make room for the imageview.
                var updatedMessage = self.alertController.message ?? ""
                for _ in 0..<10 {
                    updatedMessage += "\n"
                }
                self.alertController.message = updatedMessage

                // Create the action buttons.
                let actions = self.createAlertActions(usingTitles: buttonTitles, cancelButtonIndex: cancelButtonIndex, destructiveButtonIndices: destructiveButtonIndices, actionHandler: actionHandler)
                for action in actions {
                    self.alertController.addAction(action)
                }
                
                
                // Initialize the imageview and configure it.
                if let _ = self.imageView {
                    self.imageView = nil
                }
                self.imageView = UIImageView()
                self.imageView.image = image
                self.imageView.contentMode = .scaleAspectFill
                self.imageView.layer.cornerRadius = 8.0
                self.imageView.layer.masksToBounds = false
                self.imageView.clipsToBounds = true
                
                // Add it to the alert controller's view.
                self.alertController.view.addSubview(self.imageView)
                
                // Specify its constraints.
                self.imageView.translatesAutoresizingMaskIntoConstraints = false
                self.imageView.centerXAnchor.constraint(equalTo: self.alertController.view.centerXAnchor).isActive = true
                self.imageView.bottomAnchor.constraint(equalTo: self.alertController.view.bottomAnchor, constant: -16.0 - (44.0 * CGFloat(buttonTitles.count))).isActive = true
                self.imageView.widthAnchor.constraint(equalToConstant: self.alertController.view.frame.size.width/3).isActive = true
                self.imageView.heightAnchor.constraint(equalToConstant: self.alertController.view.frame.size.width/3).isActive = true
                self.alertController.view.layoutIfNeeded()
                
                
                // Present the alert controller to the host view controller.
                hostVC.present(self.alertController, animated: true, completion: {
                    
                })
            }
            
        } else {
            // The host view controller is nil and the alert controller cannot be presented.
            NSLog("[GTAlertCollection]: No host view controller was specified")
        }
        
        
    }
    
}
