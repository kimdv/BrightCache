Pod::Spec.new do |spec|

  spec.name = "BrightCache"
  spec.version = "0.1.2"
  spec.summary = "Simple cache build on top of BrightFutures "

  spec.homepage = "https://github.com/kimdv/BrightCache"
  spec.license = { :type => "MIT", :file => "LICENSE" }

  spec.author = { "Kim de Vos" => "kimdevos12@hotmail.com" }
  spec.social_media_url = "https://twitter.com/kimdv"

  spec.platform = :ios, "10.0"

  spec.source = { :git => "https://github.com/kimdv/BrightCache.git", :tag => "#{spec.version}" }
  spec.source_files = 'Sources/BrightCache/**/*.swift'

  spec.dependency 'BrightFutures', '~> 8.0'
  spec.requires_arc = true
  spec.swift_version = '5.0'

end
