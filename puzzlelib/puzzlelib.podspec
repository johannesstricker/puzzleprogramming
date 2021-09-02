Pod::Spec.new do |spec|
  spec.name         = "puzzlelib"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of puzzlelib."
  spec.description  = <<-DESC
  A library to detect and decode puzzle pieces with math equations.
                   DESC
  spec.homepage     = "https://github.com/johannesstricker/puzzleprogramming"
  spec.license      = "MIT"
  spec.author             = { "Johannes Stricker" => "johannesstricker@gmx.net" }
  spec.source       = { :path => '.' }
  spec.source_files  = [
    "src/puzzlelib.cpp",
  ]
  spec.private_header_files = []
  spec.public_header_files = [
    "include/**/*.{h,hpp}"
  ]
  spec.header_mappings_dir = "include/puzzlelib"

  spec.dependency 'OpenCV', '~> 4.3'
  spec.xcconfig = {
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'CLANG_CXX_LIBRARY' => 'libc++',
  }
  spec.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
  }
  spec.library = 'c++'
  spec.platform = :ios, '11.0'
  spec.static_framework = true

  # this needs to be a subspec in order to get the include directories right
  spec.subspec 'aruco' do |subspec|
    subspec.source_files  = ["src/aruco/src/**/*.{cpp,hpp}"]
    subspec.public_header_files = ["src/aruco/include/**/*.hpp"]
    subspec.header_mappings_dir = "src/aruco/include/"
  end
end
