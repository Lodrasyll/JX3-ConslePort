# 本机环境记录

检查日期：2026-11-02（Asia/Shanghai）。完整机器记录见 [client-2026-11-02.json](evidence/client-2026-11-02.json)。

| 项目 | 观察结果 |
|---|---|
| 项目根目录 | `E:\JX3 ConslePort` |
| 客户端根目录 | `E:\SeasunGame\Game\JX3` |
| 旗舰版分支 | `bin\zhcn_hd` |
| 实际插件目录 | `E:\SeasunGame\Game\JX3\bin\zhcn_hd\interface`，原本已存在 |
| 客户端声明版本 | `version.cfg: Sword3.version=1-6-0-10024` |
| 分支/地区 | `versionex=hd`，`RegionCode=2052`，`VersionLineFullName=2052-zhcn` |
| 插件兼容字段 | `Sword3.AddOnVersion=1.0` |
| 客户端执行文件 | `bin64\JX3ClientX64.exe`，11,834,808 字节 |
| 执行文件修改时间 | 2026-10-29 15:00:37 +08:00（文件时间，不是版本号） |
| 已有插件证据 | MY_!Base 与 MY_Target 的 info.ini 均声明 version=1.0、lua_0 入口 |
| 探针版本 | `0.1.1-probe`；manifest 的 `1.0` 不作产品版本使用 |
| 暂存位置 | 实际 interface 下的 `JX3CP_P0`，2 个文件，`default=0` |
| 手柄/连接 | 待提供 |
| 启动器/服务器/游戏内完整构建号 | 未观察，不从目录名称推断 |

`version.cfg` 内保留 2024 年注释，不能用注释年份判断当前版本；这里只记录实际字段。更新缓存中的版本也不能替代运行中客户端的版本。必须在实机记录客户端显示的完整版本，并与此配置值对照。

本机 PATH 没有独立 lua/luac；已在项目 `.tools/python` 安装 Lupa 2.8，以标准 Lua 5.1 和 5.4 运行测试。它们是兼容性检查环境，不代表游戏使用的 Lua 版本。

终端默认沙箱启动失败，但经授权的 shell 可以工作。Windows 应用控制的 node_repl 与 cua_repl 均返回：`windows sandbox failed: helper_unknown_error: setup refresh had errors`。因此本轮没有观察到游戏窗口，也没有执行游戏登录、改键或按键测试。
