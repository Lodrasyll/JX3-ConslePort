"""Read client layout/version; optionally stage only this disabled probe."""
from __future__ import annotations

import argparse
import configparser
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parents[1]


def digest(file: Path) -> str:
    return hashlib.sha256(file.read_bytes()).hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("client_root", type=Path)
    parser.add_argument("--stage", action="store_true", help="Copy info.ini/Main.lua with default=0; refuse existing target")
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    client = args.client_root.resolve(strict=True)
    branch = client / "bin/zhcn_hd"
    interface = branch / "interface"
    if not interface.is_dir():
        parser.error("Expected existing bin/zhcn_hd/interface; no directory guessing")
    config = configparser.ConfigParser(interpolation=None, comment_prefixes=("#", ";"))
    config.optionxform = str
    version_file = branch / "version.cfg"
    config.read_string(version_file.read_bytes().decode("gb18030"))
    version = dict(config["Version"])
    report = {
        "inspected_at_utc": datetime.now(timezone.utc).isoformat(),
        "client_root": str(client),
        "branch": str(branch),
        "interface": str(interface),
        "interface_exists": True,
        "version_cfg": version,
        "version_cfg_sha256": digest(version_file),
        "root_entries": sorted(p.name for p in client.iterdir()),
        "branch_directories": sorted(p.name for p in branch.iterdir() if p.is_dir()),
        "interface_directories_before": sorted(p.name for p in interface.iterdir() if p.is_dir()),
        "privacy_scope": "No userdata, screenshots, chat logs, or addon saved data contents read",
        "installed_manifest_evidence": [],
        "live_client_verified": False,
        "official_test_permission": "unconfirmed",
    }
    executable = branch / "bin64/JX3ClientX64.exe"
    if executable.is_file():
        stat = executable.stat()
        report["client_executable"] = {
            "path": str(executable), "size": stat.st_size,
            "modified_at_utc": datetime.fromtimestamp(stat.st_mtime, timezone.utc).isoformat(),
            "sha256": digest(executable),
        }
    for relative in ("MY/MY_!Base/info.ini", "MY/MY_Target/info.ini"):
        file = interface / relative
        if file.is_file():
            # Preserve only technical manifest fields, not user saved data.
            text = file.read_bytes().decode("gb18030", errors="replace")
            fields = [line for line in text.splitlines() if line.startswith(("[", "package=", "dependence=", "version=", "default=", "lua_"))]
            report["installed_manifest_evidence"].append({"path": relative, "fields": fields, "sha256": digest(file)})
    if args.stage:
        destination = interface / "JX3CP_P0"
        if destination.exists():
            parser.error("JX3CP_P0 already exists; inspect before replacing any file")
        # Resolve before writing; reject junctions that escape the requested root.
        destination.resolve().relative_to(client)
        source = ROOT / "addon/JX3CP_P0"
        manifest = configparser.ConfigParser()
        manifest.read(source / "info.ini", encoding="ascii")
        assert manifest["JX3CP_P0"]["default"] == "0"
        destination.mkdir()
        files = []
        for name in ("info.ini", "Main.lua"):
            shutil.copy2(source / name, destination / name)
            assert digest(source / name) == digest(destination / name)
            files.append({"name": name, "sha256": digest(destination / name)})
        report["staged_probe"] = {"path": str(destination), "default_enabled": False, "files": files, "existing_files_overwritten": False}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({key: report[key] for key in ("branch", "interface", "version_cfg", "live_client_verified")}, ensure_ascii=False, indent=2))
    if args.stage:
        print("Probe staged disabled; not proof of manager discovery, certification, or execution")


if __name__ == "__main__":
    main()
