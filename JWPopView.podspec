

Pod::Spec.new do |s|

  s.name         = "JWPopView"
  s.version      = "0.1.2"
  s.summary      = "JWPopView，一款自用的弹框控件。\n1:修改了Sheet无Title、无Content时，高度计算错误的问题。\n2:新增了蒙板颜色修改的功能。\n3:新增了收起回调。\n4:适配iPhoneX"

  #主页
  s.homepage     = "https://github.com/junwangInChina/JWPopView"
  #证书申明
  s.license      = { :type => 'MIT', :file => 'LICENSE' }


  #作者
  s.author       = { "wangjun" => "github_work@163.com" }
  #支持版本
  s.platform     = :ios, "7.0"
  #版本地址
  s.source       = { :git => "https://github.com/junwangInChina/JWPopView.git", :tag => "#{s.version}" }
 

  #库文件路径（相对于.podspec文件的路径）
  s.source_files  = "JWPopView/JWPopView/**/*.{h,m}"
  #是否支持arc
  s.requires_arc = true
  #外用库
  s.dependency 'Masonry'
end
