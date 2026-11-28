#!/bin/bash
# AutoBuild Module by Hyy2001 <https://github.com/Hyy2001X/AutoBuild-Actions-BETA>
# 公共参数、AutoUpdate 来源和 AX6000 定制集中在此维护。
# 由 AutoBuild_DiyScript.sh 加载，在工作流的各个定制阶段调用，请勿直接执行。
# 插件启用/停用仍修改 Configs/redmi_ax6000 中的 CONFIG_PACKAGE_...。

Firmware_Diy_Core() {

	# 请在该函数内按需修改变量设置, 使用 case 语句控制不同预设变量的设置

	# 可用预设变量
	# ${OP_AUTHOR}			OpenWrt 源码作者
	# ${OP_REPO}			OpenWrt 仓库名称
	# ${OP_BRANCH}			OpenWrt 源码分支
	# ${CONFIG_FILE}		配置文件

	Author=AUTO
	# 作者名称, AUTO: [自动识别]

	Author_URL=AUTO
	# 自定义作者网站或域名, AUTO: [自动识别]

	Default_Flag=AUTO
	# 固件标签 (名称后缀), 适用不同配置文件, AUTO: [自动识别]

	Default_IP="192.168.3.10"
	# 固件 IP 地址

	Default_Title="Powered by AutoBuild-Actions"
	# 固件终端首页显示的额外信息

	Short_Fw_Date=true
	# 简短的固件日期, true: [20210601]; false: [202106012359]

	x86_Full_Images=false
	# 额外上传已检测到的 x86 虚拟磁盘镜像, true: [上传]; false: [不上传]

	Fw_MFormat=AUTO
	# 自定义固件格式, AUTO: [自动识别]

	Regex_Skip="packages|buildinfo|sha256sums|manifest|kernel|rootfs|factory|itb|profile|ext4|json"
	# 输出固件时丢弃包含该内容的固件/文件

	AutoBuild_Features=true
	# 添加 AutoBuild 固件特性, true: [开启]; false: [关闭]

	AutoBuild_Features_Patch=false
	AutoBuild_Features_Kconfig=false
}

Firmware_Packages_AutoUpdate() {
	# 所有设备共用，在 Firmware_Diy_Main 中添加并写入固件更新参数。
	AddPackage other Hyy2001X AutoBuild-Packages master
}

Firmware_Diy_AX6000() {
	# 适用于 hanwckf/immortalwrt-mt798x 的 xiaomi_redmi-router-ax6000。
	# 上游 feeds.conf.default 保持原样，AList 从 immortalwrt/luci openwrt-21.02 获取。
	# 当前 SSR Plus+、OpenClash 的界面包也使用该 LuCI feed；下方保留额外克隆。
	# PassWall 和 iStore 使用下方指定的第三方仓库。

	# 升级 golang 到上游最新分支（Xray-core 等新版 Go 包会持续提高 Go 版本要求）
	GOLANG_BRANCH=$(git ls-remote --heads https://github.com/sbwml/packages_lang_golang | awk -F'refs/heads/' '{print $2}' | grep -E '^[0-9]+\.x$' | sort -V | tail -n1)
	[ -z "${GOLANG_BRANCH}" ] && GOLANG_BRANCH=27.x
	echo "Using golang branch: ${GOLANG_BRANCH}"
	rm -rf ${WORK}/feeds/packages/lang/golang
	git clone --depth 1 https://github.com/sbwml/packages_lang_golang -b ${GOLANG_BRANCH} ${WORK}/feeds/packages/lang/golang

	# 移除 feeds 中的旧版/冲突包，防止与 AddPackage 包产生重复
	rm -rf ${FEEDS_PKG}/xray-core ${WORK}/feeds/packages/net/xray-core 2>/dev/null || true
	rm -rf ${FEEDS_PKG}/xray-plugin ${WORK}/feeds/packages/net/xray-plugin 2>/dev/null || true
	rm -rf ${FEEDS_LUCI}/luci-app-passwall ${WORK}/feeds/luci/applications/luci-app-passwall 2>/dev/null || true

	# AddPackage <package 子目录> <GitHub 用户/组织> <仓库> <分支>
	AddPackage other fw876 helloworld dev
	AddPackage other vernesong OpenClash master
	AddPackage other linkease istore main
	AddPackage passwall Openwrt-Passwall openwrt-passwall-packages main
	AddPackage passwall Openwrt-Passwall openwrt-passwall main

	# 修改默认 IP（Firmware_Diy_Main 使用全局 Default_IP，此处确保 AX6000 使用正确 IP）
	sed -i 's/192.168.1.1/192.168.3.10/g' ${BASE_FILES}/bin/config_generate

	# 下载 OpenClash Meta (Mihomo) 核心
	curl -sL -m 30 --retry 2 https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz -o /tmp/clash_meta.tar.gz
	tar zxf /tmp/clash_meta.tar.gz -C /tmp >/dev/null 2>&1
	chmod +x /tmp/clash
	mkdir -p ${WORK}/package/other/OpenClash/luci-app-openclash/root/etc/openclash/core
	mv /tmp/clash ${WORK}/package/other/OpenClash/luci-app-openclash/root/etc/openclash/core/clash_meta
	rm -f /tmp/clash_meta.tar.gz
}
