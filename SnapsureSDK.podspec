Pod::Spec.new do |spec|
    spec.name           = "Snapsure"
    spec.version        = "1.0.0"
    spec.summary        = "Snapsure SDK for IOS."

    spec.homepage       = "https://github.com/snapsure-insurance-bot/snapsure-sdk-ios"
    spec.license        = { type: 'MIT', file: 'LICENSE' }
    spec.authors        = { "Snapsure GmbH" => 'http://snapsure.de' }
    spec.platform       = :ios
    spec.requires_arc   = true

    spec.ios.deployment_target  = '8.0'
    spec.source                 = { git: "https://github.com/snapsure-insurance-bot/snapsure-sdk-ios", tag: "#{spec.version}"}
    spec.source_files           = "Sources/*.{h,swift}"
end
