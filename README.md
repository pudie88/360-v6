# 🚀 360 V6 自动编译项目 (ImmortalWrt)

[![Build Status](https://img.shields.io/github/actions/workflow/status/你的用户名/仓库名/build.yml?branch=master&label=编译状态&logo=github)](https://github.com/你的用户名/仓库名/actions)
基于 **ImmortalWrt Master** 分支，针对 360 V6 深度定制的“玩家级”固件。

---

## 🛠 设备规格
* **设备名称**：奇虎 360 V6 (Qihoo 360V6)
* **核心架构**：Qualcomm IPQ6018 (aarch64_cortex-a53)
* **编译目标**：`qualcommax` / `ipq60xx`
* **适配范围**：适用于原厂 NAND 闪存版本（128MB）

## ✨ 固件特色
- **纯净稳定**：基于 ImmortalWrt 源码，完美适配高通 IPQ 平台。
- **现代代理**：内置 **HomeProxy** + **sing-box**，支持 Reality/Hysteria2/TUICv5。
- **极致体验**：默认 **Argon** 主题，配合全中文适配。
- **常用工具**：集成 `htop`, `bash`, `curl`, `wget`, `nano`, `openssh-sftp-server`。
- **性能优化**：开启 **Shortcut-FE** 网络加速，显著降低高并发下的 CPU 占用。

## 📥 登录信息
| 项目 | 默认值 |
| :--- | :--- |
| **管理地址** | `192.168.1.1` |
| **用户名** | `root` |
| **初始密码** | `none` (无密码) |

## 📦 文件说明
| 文件名后缀 | 适用场景 |
| :--- | :--- |
| `*-factory.ubi` | **首次刷机**：在 U-Boot 下刷入，将原厂分区转为 UBI。 |
| `*-sysupgrade.bin` | **日常升级**：已在 OpenWrt 系统内通过 LuCI 升级。 |
| `*-uImage.itb` | **救砖测试**：通过 TFTP 载入内存启动，不写入闪存。 |
| `.config` | 记录了本次编译的所有插件选择，方便复现。 |

## 🚀 刷机与验证
### 1. 首次刷入
请确保已解锁 SSH 并刷入兼容的 U-Boot（如 pb-boot 或 qsdk-u-boot）。

### 2. 系统内升级
路径：`系统` -> `备份/升级` -> `刷写新固件`。建议勾选 **“不保留配置”** 以获得最佳稳定性。

### 3. 验证型号
进入终端执行以下命令确认硬件适配：
```bash
cat /tmp/sysinfo/board_name
# 正确返回：qihoo,360v6
```

## ⚙️ 开发者指南 (GitHub Actions)
1.  **修改插件**：编辑 `.config` 文件增加或删除包。
2.  **脚本定制**：在 `diy-part1.sh` 修改源码仓库，在 `diy-part2.sh` 修改默认 IP、主题等。
3.  **触发编译**：提交代码并 `git push`，GitHub Actions 将自动开启编译流程。

## ⚠️ 注意事项
* **源码说明**：官方 OpenWrt 24.10 目前对 360 V6 支持有限，本项目坚持使用 **ImmortalWrt** 以获得更好的硬件驱动支持。
* **风险自担**：刷机有风险，操作需谨慎。建议手头留有一份 TTL 救砖工具。
