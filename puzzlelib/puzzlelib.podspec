Pod::Spec.new do |spec|
  spec.name         = "puzzlelib"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of puzzlelib."
  spec.description  = <<-DESC
                   DESC

  spec.homepage     = "https://github.com/johannesstricker/puzzleprogramming"
  spec.license      = "MIT (example)"
  spec.author             = { "Johannes Stricker" => "johannesstricker@gmx.net" }
  spec.source       = { :path => '.' }
  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"
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
  spec.static_framework = true
end
