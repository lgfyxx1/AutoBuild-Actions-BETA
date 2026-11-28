# OpenWrt-Actions & One-key AutoUpdate

AutoBuild-Actions 稳定版仓库地址: [AutoBuild-Actions-Template](https://github.com/Hyy2001X/AutoBuild-Actions-Template)

自用修改版软件包地址: [AutoBuild-Packages](https://github.com/Hyy2001X/AutoBuild-Packages)

支持的 OpenWrt 源码: `coolsnowwolf/lede`、`immortalwrt/immortalwrt`、`openwrt/openwrt`、`lienol/openwrt`、`padavanonly/immortalwrtARM`、`hanwckf/immortalwrt-mt798x`

## 维护设备列表

| 维护 | 型号 | 配置文件 (TARGET_PROFILE) | 源 | 备注 |
| :----: | :----: | :----: | :----: | :----: |
| ✅ | [x86_64](./.github/workflows/AutoBuild-x86_64.yml) | [x86_64](./Configs/x86_64) | [lede](https://github.com/coolsnowwolf/lede) |  |
| ❎ | [新路由3](./.github/workflows/AutoBuild-d-team_newifi-d2.yml) | [d-team_newifi-d2](./Configs/d-team_newifi-d2) | [lede](https://github.com/coolsnowwolf/lede) |  |
| ❎ | [华硕 ACRH17](./.github/workflows/AutoBuild-asus_rt-ac42u.yml) | [asus_rt-ac42u](./Configs/asus_rt-ac42u) | [lede](https://github.com/coolsnowwolf/lede) |  |
| ❎ | [竞斗云 2.0](./.github/workflows/AutoBuild-p2w_r619ac-128m.yml) | [p2w_r619ac-128m](./Configs/p2w_r619ac-128m) | [lede](https://github.com/coolsnowwolf/lede) |  |
| ❎ | [小娱C5](./.github/workflows/AutoBuild-xiaoyu_xy-c5.yml) | [xiaoyu_xy-c5](./Configs/xiaoyu_xy-c5) | [lede](https://github.com/coolsnowwolf/lede) |  |
| ❎ | [红米 AC2100](./.github/workflows/AutoBuild-xiaomi_redmi-router-ac2100.yml) | [xiaomi_redmi-router-ac2100](./Configs/xiaomi_redmi-router-ac2100) | [lede](https://github.com/coolsnowwolf/lede) |  |
| ❎ | [红米 AX6S](./.github/workflows/AutoBuild-xiaomi_redmi-router-ax6s.yml) | [xiaomi_redmi-router-ax6s](./Configs/xiaomi_redmi-router-ax6s) | [lede](https://github.com/coolsnowwolf/lede) |  |
| ✅ | [中国移动 RAX3000M](./.github/workflows/AutoBuild-cmcc_rax3000m.yml) | [cmcc_rax3000m](./Configs/cmcc_rax3000m) | [immortalwrt-mt798x](https://github.com/hanwckf/immortalwrt-mt798x) |  |
| ✅ | [捷希 Q30](./.github/workflows/AutoBuild-jcg_q30.yml) | [jcg_q30](./Configs/jcg_q30) | [immortalwrt-mt798x](https://github.com/hanwckf/immortalwrt-mt798x) |  |

🔔 **为了你的账号安全, 请不要使用 SSH 连接 Github Actions**, `.config` 配置以及固件定制等操作请务必在本地完成 🔔

🎈 **提示**: 文档中的 **TARGET_PROFILE** 为编译的设备名称(代号), 例如: `d-team_newifi-d2`、`asus_rt-acrh17`、`x86_64`
   
**TARGET_PROFILE** 本地获取方法如下:
   
① 执行`make menuconfig`, 进行设备选择后即可保存并退出
   
② 在源码目录执行`egrep -o "CONFIG_TARGET.*DEVICE.*=y" .config | sed -r 's/.*DEVICE_(.*)=y/\1/'`
   
或`grep 'TARGET_PROFILE' .config` 均可获取 **TARGET_PROFILE**

## 一、定制固件(可选)

1. **Fork** 该仓库, 并进入你自己的`AutoBuild-Actions`仓库, **下方所有操作都将在你的`AutoBuild-Actions`仓库下进行**, 可以 **Clone** 到本地操作

   建议使用`Github Desktop`或`Notepad--`进行编辑和提交操作 [[Github Desktop](https://desktop.github.com/)] [[Notepad--]([https://notepad-plus-plus.org/downloads/](https://gitee.com/cxasm/notepad--/releases/tag/v2.11))]

2. 编辑`Configs`目录下的配置文件, 配置文件的命名一般为**TARGET_PROFILE**, 若配置文件不存在则需要在本地生成并上传

3. 编辑`.github/workflows/***.yml`文件, 修改`第 7 行 name:`, 填写一个便于识别的名称 `e.g. NEWIFI D2`

4. 编辑`.github/workflows/***.yml`文件, 修改`第 32 行 CONFIG_FILE:`, 填写你添加到`Configs`目录下的配置名称

5. 公共参数与 AX6000 定制请编辑 [Scripts/AutoBuild_Custom.sh](./Scripts/AutoBuild_Custom.sh)。该文件由 `AutoBuild_DiyScript.sh` 自动加载，无需修改工作流。

| 配置内容 | 维护位置 |
| --- | --- |
| 公共参数：默认 IP、作者、AutoBuild 特性等 | `AutoBuild_Custom.sh` → `Firmware_Diy_Core()` |
| AutoUpdate 软件包来源（所有设备共用） | `AutoBuild_Custom.sh` → `Firmware_Packages_AutoUpdate()` |
| AX6000 插件仓库/分支、Go 升级、冲突包清理、Mihomo 核心下载 | `AutoBuild_Custom.sh` → `Firmware_Diy_AX6000()` |
| AX6000 插件启用/停用、Xray 等编译选项 | [Configs/redmi_ax6000](./Configs/redmi_ax6000) |
| 其他设备的定制逻辑 | [Scripts/AutoBuild_DiyScript.sh](./Scripts/AutoBuild_DiyScript.sh) → `Firmware_Diy()` |

AX6000 的新脚本保留现有源码来源和执行顺序。AList、SSR Plus+、OpenClash 的 LuCI 界面包当前仍使用上游 `feeds.conf.default` 指定的 `immortalwrt/luci` 的 `openwrt-21.02` 分支；额外克隆的同名包未在此次拆分中替换 feeds 版本。

**Scripts/AutoBuild_Custom.sh: Firmware_Diy_Core() 函数中的变量:**
```
   Author 作者名称, AUTO: [自动识别]
   
   Author_URL 自定义作者网站或域名, AUTO: [自动识别]

   Default_Flag 固件标签 (名称后缀), 适用不同配置文件, AUTO: [自动识别]

   Default_IP 固件 IP 地址

   Default_Title 终端首页显示的额外信息

   Short_Fw_Date 简短的固件日期, true: [20210601]; false: [202106012359]

   x86_Full_Images 额外上传已检测到的 x86 虚拟磁盘镜像, true: [上传]; false: [不上传]
   
   Fw_MFormat 自定义固件格式, AUTO: [自动识别]

   Regex_Skip 输出固件时丢弃包含该内容的文件

   AutoBuild_Features 自动添加 AutoBuild 固件特性, 建议开启

   注: 禁用某功能请将变量值修改为 false, 开启则为 true

```

## 二、编译固件

   **手动编译** 点击上方工具栏中的`Actions`选项, 在左侧选择设备,点击右方`Run workflow`再点击`绿色按钮`即可开始编译

   **Star 一键编译** 编辑`.github/workflows/***.yml`文件, 删除注释`#`符号并提交修改, 单击或双击点亮右上角的 **Star** ⭐按钮即可一键编译

```
  #watch:
  #  types: [started]
```
   **定时编译** 编辑`.github/workflows/***.yml`文件, 删除注释`#`符号, 并按需修改时间并提交修改 [Corn 使用方法](https://www.runoob.com/w3cnote/linux-crontab-tasks.html)
```
  #schedule:
  #  - cron: 0 8 * * 5
```
   **临时修改固件 IP 地址** 该功能仅在**手动编译**生效, 点击`Run workflow`后即可输入 IP 地址
   
   **使用其他 [.config] 配置文件** 点击`Run workflow`后即可选择`Configs`目录下的配置文件名称

## 三、部署云端日志(可选)

1. 下载本仓库中的 [Update_Logs.json](https://github.com/Hyy2001X/AutoBuild-Actions/releases/download/AutoUpdate/Update_Logs.json) 到本地 (如果有)

2. 以 **JSON** 格式编辑本地的`Update_Logs.json`

3. 手动上传修改后的`Update_Logs.json`到`Github Release`

4. 在本地执行`autoupdate --fw-log`测试

## 使用一键更新固件脚本(可选)

   首先需要打开`TTYD 终端`或者使用`SSH`, 按需输入下方指令:

   更新固件: `autoupdate`

   使用镜像加速更新固件: `autoupdate -P`

   更新固件(不保留配置): `autoupdate -n`
   
   强制刷写固件(危险): `autoupdate -F`
   
   强制下载并刷写固件: `autoupdate -f`

   更新脚本: `autoupdate -x`
   
   打印运行日志:  `autoupdate --log`

   查看脚本帮助: `autoupdate --help`

## 鸣谢

   - [Lean's Openwrt Source code](https://github.com/coolsnowwolf/lede)

   - [P3TERX's Blog](https://p3terx.com/archives/build-openwrt-with-github-actions.html)

   - [ImmortalWrt's Source code](https://github.com/immortalwrt)

   - [eSir 's workflow template](https://github.com/esirplayground/AutoBuild-OpenWrt/blob/master/.github/workflows/Build_OP_x86_64.yml)
   
   - [[openwrt-autoupdate](https://github.com/mab-wien/openwrt-autoupdate)] [[Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)]

   - 测试与建议: [CurssedCoffin](https://github.com/CurssedCoffin) [Licsber](https://github.com/Licsber) [sirliu](https://github.com/sirliu) [神雕](https://github.com/teasiu) [yehaku](https://www.right.com.cn/forum/space-uid-28062.html) [缘空空](https://github.com/NaiHeKK) [281677160](https://github.com/281677160)
