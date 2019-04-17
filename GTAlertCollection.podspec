Pod::Spec.new do |spec|

  spec.name         = "GTAlertCollection"
  spec.version      = "1.0.1"
  spec.summary      = "GTAlertCollection: UIAlertController variations gathered in one place, introducing new simplified usage."
  spec.description  = <<-DESC
                    GTAlertCollection is a Swift component that makes it possible to present alert controllers as easily as just calling a single method. Based on the `UIAlertController`, it implements and provides a variety of alert types.
                   DESC
  spec.homepage     = "https://github.com/gabrieltheodoropoulos/GTAlertCollection.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.authors      = { "Gabriel Theodoropoulos" => "gabrielth.devel@gmail.com" }
  spec.social_media_url   = "https://twitter.com/gabtheodor"
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/gabrieltheodoropoulos/GTAlertCollection.git", :tag => "1.0.1" }
  spec.source_files = "GTAlertCollection/Source/*.{swift}"
  spec.swift_version = "4.2"

end
