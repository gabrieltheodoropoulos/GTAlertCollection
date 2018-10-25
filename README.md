# GTAlertCollection

`UIAlertController` is a default iOS SDK controller that we all use in our applications from time to time. Presenting such a controller is not a difficult task at all, but there are a few disadvantages coming with it:

1.  It's boring and totally anti-productive to write almost identical code multiple times.
2.  We write unnecessary lines of code, while we should be able to display the alert controller and handle the actions fast.
3.  For common cases it's easy to remember what to do. But what happens in more rare cases where we want to present an alert controller with an activity indicator, or a progress bar in it? That's definitely not something we do every day, so all we get is loss of time trying to find how exactly to implement these kind of alerts.

The above have been troubling me for years, so I decided to do something drastic about that: To create the **GTAlertCollection** library. And now it's time to share it with the world.

In it, neither I'm reinventing the wheel, nor I suggest alternative or custom alert controllers. I still keep the default `UIAlertController` coming with iOS SDK, but I *automate* the way we use it so we can move fast, easily, and efficiently when it's necessary to integrate it in our projects. And I achieve this through a series of methods that prepare and present specific kind of alert controllers. And that brings us to the following:

1.  No more boring code to initialise a `UIAlertController` object and then present it. Just calling the proper function from the library and passing the necessary arguments is enough to do the job.
2.  The number of lines required now are way too less than the traditional method of creating alert controllers. That means cleaner code. It also means that we can focus on the content we want to present through the alert, and on handling the actions tapped by the user.
3.  Rare alert controller cases are included, so they can be used as easily as possible without having to scratch our head about the "how-to". For example, presenting alert controllers that contain an activity indicator, image view, progress bar and text fields is as difficult as calling a function is.

Being more specific now, with a single call to the methods provided by `GTAlertCollection` we can create:

*   Single-button alert controller
*   Alert controller with variable number of buttons with all supported styles: Default, Cancel, Destructive
*   Buttonless alert controller
*   Alert controller with an activity indicator
*   Alert controller with a progress bar, including text representation of the progress (either percentage, or number of steps made)
*   Alert controller with a single text field
*   Alert controller with multiple text fields
*   Alert controller with an image view

![GTAlertCollection Demo](https://gtiapps.com/gtalertcollection/gtalertcollection_demo_small.gif)

`GTAlertCollection` is a class written in Swift, and all of its properties and methods are documented so it's easy to be used. The exported documentation can be found [here](https://gtiapps.com/docs/gtalertcollection/Classes/GTAlertCollection.html).

## GTAlertCollection provided methods and properties at a glance

Here's a list that contains all public methods provided by `GTAlertCollection`:

```swift
presentSingleButtonAlert(withTitle:message:buttonTitle:actionHandler:)
presentAlert(withTitle:message:buttonTitles:cancelButtonIndex:destructiveButtonIndices:actionHandler:)
presentButtonlessAlert(withTitle:message:presentationCompletion:)
presentActivityAlert(withTitle:message:activityIndicatorColor:showLargeIndicator:presentationCompletion:)
presentProgressBarAlert(withTitle:message:progressTintColor:trackTintColor:showPercentage:showStepsCount:updateHandler:presentationCompletion:)
presentSingleTextFieldAlert(withTitle:message:doneButtonTitle:cancelButtonTitle:configurationHandler:completionHandler:)
presentMultipleTextFieldsAlert(withTitle:message:doneButtonTitle:cancelButtonTitle:numberOfTextFields:configurationHandler:completionHandler:)
presentImageViewAlert(withTitle:message:buttonTitles:cancelButtonIndex:destructiveButtonIndices:image:actionHandler:)
dismissAlert(completion:)
```

In addition to those, there are the following properties you can access as well:

*   `alertController`: The presented alert controller.
*   `hostViewController`: The view controller that the alert controller is presented to.
*   `activityIndicator`: The activity indicator of the alert.
*   `progressBar`: The `UIProgressView` object that displays the progress bar.
*   `label`: The label right below the progress bar.
*   `imageView`: The image view of the alert.


## Integrating GTAlertCollection

To integrate `GTAlertCollection` in your project and start using it, just clone or download the repository, and drag-n-drop the *GTAlertCollection.swift* from the Sources folder file into your project.


## Using GTAlertCollection

There is one requirement before we start using any of the `GTAlertCollection` methods; to specify the *host view controller*, meaning the view controller where the alert controller will be presented to. This can be done in two ways, depending on how we are planning to `GTAlertCollection`:

The first is to initialise a custom object of it. Declare the following property in your class:

```swift
var alertCollection: GTAlertCollection!
```

And then in the `viewDidLoad()` or in the `viewWillAppear(_:)` initialise it using the following `init` method:

```swift
alertCollection = GTAlertCollection(withHostViewController: self)
```

After that, use the `alertCollection` object to access all public methods.

The second, and probably more flexible way, is to use the `shared` instance of the `GTAlertCollection` class. In this case, there's no `init` method, but we have to set the host view controller manually. The best place to do that would be once again either in the `viewDidLoad()` or in the `viewWillAppear(_:)` method, so the shared instance has been configured before we start using the library.

```swift
GTAlertCollection.shared.hostViewController = self
```

### Presenting a single button alert

To present an alert controller that will contain the title, the message (both are optional values) and one button only using `GTAlertCollection`, here's what we need to do:

```swift
GTAlertCollection.shared.presentSingleButtonAlert(withTitle: "Welcome", message: "This is a simple alert!", buttonTitle: "Got it", actionHandler: {

    print("Single Button Alert - Action button was tapped")

})
```

![Single-button Alert](https://gtiapps.com/gtalertcollection/gtalertcollection_single_button_alert.png)

The action button's title can be customised and specified in the `buttonTitle` parameter. The action handler closure is the place where we write all the code that should be executed after the user has tapped on the action button. The above example just prints a message when the button is tapped.

### Presenting an alert controller with multiple action buttons

The method we are going to see now, is a general method that can be used to present alerts with a varying number of action buttons. These buttons can have any of the supported action styles, such as Default, Cancel and Destructive. To understand how exactly it works, let's go through 2-3 different examples:

Initially, let's present an alert with two action buttons:

```swift
GTAlertCollection.shared.presentAlert(withTitle: "A Question", message: "What do you think?", buttonTitles: ["Yes", "No"], cancelButtonIndex: nil, destructiveButtonIndices: nil) { (actionIndex) in

    if actionIndex == 0 {
        print("It's a Yes")
    } else {
        print("It's a No")
    }

}
```

![Two buttons alert](https://gtiapps.com/gtalertcollection/gtalertcollection_two_buttons_alert.png)

Let's discuss a bit about the parameters of the above method:

*   `withTitle`: This is the title of the alert. It's optional, so pass `nil` if you just don't want to display a title.
*   `message`: The message that will appear on the alert's body. It's optional too, so pass `nil` if there's no message to show.
*   `buttonTitles`: It's an *array* that should contain the titles of the action buttons that will be shown on the alert, *in the order you want them to appear*. The number of actions that will be auto-generated for the alert will be equal to the number of the titles in that array, so make sure you provide only the titles for the buttons you want to appear.
*   `cancelButtonIndex`: All action buttons of the alert are styled using the Default style option. However, if you would like to have one action that will act as the *Cancel* button and therefore to be styled accordingly, all you have to do is to specify the *position* of it in the collection of actions. Next example demonstrates that.
*   `destructiveButtonIndices`: Similarly to the above, if you want to show one or more Destructive-styled actions (those having red text color), just create an array with the indices of all action buttons that should be styled like that.
*   Action handler & `actionIndex` parameter: `actionIndex` is an Int value indicating the index of the action button tapped by the user. The first action has index 0. Using it you can determine the path your app should take after the user taps on any action button shown in the alert.

Let's take a look now on how to present an alert with multiple action buttons, *including destructive and cancel actions* as well:

```swift
GTAlertCollection.shared.presentAlert(withTitle: "Your Options",
                                      message: "What would you like to do?",
                                      buttonTitles: ["Create", "Update", "Delete one", "Delete all", "Cancel"],
                                      cancelButtonIndex: 4,
                                      destructiveButtonIndices: [2, 3]) { (actionIndex) in

                                        print("You tapped on button at index \(actionIndex)")
}   
```

The above example demonstrates the usage of the `cancelButtonIndex` and `destructiveButtonIndices` parameter values. Notice that the last action with index 4 (titled "Cancel") is marked as the Cancel-styled button, while actions at indices 2 & 3 (titled "Delete one" & "Delete all" respectively) are marked as destructive. Here's what is presented:

![Multiple buttons alert](https://gtiapps.com/gtalertcollection/gtalertcollection_multiple_buttons_alert.png)

Again, use the `actionIndex` to determine the tapped action button.

Finally, let's see one last example where we have two action buttons; one is Cancel-styled and the other is Destructive-styled:

```swift
GTAlertCollection.shared.presentAlert(withTitle: "Delete your account?", message: "This action is irreversible!", buttonTitles: ["Yes, delete", "Cancel"], cancelButtonIndex: 1, destructiveButtonIndices: [0], actionHandler: { (actionIndex) in

    if actionIndex == 0 {
        print("Account was deleted")
    } else {
        print("Cancelled account deletion")
    }

})
```

![Destructive alert](https://gtiapps.com/gtalertcollection/gtalertcollection_-destructive_alert.png)

### Presenting a buttonless alert

One of my favourites is the buttonless alert, which is great to show a message without having user interaction. A buttonless alert is actually a common alert controller, but with no action buttons. Presenting a buttonless alert with `GTAlertCollection` looks like that:

```swift
GTAlertCollection.shared.presentButtonlessAlert(withTitle: "Buttonless", message: "This is a buttonless alert!") { (success) in      
    if success {
        // The alert controller was presented...            
    }
}
```

Apart from the title and the message, there's a completion handler that contains a parameter called `success`. When that value is `true`, then the alert controller has been presented successfully, otherwise it has not. So, always check the value of that flag before taking any actions in the completion handler.

![Buttonless alert](https://gtiapps.com/gtalertcollection/gtalertcollection_buttonless_alert.png)

Since a buttonless alert has no action buttons to be tapped by the user, and therefore to be dismissed, it's our duty to remove it when it's appropriate to do so. Dismissing it takes the following:

```swift
GTAlertCollection.shared.dismissAlert(completion: nil)
```

If you want to know when the alert has been actually dismissed, don't pass `nil` in the completion above, instead implement the closure body:

```swift
GTAlertCollection.shared.dismissAlert(completion: {
    // Do something after the alert has been dismissed...
})
```

### Presenting an alert with an activity indicator

An alert with an activity indicator can be used to indicate that a process is in progress, but the length of that process cannot be determined. The following method allows us present such an alert:

```swift
GTAlertCollection.shared.presentActivityAlert(withTitle: "Please wait", message: "You are being connected to your account...", activityIndicatorColor: .blue, showLargeIndicator: false) { (success) in
    if success {

    }
}
```

![Activity Alert](https://gtiapps.com/gtalertcollection/gtalertcontroller_activity_alert.png)

This method introduces two new parameter values: `activityIndicatorColor` which is the desired color for the indicator, and `showLargeIndicator` which is a `Bool` value specifying whether the indicator should be small or large. By default, `activityIndicatorColor` is set to black, and `showLargeIndicator` is set to false.

The completion handler of the above method contains the `success` parameter value that we've already seen in the buttonless alert. When `true`, the alert has been successfully presented to the host view controller.

Similarly to the buttonless alert, it's our responsibility to dismiss the alert! See previous examples to find out how.

### Presenting an alert with a progress bar.

An alert with a progress bar is good for showing a process being in progress, but this time the length of the process is known beforehand. Here's how we can present such an alert:

```swift
GTAlertCollection.shared.presentProgressBarAlert(withTitle: "Upload", message: "Your files are being uploaded...", progressTintColor: .red, trackTintColor: .lightGray, showPercentage: true, showStepsCount: false, updateHandler: { (updateHandler) in
    // Update the progress here...    
}) { (success) in
    if success {
       // Do something after the alert has been presented..
    }
}
```

There are a few things to discuss here, so let's start with the new parameters being available:

*   `progresstTintColor`: It's the tint color of the progress bar (the graphical part moving and showing the progress).
*   `trackTintColor`: It's the tint color of the track (the graphical part that looks "empty" and gets filled by the progress bar gradually).
*   `showPercentage`: When it's `true`, a percentage of the overall process is being displayed right below the progress bar. Set the `showStepsCount` to `false` to use it.
*   `showStepsCount`: When it's `true`, a message similar to "5 / 50" is displayed right below the progress bar, indicating the current step of the entire process, as well the total steps required until the process gets completed. To use it, switch the `showPercentage` to `false`.

If you don't want any textual message below the progress bar, pass `false` for both `showPercentage` and `showStepsCount` arguments.

There are also two handler blocks. The second one used to determine if the alert was presented successfully to the host view controller, and once again we have the `success` parameter that shows that. But the most interesting is the first one, where we can update the progress.

There's a parameter called `updateHandler` in the first handler closure, which must be called just like that when we want to update the progress:

```swift
updateHandler(currentStep, totalSteps)
```

It expects two arguments, where the first one indicates the current step in the overall process, and the second the total steps required to be done until the process gets finished.

There are two ways to use the `updateHandler`. First, inside the closure where we apply all the required logic by the app, and we update the progress as well. The following example demonstrates that:

```swift
GTAlertCollection.shared.presentProgressBarAlert(withTitle: "Upload", message: "Your files are being uploaded...", progressTintColor: .red, trackTintColor: .lightGray, showPercentage: true, showStepsCount: false, updateHandler: { (updateHandler) in

    let totalSteps = 50
    var currentStep = 0

    Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
        currentStep += 1

        updateHandler(currentStep, totalSteps)

        if currentStep == totalSteps {
            timer.invalidate()

            GTAlertCollection.shared.dismissAlert(completion: nil)
        }

    })

}) { (success) in
    if success {

    }
}
```

The code above will keep updating the progress every 0.05 seconds, until the `currentStep` reaches the `totalSteps` value. At the end, it dismisses the alert. See the usage of the `updateHandler` that makes it possible to update the progress visually.

The second way, and most probably the most usual case, is to use the `updateHandler` out of the closure body. The above example works fine, but it's just a demo. In most cases, you'll want to start updating the process once you know that the alert has been presented, and of course after the real work that leads to the progress updating has started. To cover that scenario, first of all you need a property in your class where you'll keep the `updateHandler` parameter so you can access it later:

```swift
// Declare this as a class property.
var updateHandler: ((_ currentItem: Int, _ totalItems: Int) -&gt; Void)!
```

Next, in the first closure of the above method assign the `updateHandler` to the property we just declared. At the same time, in the second closure start doing the real work once the alert has been presented. Let's see the method updated as described here:

```swift
GTAlertCollection.shared.presentProgressBarAlert(withTitle: "Upload", message: "Your files are being uploaded...", progressTintColor: .red, trackTintColor: .lightGray, showPercentage: true, showStepsCount: false, updateHandler: { (updateHandler) in

    self.updateHandler = updateHandler

}) { (success) in
    if success {
        self.updateProgress()
    }
}
```

For our demonstration, the real work for us is taking place in the `updateProgress()` method, which simply updates the progress:

```swift
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
```

That snippet is similar to the previous one that updates the progress visually. Even though it's a simple example, all steps presented here is your guide for real-life projects too.

![Progress bar alert](https://gtiapps.com/gtalertcollection/gtalertcontroller_progress_bar_alert.png)

### Presenting an alert with a single text field

Having text fields in alert controllers is not unusual, and of course that kind of alert could not be missing from `GTAlertCollection`. In fact, there are two methods you can use to present alerts with text fields. The first one which we'll see in this part is a convenient method that adds one text field to the alert only, while the second one allows you to add as many text fields as you want.

Let's get started, and let's see how to present an alert with a single text field in it:

```swift
GTAlertCollection.shared.presentSingleTextFieldAlert(withTitle: "Editor", message: "Feel free to type something:", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", configurationHandler: { (textField, didFinishConfiguration) in

    if let textField = textField {
        // Configure the textfield properties.

        // Always call the following to let the alert controller appear.
        didFinishConfiguration()
    }

}) { (textField) in
    if let textField = textField {
        // Do something with the textfield's text...
    }
}
```

![Single-textfield alert](https://gtiapps.com/gtalertcollection/gtalertcontroller_single_textfield_alert.png)

The alert has two default action buttons, one for accepting the changes, and one to cancel. You can override the default titles ("Done" and "Cancel" respectively) for both.

The method above provides two interesting action handlers (closures). The first one is used to *configure the text field's properties before the alert gets presented*. Always follow the example shown above, and always make sure that the `textField` is not `nil` before accessing any of its properties.

And here's a really **important** rule:

*After having finished configuring the text field, always call the `didFinishConfiguration` closure to allow the alert to be presented!*

`didFinishConfiguration` is a closure (as stated already), which you can name it however you want, but you must mandatorily call it once you're done with the text field configuration. Omitting that will lead to no alert presentation at all.

The second action handler returns the text field once user has finished editing it and the Done action button has been tapped. Once again, unwrap before using it, and then extract the text or whatever else you want out of it.

### Presenting an alert with multiple text fields

The following method that presents an alert controller with multiple text fields is quite similar to the one presented in the previous part. The greatest difference that you'll notice is that instead of dealing with a single text field only, we are dealing with a collection of text fields:

```swift
GTAlertCollection.shared.presentMultipleTextFieldsAlert(withTitle: "Input Data", message: "Lots of stuff to type here...", doneButtonTitle: "OK", cancelButtonTitle: "Cancel", numberOfTextFields: 5, configurationHandler: { (textFields, didFinishConfiguration) in

    if let textFields = textFields {
        // Configure all textfields one by one.

        // Call the following to allow alert to be presented.
        didFinishConfiguration()
    }

}) { (textFields) in
    if let textFields = textFields {
        // Do something with the textfields.

        for i in 0..&lt;textFields.count {
            print(textFields[i].text ?? "")
        }
    }
}
```

There's an additional parameter in this method, called `numberOfTextFields`. Use it to specify the number of text fields you want to appear on the alert.

![Multiple textfields alert](https://gtiapps.com/gtalertcollection/gtalertcontroller_multiple_textfields_alert.png)

All rules previously discussed apply here too, so make sure you read that part as well.

### Presenting an alert with an image view

`GTAlertCollection` also offers the possibility to present an alert controller with an image view in it, and multiple action buttons. Here's how to do that:

```swift
GTAlertCollection.shared.presentImageViewAlert(withTitle: "Your Avatar", message: "What do you want to do with it?", buttonTitles: ["Change it", "Remove it", "Cancel"], cancelButtonIndex: 2, destructiveButtonIndices: [1], image: image) { (actionIndex) in

    print("You tapped on button at index \(actionIndex)")
}
```

Most of the parameters have been already discussed, but there's a new one called `image`. Use it to specify the image you want to be displayed to the image view of the alert.

![Imageview alert](https://gtiapps.com/gtalertcollection/gtalertcontroller_imageview_alert.png)

## Chained Alert Controllers

The following snippet demonstrates how we can *chain* the presentation of different alert controllers. In this example, we simulate the login process and we use three alerts for that.

*   The first one, is an alert with two textfields where users enter email and password.
*   The second alert is an activity alert displaying a wait message.
*   The third and last alert is a single button alert that informs about the successful connection to the fake account.

Notice in the next code that when there's user interaction with the alert, there's no need for us to dismiss the alert. But in case where there's no interaction (the alert with the activity indicator), it's our job to manually dismiss the alert.

```swift
GTAlertCollection.shared.presentMultipleTextFieldsAlert(withTitle: "Login", message: "Connect to your account:", doneButtonTitle: "Login", cancelButtonTitle: "Cancel", numberOfTextFields: 2, configurationHandler: { (textFields, didFinishConfiguration) in

    // Make sure that the required number of textfields exist.
    if let textFields = textFields {
        if textFields.count == 2 {
            // Configure both textfields.
            textFields[0].placeholder = "Email"
            textFields[0].textContentType = UITextContentType.emailAddress
            textFields[1].placeholder = "Password"
            textFields[1].isSecureTextEntry = true

            // Call the following to let the alert get presented.
            didFinishConfiguration()
        }
    }

}) { (textFields) in
    // The Login action button has been tapped in this case.
    // Check if the proper number of textfields exist.
    if let textFields = textFields {
        if textFields.count == 2 {
            // For the sake of the example, just check if both textfields have values,
            // we don't care about the actual values right now.
            if textFields[0].text != "" && textFields[1].text != "" {
                // There is no need to dismiss the alert manually,
                // as it's being dismissed when the Login button is tapped.

                // Show a new alert with an activity indicator and a message saying to wait.
                GTAlertCollection.shared.presentActivityAlert(withTitle: "Please Wait", message: "You are being connected to your account...", activityIndicatorColor: .red, showLargeIndicator: true, presentationCompletion: { (success) in

                    if success {
                        // The new alert has been presented.
                        // In a real application, this would be the place where the actual connection
                        // would start taking place.

                        // In this example we'll dismiss the activity alert after 2 seconds.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {

                            // Time to dismiss the alert.
                            GTAlertCollection.shared.dismissAlert(completion: {

                                // After it has been dismissed, we'll present a new one to welcome
                                // the connected user and inform that the connection was successful.
                                GTAlertCollection.shared.presentSingleButtonAlert(withTitle: "Welcome", message: "You are now connected to your account!", buttonTitle: "OK", actionHandler: {

                                })

                            })

                        })
                    }

                })
            }
        }
    }
}
```

Here's a demo of the code above:

![Chained Alerts](https://gtiapps.com/gtalertcollection/chained_alert_small.gif)

## Final Words

Using a `UIAlertController` is not that common when creating custom UI, as most of the times the look and feel of the alert does not match at all to the look and feel of the rest of the app. However, this small library might be proved helpful in apps where it makes no difference in the UI/UX when presenting the default alert controller. But even in the first case, where the default alert controller doesn't fit to the app, you can still use this library while developing for fast input and output. I do that, and that's where the need for having this library came from.

That's all. Now, I hope you enjoy it!
