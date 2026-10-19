# codex-glass-vibecoding

这是我的第一个 **Vibe Coding** 项目，主要以学习和实践为目的。我希望借助 AI 辅助编程，学习如何从界面想法出发，逐步完成一个可以运行的 Windows 桌面小工具。

本项目学习和参考了 **[GGBond2424648901/codex-glass](https://github.com/GGBond2424648901/codex-glass)**。感谢原作者的开源分享，给了我很大的启发。这里明确说明参考来源，也欢迎大家了解原项目。

目前我的经验有限，项目在代码质量、交互设计、数据展示和兼容性方面可能还有不足。如果你发现问题，或认为有需要改进、补充说明的地方，请及时通过 **Issues** 指出。我会认真学习、核实并逐步改进，也欢迎交流建议。

这是一个第三方学习项目，与 OpenAI 无隶属关系。

![浅色界面，数值为演示数据](docs/preview.png)

## 功能

- 查看 Codex 账号额度、剩余比例和重置时间。
- 查看账号累计 Token、近 7 天已返回记录合计、今日或最近记录、单日峰值。
- 切换卡片、柱状、折线、双仪表；悬停或点击查看精确数值、记录比较、占比与重置时间，支持手动复制。
- 自由拖动和缩放，字体与模块自适应；支持深浅主题、精简模式、置顶和托盘。

## 下载与运行

1. 从 **Releases** 下载 `codex-glass-vibecoding-v1.1.0-win-x64.zip`。
2. **完整解压**到普通文件夹，再双击 `codex-glass-vibecoding.exe` 或 `一键启动.vbs`。不要在压缩包里直接运行，也不要只复制 EXE。
3. 已安装并登录自己的 Windows 原生 Codex CLI 后，程序会尝试连接，每 30 秒刷新一次。F5 或「刷新」可立即更新。

需要 Windows 10 / 11 x64、.NET Framework 4.8、可用的 Codex 网络连接，以及已用 ChatGPT 账号登录的 Windows 原生 Codex CLI。常见桌面版内置 CLI 也会尝试自动发现；仅安装在 WSL 内的 CLI 不适用。

**运行包不包含 Codex CLI、登录账号或订阅。** 可按 [Codex CLI 官方说明](https://developers.openai.com/codex/cli) 安装，使用 `codex login` 登录。API Key 登录不提供这里使用的 ChatGPT Token 汇总接口。GitHub 自动生成的 `Source code (zip)` 是源码，需要自行构建。

请保留 EXE 同目录的 `Glass.xaml`、`VibrancyBlur.ps` 和 `LiquidLens.ps`。系统禁用 VBS 时直接运行 EXE。无需管理员权限；当前程序未签名，请核对来源和 Release 附带的 SHA-256，无需关闭安全软件。

## 操作

| 操作 | 功能 |
| --- | --- |
| 拖动标题 / Alt + 拖动 | 移动浮窗 |
| 拖动边缘或右下角 | 改变窗口大小，字体与模块自适应 |
| Ctrl + 滚轮 / Ctrl + 0 | 缩放 / 恢复推荐尺寸 |
| Ctrl + 1 / 2 / 3 / 4 | 卡片 / 柱状 / 折线 / 仪表 |
| Ctrl + D / F5 | 切换主题 / 刷新 |
| 悬停 / 点击数据 | 查看数值 / 展开详情，也支持 Enter 和空格 |
| Esc | 关闭详情；没有详情时隐藏到托盘 |
| 图钉、− / +、× | 置顶、精简 / 展开、退出 |
| 双击托盘图标 | 恢复浮窗 |

柱状和折线支持整列悬停；详情可选中文本或手动复制，按 Esc 或点击外侧空白关闭。

![详情交互，数值为演示数据](docs/details.png)

## 数据口径与已知不足

- 数据由本机官方 `codex app-server` 的 `account/rateLimits/read` 和 `account/usage/read` 返回；只查询额度与活动汇总，不发起模型对话。
- Token 是**账号级汇总，并非当前对话计数**，不能由额度百分比换算剩余 Token 总量。
- 近 7 天只合计已返回日期，缺失日期不当作 0；今日无记录时显示最近记录日期，缺失指标显示「—」。以本机日期匹配服务端日期，不额外进行时区重分桶。
- 图表最多展示最近 14 条返回记录，日期可能不连续。比较基于上一条返回记录；占比分母为全部返回日期的 Token 合计。详情是打开时的快照。
- CLI 版本、认证方式、接口和网络均可能影响数据可用性。断网时保留上次数据并标记同步失败；倒计时归零不代表已确认恢复额度。
- 目前仅在本机 Windows 环境验证，尚未覆盖所有系统、显示缩放与多显示器组合。费用估算、逐对话统计和历史数据库不在当前实现范围内。

接口参考 [官方 App Server 文档](https://learn.chatgpt.com/docs/app-server)。展示不符合预期时，欢迎提供可复现情况，我会核实口径与实现。

## 隐私与反馈

本工具不读取或复制认证文件内容，不上传遥测；官方 Codex 子进程使用你自己的登录状态。普通运行不保存 Token 用量，手动复制才写入剪贴板。偏好和启动错误位于 `%LOCALAPPDATA%\CodexGlass`，不随发布包分发。

提交 Issue 时请说明 Windows / Codex CLI 版本、复现步骤、预期与实际结果；截图请隐藏个人信息和用量。**不要提交 `.codex`、`auth.json`、API Key、登录令牌或原始认证日志。** 参考来源、归属说明或文档如有不准确之处，也请及时指出。

找不到 CLI 时，可将环境变量 `CODEX_GLASS_CLI` 设为 Windows `codex.exe` 完整路径后重启，不要填写 `.cmd` 包装器或 WSL 路径。额度正常而 Token 缺失时，请检查登录方式、网络和 CLI 版本。

## 源码构建

Windows x64 下，在仓库根目录使用 Windows PowerShell 5.1 和系统 .NET Framework 编译器：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\build.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\package.ps1
```

`app/` 是运行目录，`dist/` 是白名单生成的运行包和校验文件。重新构建前先退出浮窗。

`app\codex-glass-vibecoding.exe --self-test` 检查解析；`--verify --demo` 用演示数据验证交互；`--demo` 可单独运行演示模式，不连接账号。`--verify` 会读取自己的真实账号并产生截图和报告，**不要将其上传**。本文截图均为演示数据。

## 致谢与许可

- 学习参考：[GGBond2424648901/codex-glass](https://github.com/GGBond2424648901/codex-glass)，感谢原作者的开源项目与启发。
- 液态玻璃设计参考：[JUEMING-006/skill-liquid-glass](https://github.com/JUEMING-006/skill-liquid-glass)、[Kyant0/AndroidLiquidGlass](https://github.com/Kyant0/AndroidLiquidGlass)。本项目使用 Windows WPF / HLSL 实现，没有直接运行 Android / Compose 组件。
- 本项目采用 Apache-2.0，见 `LICENSE`。保留的第三方归属与许可见 `NOTICE`、`LiquidGlass.NOTICE`、`LiquidGlass.LICENSE`。

这是一次持续学习的尝试，欢迎指出不足、交流思路，也欢迎提交改进建议。
