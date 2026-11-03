"""Compile Lua and run mocks on stock Lua versions; never opens the game."""
from __future__ import annotations

import argparse
import configparser
import hashlib
import importlib
import json
import os
from pathlib import Path
import re
import sys
from datetime import datetime
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / ".tools" / "python"))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--report", type=Path, help="Write JSON evidence")
    args = parser.parse_args()
    os.chdir(ROOT)
    report = {"kind": "offline_only", "live_client_verified": False, "runtimes": []}
    try:
        from lupa import __version__ as lupa_version
    except ImportError:
        parser.exit(2, "Install: python -m pip install --target .tools/python -r requirements-dev.txt\n")
    report["lupa_version"] = lupa_version
    config = configparser.ConfigParser(interpolation=None)
    manifest = ROOT / "addon/JX3CP_P0/info.ini"
    config.read(manifest, encoding="ascii")
    section = config["JX3CP_P0"]
    assert section["default"] == "0", "Probe must remain disabled by default"
    assert section["version"] == "1.0", "Historical addon compatibility field changed"
    assert section["lua_0"] == "Main.lua"
    report["manifest"] = {"version_field": section["version"], "default": section["default"]}
    source = (manifest.parent / "Main.lua").read_text(encoding="ascii")
    report["plugin_version"] = re.search(r'M.VERSION = "([^"]+)"', source).group(1)
    lua_files = sorted((ROOT / "addon").rglob("*.lua")) + sorted((ROOT / "tests").rglob("*.lua"))
    report["sha256"] = {
        p.relative_to(ROOT).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest()
        for p in [manifest, *lua_files, Path(__file__).resolve()]
    }
    for module in ("lua51", "lua54"):
        runtime_type = importlib.import_module("lupa." + module).LuaRuntime
        lua = runtime_type(unpack_returned_tuples=True)
        version = lua.eval("_VERSION")
        compile_only = lua.eval("function(code, name) local f, e = (loadstring or load)(code, name); assert(f, e); return true end")
        for file in lua_files:
            compile_only(file.read_text(encoding="utf-8"), "@" + file.relative_to(ROOT).as_posix())
        print(f"SYNTAX PASSED: {version} ({len(lua_files)} files)", flush=True)
        runtime_type().execute((ROOT / "tests/offline_smoke.lua").read_text(encoding="utf-8"))
        count = runtime_type().execute((ROOT / "tests/offline_regression.lua").read_text(encoding="utf-8"))
        report["runtimes"].append({"runtime": version, "syntax_files": len(lua_files), "smoke": "passed", "regression_cases": count, "result": "passed"})
    # Windows Python may not include IANA tzdata. A fixed UTC+8 is also correct here.
    try:
        timezone = ZoneInfo("Asia/Shanghai")
    except ZoneInfoNotFoundError:
        from datetime import timedelta, timezone as fixed_timezone
        timezone = fixed_timezone(timedelta(hours=8))
    report["tested_at"] = datetime.now(timezone).isoformat()
    report["result"] = "passed"
    if args.report:
        target = args.report.resolve()
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print("ALL OFFLINE CHECKS PASSED; live client remains unverified", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
