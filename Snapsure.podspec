Pod::Spec.new do |spec|
    spec.name           = "Snapsure"
    spec.version        = "0.0.9"
    spec.summary        = "Snapsure SDK for iOS."

    spec.homepage       = "http://snapsure.de"
    spec.license        = { type: 'MIT', file: 'LICENSE' }
    spec.authors        = { "Snapsure GmbH" => 'mail@snapsure.de' }
    spec.platform       = :ios
    spec.requires_arc   = true

    spec.ios.deployment_target  = '8.0'
    spec.source                 = { git: "https://github.com/snapsure-insurance-bot/snapsure-sdk-ios.git", tag: "#{spec.version}"}
    spec.source_files           = "Sources/**/*.{h,swift}"
end
