# 项目结构与设计审阅

审阅日期：2026-11-02（Asia/Shanghai）。已通读开始时的全部 10 个项目文件：README、3 份 design docs、3 份 docs、2 个插件文件、1 个测试文件。客户端按目录与相关配置检查；资源包、可执行文件和非文本插件不作源码通读。

## 当前工程

```text
addon/JX3CP_P0/
  info.ini                 插件发现/入口声明；默认禁用
  Main.lua                 API 存在性探测、入口日志、Debug Ping
design docs/
  ...01-技术方案.md        架构、候选 API、降级与边界
  ...02-实施计划与控制.md  S0–S6、验收、风险、任务模板
  ...03-核心设计与功能方案.md 产品体验、双扳机技能栏、后续功能
docs/
  API_MATRIX.md            候选接口及来源
  INPUT_PROFILE.md         手柄映射草案
  TASKS.md                 本轮状态及后续任务
tests/
  offline_smoke.lua        最小模拟加载/按下/抬起
  offline_regression.lua   13 项接口异常与初始化回归
  run_offline.py           Lua 5.1/5.4 语法和行为检查
tools/inspect_client.py    客户端只读检查、可选禁用探针暂存
requirements-dev.txt      固定离线运行依赖
```

现有产品代码只有入口探针；尚无真实游戏 UI、手柄接收器、技能 HUD、配置持久化或可导入 Steam Input 配置。`.tools/` 是项目隔离的离线依赖，不部署进游戏。`docs/evidence/` 保存机器可读证据。

## 客户端结构

实际根目录：`E:\SeasunGame\Game\JX3`。

| 路径 | 作用与本轮处理 |
|---|---|
| `bin/zhcn_hd` | 实际旗舰版分支 |
| `bin/zhcn_hd/interface` | 已存在的插件目录，含 MY 等目录 |
| `bin/zhcn_hd/bin64` | 客户端执行文件；记录元数据及 SHA-256 |
| `bin/zhcn_hd/version.cfg` | 本机声明版本、分支、AddOnVersion |
| `bin/zhcn_hd/config`、`ui`、`data` | 配置、界面和资源，不是本项目源码 |
| `Pakv4`、`PreUpdate`、`Temp` | 资源及更新内容，不参与插件构建 |
| `userdata`、`logs`、截图、插件保存数据 | 未读取内容；不需要账号/聊天数据来验证探针 |

本机 MY 的入口文件不是普通 Lua 文本，不能据此确认函数签名；未尝试解密、反编译或修改。安装目录存在只能证明文件布局，不能证明 JX3CP 已加载。

## 设计审阅结论

三份设计文档方向一致：原生输入负责操作，Lua 负责展示；MVP 为基础移动、镜头、跳跃及 RT/LT 共 16 槽。当前优先补齐验证证据，暂不扩展环形菜单、目标 HUD 和多门派自动配置。

需要消除的歧义：

1. 历史 `bin/zhcn` 示例不适用于本机，实际使用 `bin/zhcn_hd/interface`。
2. 技术文档示例 `version=0.1` 与当前 manifest `version=1.0` 不一致。保留与本机 MY 和 `Sword3.AddOnVersion=1.0` 相符的 `1.0` 候选值；它不是产品版本。当前产品版本由 `M.VERSION=0.1.1-probe` 表示，仍待管理器验证。
3. backlog 中“8 static slot”与设计的 16 槽不一致，统一为两组各 8 槽。
4. `MY.RegisterHotKey` 是第三方封装；公开源码中它最终调用全局 `Hotkey.AddBinding`。这改善了来源证据，仍不能证明当前白名单或运行行为。
5. 左右摇杆死区/镜头灵敏度属于外部映射工具。Lua Profile 只保存描述与 HUD 配置，不能假设可以修改 Steam Input。
6. API 存在、调用未抛错、管理器可见、回调正确是四种不同证据。离线测试不代表实机验收。

下一步以 [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md)、[TASKS.md](TASKS.md) 和 [LOAD_TEST_REPORT.md](LOAD_TEST_REPORT.md) 为当前执行状态；三份原始设计文档保留作为设计基线。
