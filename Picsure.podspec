Pod::Spec.new do |spec|
    spec.name           = "Picsure"
    spec.version        = "1.0"
    spec.summary        = "Picsure SDK for iOS."

    spec.homepage       = "https://picsure.ai"
    spec.license        = { type: 'MIT', file: 'LICENSE' }
    spec.authors        = { "Picsure GmbH" => 'mail@picsure.ai' }
    spec.platform       = :ios
    spec.requires_arc   = true

    spec.ios.deployment_target  = '8.0'
    spec.source                 = { git: "https://github.com/picsure/picsure-sdk-ios.git", tag: "#{spec.version}"}
    spec.source_files           = "Sources/**/*.{h,swift}"
end
