Pod::Spec.new do |spec|
spec.name           = "SnapsureSDK"
spec.version        = "1.0.0"
spec.summary        = ""

spec.homepage       = ""
spec.license        = { type: 'MIT', file: 'LICENSE' }
spec.authors        = { "" => '' }
spec.platform       = :ios
spec.requires_arc   = true

spec.ios.deployment_target  = '8.0'
spec.source                 = { git: "", tag: "#{spec.version}"}
spec.source_files           = "Sources/*.{h,swift}"
end
