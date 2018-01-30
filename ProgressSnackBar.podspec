Pod::Spec.new do |s|

    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.name = "ProgressSnackBar"
    s.summary = "Simple and clean snackbar with progress bar."
    s.requires_arc = true

    s.version = "0.0.1"

    s.license = { :type => "MIT", :file => "LICENSE" }

    s.author = { "Jaime Frutos" => "jaime.f.amian@gmail.com" }

    s.homepage = "https://github.com/BambooCode/ProgressSnackBar"

    s.source = { :git => "https://github.com/BambooCode/ProgressSnackBar.git", :tag => "#{s.version}"}

    s.source_files = "ProgressSnackBar/*.{swift}"

end
