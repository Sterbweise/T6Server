#!/bin/bash

# cn.sh - 使命召唤：黑色行动2 Plutonium服务器的中文语言文件
# 版本: 3.1.1
# 作者: Sterbweise
# 最后更新: 07/12/2024

# 描述:
# 此脚本包含使命召唤：黑色行动2 Plutonium服务器安装、管理和卸载脚本中使用的
# 所有中文字符串。它为中文用户提供本地化支持。

# 使用方法:
# 此文件被其他脚本引用以提供本地化文本输出。不应直接执行此文件。

# 注意：确保此文件位于主脚本相对路径的 .config/lang/ 目录中。

# 安装消息
# 这些消息在服务器安装过程中显示

# 实用工具消息
selectLanguage_cn="选择您的语言："
update_cn="正在更新系统"
bit_cn="正在启用32位包"
finish_cn="安装完成。"
quit_cn="按 CTRL+C 退出。"
dependencies_install_cn="正在安装依赖项。"

# 防火墙消息
firewall_cn="是否要安装UFW防火墙（Y/n）？"
ssh_port_cn="输入要开放的SSH端口（默认：22）："
ssh_port_enter_cn="如果无法使用回车键，请多次按空格键。"
firewall_install_cn="防火墙安装和端口开放。"

# Dotnet消息
dotnet_cn="是否要安装Dotnet [IW4Madmin所需]（Y/n）？"
dotnet_failed_install_cn="Dotnet安装失败。"
dotnet_install_cn="正在安装Dotnet。"

# Wine消息
wine_cn="正在安装Wine。"

# 游戏二进制文件消息
binary_cn="游戏二进制文件安装。"

# 卸载消息
uninstall_options_cn="选择要卸载的组件："
uninstallDotnet_cn="卸载 Dotnet"
uninstallWine_cn="卸载 Wine"
disable_32bit_cn="禁用32位支持"
uninstallFirewall_cn="卸载防火墙"
uninstallGameBinaries_cn="卸载游戏二进制文件"
uninstall_selected_cn="卸载所选组件"
cancel_cn="取消"
select_option_cn="请选择一个选项："
confirmUninstall_selected_cn="您确定要卸载所选组件吗？"
confirmUninstall_cn="确定要卸载吗？这将删除安装脚本安装的所有组件。"
confirm_prompt_cn="输入'y'确认："
uninstall_cancelled_cn="卸载已取消。"
uninstall_binary_cn="正在卸载游戏二进制文件。"
remove_firewall_cn="正在删除防火墙。"
cleanup_cn="正在清理。"
uninstall_finish_cn="卸载完成。"