# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'realmTestOne' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for realmTestOne

  pod 'RealmSwift', '2.8.1'

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = ‘4.0.2’
        end
    end
end