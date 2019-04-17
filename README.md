# GTAlertCollection

## About

**GTAlertCollection** is a Swift component that makes it possible to *present alerts as easily as just calling a single method*.

GTAlertCollection implements alert controllers based on the `UIAlertController` class. It supports and provides a variety of alert types:

![GTAlertCollection Demo](https://gtiapps.com/gtalertcollection/gtalertcollection_demo_small.gif)

## Integrating GTAlertCollection into your project

There are two ways to integrate GTAlertCollection into your project.

### Using CocoaPods

In your Podfile add the following:

```ruby
pod 'GTAlertCollection'
```

Then import `GTAlertCollection` anywhere in your project where you want to use it.

```swift
import GTAlertCollection
```

### Manually

Clone or download the repository, and add the *GTAlertCollection.swift* file from the *GTAlertCollection/Source* folder to your project.


## At a glance

The following public methods are provided by `GTAlertCollection`:

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

In addition, these properties are available as well:

*   `alertController`: The presented alert controller.
*   `hostViewController`: The view controller that the alert controller is presented to.
*   `activityIndicator`: The activity indicator of the alert.
*   `progressBar`: The `UIProgressView` object that displays the progress bar.
*   `label`: The label right below the progress bar.
*   `imageView`: The image view of the alert.

Please read the [wiki](https://github.com/gabrieltheodoropoulos/GTAlertCollection/wiki/How-To) for details on how to use `GTAlertCollection` and the various alert types. You can also find [exported documentation](https://gtiapps.com/docs/gtalertcollection/Classes/GTAlertCollection.html) by [jazzy](https://github.com/realm/jazzy).

## Note

The implementation of the various alert controllers and the creation of the `GTAlertCollection` class is personal work and *not* a gathering of alerts found around on the web.
