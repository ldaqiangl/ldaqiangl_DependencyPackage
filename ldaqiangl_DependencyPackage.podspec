#
#  Be sure to run `pod spec lint ldaqiangl_DependencyPackage.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "ldaqiangl_DependencyPackage"
  s.version      = "0.0.1"
  s.summary      = "项目依赖封装 ldaqiangl_DependencyPackage."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
  大强封装心之力公司项目依赖管理 ldaqiangl_DependencyPackage CopyRight@xzlcrop
                   DESC

  s.homepage     = "http://www.ldaqiangl.com"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  # s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "大强" => "dongfuqiang@xinzhili.cn" }
  # Or just: s.author    = "董富强"
  # s.authors            = { "董富强" => "dongfuqiang@xinzhili.cn" }
  # s.social_media_url   = "http://twitter.com/董富强"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  s.platform     = :ios
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  #  When using multiple platforms
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/ldaqiangl/ldaqiangl_DependencyPackage.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.public_header_files = "ldaqiangl_DependencyPackage/ldaqiangl_DependencyPackage.h"
  s.source_files  = "ldaqiangl_DependencyPackage/ldaqiangl_DependencyPackage.h"
  #{}"ldaqiangl_DependencyPackage", "ldaqiangl_DependencyPackage/**/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  #   CustomUI ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

      s.subspec 'CustomUI' do |customui|

        customui.source_files = 'ldaqiangl_DependencyPackage/CustomUI/DQCustomUI.h'
        customui.public_header_files = 'ldaqiangl_DependencyPackage/CustomUI/DQCustomUI.h'

        # TabBarController
        customui.subspec 'TabBarController' do |sss|

            sss.source_files = 'ldaqiangl_DependencyPackage/CustomUI/TabBarController/**/*.{h,m}'
            sss.public_header_files = 'ldaqiangl_DependencyPackage/CustomUI/TabBarController/**/*.h'
            sss.dependency 'ldaqiangl_DependencyPackage/Kits/CustomControls'
            sss.dependency 'ldaqiangl_DependencyPackage/Kits/Categories'
            sss.dependency 'ldaqiangl_DependencyPackage/Kits/Macros'
        end

        # WebViewController
        customui.subspec 'WebViewController' do |sss|

            sss.source_files = 'ldaqiangl_DependencyPackage/CustomUI/WebViewController/**/*.{h,m}'
            sss.public_header_files = 'ldaqiangl_DependencyPackage/CustomUI/WebViewController/**/*.h'
            sss.dependency 'NJKWebViewProgress'
            sss.dependency 'WebViewJavascriptBridge'
            sss.dependency 'ldaqiangl_DependencyPackage/Kits/Categories'
        end
      end

  #   Helper ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

      s.subspec 'Helper' do |ss|

        ss.source_files = 'ldaqiangl_DependencyPackage/Helper/DQHelper.h'
        ss.public_header_files = 'ldaqiangl_DependencyPackage/Helper/DQHelper.h'

        # 网络请求
        ss.subspec 'NetWork' do |sss|

            sss.source_files = 'ldaqiangl_DependencyPackage/Helper/Network/*.{h,m}'
            sss.public_header_files = 'ldaqiangl_DependencyPackage/Helper/Network/*.h'
            sss.dependency 'AFNetworking'
        end

        # 数据存储
        ss.subspec 'Storage' do |sss|

            sss.source_files = 'ldaqiangl_DependencyPackage/Helper/Storage/*.{h,m}'
            sss.public_header_files = 'ldaqiangl_DependencyPackage/Helper/Storage/*.h'
            sss.dependency 'FMDB'
        end

        # 提示器
        ss.subspec 'Prompt' do |sss|

            sss.source_files = 'ldaqiangl_DependencyPackage/Helper/Prompt/*.{h,m}'
            sss.public_header_files = 'ldaqiangl_DependencyPackage/Helper/Prompt/*.h'
            #sss.resource = 'HXDepedent_utility/Helper/Prompt/HXPromptSource.bundle'
            sss.resource_bundles =
            {
                'Prompt' => ['ldaqiangl_DependencyPackage/Helper/Prompt/Assets/*.png']
            }
            sss.dependency 'MBProgressHUD'
        end
      end

  #   Kits ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

      s.subspec 'Kits' do |kits|

        kits.source_files = 'ldaqiangl_DependencyPackage/Kits/DQKits.h'
        kits.public_header_files = 'ldaqiangl_DependencyPackage/Kits/DQKits.h'

        # 分类
        kits.subspec 'Categories' do |category|

            category.source_files = 'ldaqiangl_DependencyPackage/Kits/Categories/**/*.{h,m}'
            category.public_header_files = 'ldaqiangl_DependencyPackage/Kits/Categories/**/*.h'
            category.dependency 'MJRefresh'
            category.dependency 'DZNEmptyDataSet'
        end

        # 函数
        kits.subspec 'Tools' do |tool|

            tool.source_files = 'ldaqiangl_DependencyPackage/Kits/Tools/**/*'
            tool.public_header_files = 'ldaqiangl_DependencyPackage/Kits/Tools/*.h'
            tool.dependency 'ldaqiangl_DependencyPackage/Kits/Macros'
        end

        # 自定义控件
        kits.subspec 'CustomControls' do |customControl|

            customControl.source_files = 'ldaqiangl_DependencyPackage/Kits/CustomControls/DQCustomControl.h'
            customControl.public_header_files = 'ldaqiangl_DependencyPackage/Kits/CustomControls/DQCustomControl.h'

            # Button
            customControl.subspec 'Button' do |button|

                button.source_files = 'ldaqiangl_DependencyPackage/Kits/CustomControls/Buttons/**/*.{h,m}'
                button.public_header_files = 'ldaqiangl_DependencyPackage/Kits/CustomControls/Buttons/**/*.h'
                button.dependency 'ldaqiangl_DependencyPackage/Kits/Categories'
            end
        end

        # 宏定义
        kits.subspec 'Macros' do |macro|

            macro.source_files = 'ldaqiangl_DependencyPackage/Kits/Macros/**/*'
            macro.public_header_files = 'ldaqiangl_DependencyPackage/Kits/Macros/*.h'
        end
    end

  #   Modules ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

      s.subspec 'Modules' do |ss|

        ss.source_files = 'ldaqiangl_DependencyPackage/Modules/DQModule.h'
        ss.public_header_files = 'ldaqiangl_DependencyPackage/Modules/DQModule.h'

        # App 管理
        ss.subspec 'AppManagerModule' do |sss|

            sss.source_files = 'ldaqiangl_DependencyPackage/Modules/AppManagerModule/*.{h,m}'
            sss.public_header_files = 'ldaqiangl_DependencyPackage/Modules/AppManagerModule/*.h'
            sss.dependency 'ldaqiangl_DependencyPackage/Helper/NetWork'
        end

        # 应用启动
        # ss.subspec 'AppStartModule' do |sss|
        #     sss.source_files = 'ldaqiangl_DependencyPackage/Modules/AppStartModule/*.{h,m}'
        #     sss.public_header_files = 'ldaqiangl_DependencyPackage/Modules/AppStartModule/*.h'
        #     # sss.resource = 'ldaqiangl_DependencyPackage/Modules/AppStart/DQAppStart.bundle'
        # end

        # 多媒体请求
        ss.subspec 'MediaServiceModule' do |sss|

            sss.source_files = 'ldaqiangl_DependencyPackage/Modules/MediaService/*.{h,m}'
            sss.public_header_files = 'ldaqiangl_DependencyPackage/Modules/MediaService/*.h'
            sss.dependency 'ldaqiangl_DependencyPackage/Helper/NetWork'
        end

        # 环境配置
        ss.subspec 'EnvironmentConfigModule' do |sss|
            sss.source_files = 'ldaqiangl_DependencyPackage/Modules/EnvironmentConfig/*.{h,m}'
            sss.public_header_files = 'ldaqiangl_DependencyPackage/Modules/EnvironmentConfig/*.h'
            sss.dependency 'MJExtension'
        end

        # 用户信息
        ss.subspec 'UserInfoCenterModule' do |sss|
            sss.source_files = 'ldaqiangl_DependencyPackage/Modules/UserInfoCenter/*.{h,m}'
            sss.public_header_files = 'ldaqiangl_DependencyPackage/Modules/UserInfoCenter/*.h'
        end

        # 业务请求
        ss.subspec 'BusinessRequestModule' do |sss|
            sss.source_files = 'ldaqiangl_DependencyPackage/Modules/BusinessRequest/**/*.{h,m}'
            sss.public_header_files = 'ldaqiangl_DependencyPackage/Modules/BusinessRequest/**/*.h'
            sss.dependency 'ldaqiangl_DependencyPackage/Helper/NetWork'
            sss.dependency 'ldaqiangl_DependencyPackage/Helper/Storage'
            sss.dependency 'ldaqiangl_DependencyPackage/Modules/MediaServiceModule'
            sss.dependency 'ldaqiangl_DependencyPackage/Modules/EnvironmentConfigModule'
            sss.dependency 'ldaqiangl_DependencyPackage/Modules/UserInfoCenterModule'
            sss.dependency 'MJExtension'
        end
      end
end
