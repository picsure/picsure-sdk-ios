Pod::Spec.new do |spec|
spec.name           = "SnapsureSKD"
spec.version        = "1.0.0"
spec.summary        = ""

spec.homepage       = ""
spec.license        = { type: 'MIT', file: 'LICENSE' }
spec.authors        = { "" => '' }
spec.platform       = :ios
spec.requires_arc   = true

spec.ios.deployment_target  = '8.4'
spec.source                 = { git: "", tag: "#{spec.version}"}
spec.source_files           = "Sources/*.{h,swift}"
end
