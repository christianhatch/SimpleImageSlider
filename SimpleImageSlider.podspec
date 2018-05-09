

Pod::Spec.new do |s|
    s.name             = 'SimpleImageSlider'
    s.version          = '1.0.3'
    s.summary          = 'SimpleImageSlider is a simple view that creates a scrollable gallery of images.'

    s.description      = <<-DESC
    SimpleImageSlider is a simple image gallery view that allows a user to scroll horizontally through an array of images. Great for collection view and table view headers, or anywhere you need an image gallery!
    DESC

    s.homepage         = 'https://github.com/christianhatch/SimpleImageSlider'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Christian Hatch' => 'christianhatch@gmail.com' }
    s.source           = { :git => 'https://github.com/christianhatch/SimpleImageSlider.git', :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/commodoreftp'

    s.ios.deployment_target = '9.0'

    s.source_files = 'SimpleImageSlider/Classes/**/*'

    s.dependency 'AFNetworking'
    s.dependency 'PureLayout'
end
