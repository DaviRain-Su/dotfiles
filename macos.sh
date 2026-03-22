#!/bin/bash

# ============================================
# macOS 系统配置脚本
# 参考: https://mths.be/macos
# ============================================

set -e

# 关闭 System Preferences 以防止覆盖设置
osascript -e 'tell application "System Preferences" to quit'

# 请求管理员权限
sudo -v

# 保持 sudo 会话
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ============================================
# 通用 UI/UX
# ============================================

# 禁用启动音效
sudo nvram SystemAudioVolume=" "

# 禁用透明度
# defaults write com.apple.universalaccess reduceTransparency -bool true

# 设置高亮颜色为绿色
defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"

# 设置侧边栏图标大小为中等
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# 始终显示滚动条
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# 禁用焦点环动画
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# 调整工具栏标题悬停延迟
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0

# 保存面板默认展开
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# 打印面板默认展开
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# 自动退出打印机应用
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# 禁用 "您确定要打开此应用程序吗？" 对话框
defaults write com.apple.LaunchServices LSQuarantine -bool false

# 禁用恢复窗口
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# 禁用自动终止
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# 设置帮助查看器在后台打开
defaults write com.apple.helpviewer DevMode -bool true

# 重启后重新打开窗口
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# ============================================
# 输入设备
# ============================================

# 启用键盘重复
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# 设置键盘重复速率
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# 启用全键盘访问
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# 禁用自动纠正
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# 禁用自动大写
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# 禁用自动句号
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# 禁用智能引号和破折号
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# 启用触控板轻触点击
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# 启用三指拖移
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# ============================================
# 屏幕
# ============================================

# 要求密码立即
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# 屏幕截图保存到桌面
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# 屏幕截图格式为 PNG
defaults write com.apple.screencapture type -string "png"

# 禁用屏幕截图阴影
defaults write com.apple.screencapture disable-shadow -bool true

# 启用 HiDPI 显示模式
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

# ============================================
# Finder
# ============================================

# 显示隐藏文件
defaults write com.apple.finder AppleShowAllFiles -bool true

# 显示所有文件扩展名
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# 禁用更改扩展名警告
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# 使用列表视图
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# 显示路径栏
defaults write com.apple.finder ShowPathbar -bool true

# 显示状态栏
defaults write com.apple.finder ShowStatusBar -bool true

# 在标题栏显示完整路径
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# 搜索时默认搜索当前文件夹
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# 禁用创建 .DS_Store 文件
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# 清空废纸篓时禁用警告
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# 启用 AirDrop 在所有接口
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# ============================================
# Dock
# ============================================

# 启用自动隐藏
defaults write com.apple.dock autohide -bool true

# 移除自动隐藏延迟
defaults write com.apple.dock autohide-delay -float 0

# 加速动画
defaults write com.apple.dock autohide-time-modifier -float 0.5

# 使用小图标
defaults write com.apple.dock tilesize -int 48

# 启用放大
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 64

# 禁用弹跳
defaults write com.apple.dock launchanim -bool false

# 使隐藏应用图标变暗
defaults write com.apple.dock showhidden -bool true

# 禁用最近应用
defaults write com.apple.dock show-recents -bool false

# 只显示打开的应用
defaults write com.apple.dock static-only -bool true

# ============================================
# Safari
# ============================================

# 启用开发者菜单
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# 禁用自动填充
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# 启用调试菜单
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# 显示完整 URL
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# 禁用打开安全文件
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# ============================================
# Mail
# ============================================

# 禁用发送动画
defaults write com.apple.mail DisableSendAnimations -bool true
defaults write com.apple.mail DisableReplyAnimations -bool true

# 启用调试菜单
defaults write com.apple.mail MailAttributes -dict-add "DebugMenuEnabled" -bool true

# 禁用下载附件
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# ============================================
# Terminal
# ============================================

# 启用 UTF-8
defaults write com.apple.terminal StringEncodings -array 4

# 禁用行标记
defaults write com.apple.Terminal ShowLineMarks -int 0

# ============================================
# Time Machine
# ============================================

# 禁用提示使用新硬盘
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# ============================================
# Activity Monitor
# ============================================

# 显示所有进程
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# 按 CPU 排序
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# ============================================
# 重启应用
# ============================================

echo "配置完成！正在重启相关应用..."

for app in "Activity Monitor" "Dock" "Finder" "Mail" "Safari" "SystemUIServer" "Terminal"; do
    killall "${app}" &> /dev/null || true
done

echo "✅ macOS 配置完成！"
echo ""
echo "注意：某些设置需要注销并重新登录才能生效。"
