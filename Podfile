# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

# link_with 'Boomerang'


def common_pods
    inhibit_all_warnings!
    use_frameworks!

    pod 'Fabric', '1.6.11'
    pod 'Crashlytics', '3.8.4'
    pod 'Parse', ' 1.14.4'
    pod 'ParseLiveQuery', '2.0.0'
    pod 'ParseFacebookUtilsV4', '1.11.1'
    pod 'SwiftyJSON', '3.1.4'
    pod 'JSQMessagesViewController', '7.3.4'
    pod 'Kingfisher', '3.6.2'
    pod 'PHFComposeBarView', '2.0.2'
    pod 'ImagePicker', '2.1.1'
    pod 'SwipeCellKit', '1.9.1'
    pod 'ActiveLabel', '0.7.1'
    
end

target 'lab262.boomerang.test' do
  common_pods
end

target 'lab262.boomerang.production' do
    common_pods
end

target 'lab262.boomerang.dev' do
    common_pods
end

target 'BoomerangTests' do
    inherit! :search_paths
    # Pods for testing
    common_pods
end
