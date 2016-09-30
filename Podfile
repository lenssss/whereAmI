# Uncomment this line to define a global platform for your project
 platform :ios, '8.0'
# Uncomment this line if you're using Swift
 use_frameworks!

target 'Whereami' do
    pod 'Socket.IO-Client-Swift','~> 6.1.1'
    pod 'pop','~> 1.0.9'
#    pod 'JAMSVGImage','~> 1.6.1'
    pod 'PureLayout','~> 3.0.1'
    pod 'ReactiveCocoa','~> 4.1.0'
    #pod 'SDWebImage'
    pod 'Kingfisher','~> 2.4.0'
    pod 'Google-Mobile-Ads-SDK','~> 7.8.0'
    pod 'MagicalRecord','~> 2.3.2'                  # coredata orm
    pod 'FBSDKLoginKit’,’~>4.13.1’
    pod 'MaterialControls','~> 1.0.2'
    pod 'MWPhotoBrowser','~> 2.1.2'
    #pod 'TZImagePickerController'        
    pod 'MJRefresh','~> 3.1.0'
    #pod 'MBProgressHUD'
    pod 'SVProgressHUD','~> 2.0.3'
    pod 'SWTableViewCell','~> 0.3.7'
    pod 'BABCropperView','~> 0.5.0'
    pod 'UMengAnalytics-NO-IDFA','~> 4.0.5'
    pod 'DKImagePickerController','~> 3.3.2'
    
    pod 'AVOSCloud','~> 3.3.5’               # 数据存储、短信、云引擎调用等基础服务模块
    pod 'AVOSCloudIM','~> 3.3.5’             # 实时通信模块

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end

end

target 'WhereamiTests' do

end

target 'WhereamiUITests' do

end

