# JX3 ConsolePort P0

剑网3 PC 旗舰版的手柄交互预研项目。核心方向：外部/原生输入负责移动与手动快捷键，Lua 负责 RT/LT 两组共 16 槽 HUD、配置与提示。目前实现的是加载及 API 存在性探针，尚无完整手柄配置和 HUD。

## 本轮状态（2026-11-02）

- 已通读全部初始项目文件及三份设计文档，见 [项目结构与审阅](docs/PROJECT_OVERVIEW.md)。
- 已确认本机插件目录：`E:\SeasunGame\Game\JX3\bin\zhcn_hd\interface`。
- 本机 `version.cfg` 声明 `1-6-0-10024` / `hd`；游戏画面完整版本待核对。
- 探针 `0.1.1-probe` 已通过 Lua 5.1/5.4 语法、冒烟及各 13 项回归测试。
- 已暂存到实际 Interface 的独立 `JX3CP_P0`，`default=0`，未覆盖其他插件。
- 官方测试/认证许可未确认；用户要求继续普通检查。管理器识别、实机入口日志、Debug Ping 可见性及真实 down/up 仍未验证，当前应用控制工具启动失败。

详细结果：[首轮验证报告](docs/LOAD_TEST_REPORT.md)；后续执行：[核心功能与实施计划](docs/IMPLEMENTATION_PLAN.md)、[任务清单](docs/TASKS.md)、[实机步骤](docs/TEST_CASES.md)。

## 离线检查

在项目根目录执行，依赖只安装到项目 `.tools/`：

```powershell
python -m pip install --target .tools/python -r requirements-dev.txt --only-binary=:all: --no-deps --index-url https://pypi.org/simple
python tests/run_offline.py --report docs/evidence/offline-2026-11-02.json
```

已有独立 Lua 解释器时，也可以运行 `lua tests/offline_smoke.lua` 和 `lua tests/offline_regression.lua`。离线模拟通过不代表游戏中的 API、白名单、输入时序或 UI 可用。

## 客户端目录检查

```powershell
python tools/inspect_client.py 'E:\SeasunGame\Game\JX3' --report docs/evidence/client-recheck.json
```

首次暂存可加 `--stage`，只复制 `info.ini` 和 `Main.lua`，默认禁用；如目标目录存在则拒绝覆盖。本机已经暂存，复查时不要加该参数。

插件使用历史 `info.ini` / `lua_0` 格式，`version=1.0` 是待客户端验证的兼容字段；产品版本见 `M.VERSION`。不要把文件复制成功或注册函数调用成功视为管理器识别。实机流程见 [TEST_CASES.md](docs/TEST_CASES.md)；如客户端拒绝认证，记录提示，不修改认证或安全机制。

## 文档索引

- `design docs/`：技术、实施控制、核心设计三份原始基线。
- [ENVIRONMENT.md](docs/ENVIRONMENT.md)：本机环境与版本证据。
- [POLICY_CHECK.md](docs/POLICY_CHECK.md)：官方渠道查询与未确认项。
- [API_MATRIX.md](docs/API_MATRIX.md)：候选接口、来源与验证状态。
- [INPUT_PROFILE.md](docs/INPUT_PROFILE.md)：候选手柄键位，尚非可导入 Steam Input 文件。
- `docs/evidence/`：客户端与离线测试 JSON，含文件 SHA-256。

技术参考：[MY Hotkey](https://github.com/tinymins/JX3MY/blob/master/MY_%21Base/src/lib/System.Hotkey.lua)、[EasyUI](https://github.com/kiethen/EasyUI/blob/master/EasyTestAddon.lua)、[Steam legacy bindings](https://partner.steamgames.com/doc/features/steam_controller/legacy_mode)。公开源码与工具文档不构成当前客户端许可证明。
