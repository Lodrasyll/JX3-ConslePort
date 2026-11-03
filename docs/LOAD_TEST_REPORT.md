# 首轮验证报告

日期：2026-11-02（Asia/Shanghai）。探针 `0.1.1-probe`；本机配置声明版本 `1-6-0-10024` / `hd`。机器证据：[离线结果](evidence/offline-2026-11-02.json)、[客户端与暂存哈希](evidence/client-2026-11-02.json)。

## 用户验收清单

| 检查项 | 状态 | 实际证据 |
|---|---|---|
| 官方渠道确认自制插件测试/认证许可 | 未确认 | 已查询，未取得适用许可；用户要求继续 |
| 确认旗舰版实际 Interface | 通过（文件系统） | `E:\SeasunGame\Game\JX3\bin\zhcn_hd\interface` 已存在且含 MY |
| Lua 离线语法与模拟接口测试 | 通过（离线） | Lua 5.1/5.4：3 个 Lua 文件编译、各 1 次冒烟、各 13 项回归 |
| 获准环境中的插件管理器识别 | 未执行 | 探针已暂存、默认禁用；无管理器画面/认证结果 |
| Main.lua 执行且产生调试信息 | 离线通过；实机未执行 | 模拟 Output 有入口日志；没有游戏日志证据 |
| 快捷键中出现 JX3CP Debug Ping | 未执行 | 模拟调用签名通过不代表游戏设置可见 |
| 按下/抬起各触发一次 | 离线通过；实机未执行 | 模拟 1 次为 down=1/up=1；3 次为 3/3 |
| 记录版本和测试结果 | 本轮完成，实机待补 | 配置版本、产品版本、文件哈希、离线结果已保存 |

## 基线缺陷与修正

原始 `0.1.0-probe` 冒烟通过，但另外复现：

1. `Hotkey=17`：入口抛出 attempt to index global Hotkey。
2. `AddBinding` 返回 false：原型仍返回成功。
3. 入口后再调 Start：注册调用计数变成 2。

`0.1.1-probe` 已修复，并增加日志故障、缺失/异常命名空间、重试、重复入口等 13 项回归。回调采用原始计数，不隐藏重复调用。成功调用注册函数后状态为 `call_ok_unverified`，不表示 UI 可见或认证通过。

## 重现命令

```powershell
python -m pip install --target .tools/python -r requirements-dev.txt --only-binary=:all: --no-deps --index-url https://pypi.org/simple
python tests/run_offline.py --report docs/evidence/offline-2026-11-02.json
```

运行器只编译项目 Lua 并执行模拟用例，不打开客户端。证据 JSON 记录测试源文件 SHA-256，后续修改后必须重跑。

客户端只读复查：

```powershell
python tools/inspect_client.py 'E:\SeasunGame\Game\JX3' --report docs/evidence/client-recheck.json
```

`--stage` 仅用于目标 `JX3CP_P0` 不存在时，遇到已有目录会拒绝覆盖。本轮已暂存，不应重复执行 stage。暂存文件与源码哈希一致；未覆盖 MY，未更改游戏键位或配置。没有进行全量 Interface/配置备份。

## 实机未完成原因

Windows 应用控制运行时启动失败：`windows sandbox failed: helper_unknown_error: setup refresh had errors`；node_repl 和 cua_repl 均失败。这是工具环境故障，不能解释为客户端加载失败或认证拒绝。

后续按 [TEST_CASES.md](TEST_CASES.md) 从插件管理器开始补证据；客户端正常入口之外不使用认证绕过或修改执行文件。当前不能把上述四个游戏内项目标为通过。

## 连续复核后的目标状态

2026-11-02，包含首次执行和两次自动续查，实机控制运行时连续三轮因同一沙箱初始化错误无法启动。最后一次进程检查仍未发现 `JX3ClientX64.exe` 或 `JX3Client.exe`；日志目录只有此前的空 `LastShader.report`，没有新的实机证据。

目标标记为 **blocked（阻塞，未完成）**。已完成的设计、离线验证与默认禁用探针保留；未把管理器识别、游戏入口执行、快捷键可见性或真实 down/up 回调标为通过。恢复需要应用控制环境修复，或用户通过正常客户端提供管理器/调试/按键的实际结果。此阻塞不是客户端认证拒绝的结论。
