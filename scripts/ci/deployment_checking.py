import os
import subprocess
from importlib.metadata import PackageNotFoundError, version

_RELEASE_TYPE: str = "python-package"
_PyPI_LIB_NAME: str = os.getenv("PyPI_LIBRARY_NAME")
_SRC_LIB_NAME: str = os.getenv("LIBRARY_SOURCE_CODE_PATH")
_DEFAULT_VERSION: str = os.getenv("DEFAULT_VERSION") or "0.0.0"
_SOFTWARE_VERSION_FORMAT: str = "general-3"
# NOTE: If you're developing or testing something, you could turn this *dry run mode* as *true*
_DRY_RUN_MODE: str = "false"


def get_lib_ver() -> str:
    try:
        return version(_PyPI_LIB_NAME)
    except PackageNotFoundError:
        # Doesn't have the Python package
        return _DEFAULT_VERSION


def get_current_lib_ver() -> str:
    cmd_running_result: subprocess.CompletedProcess = subprocess.run(
        f'bash ./scripts/ci/generate-software-version.sh -r "{_RELEASE_TYPE}" -p "{_SRC_LIB_NAME}" -v "{_SOFTWARE_VERSION_FORMAT}" -d "{_DRY_RUN_MODE}"',
        shell=True,
        capture_output=True,
    )
    return str(cmd_running_result.stdout.decode("utf-8")).strip()


def run() -> None:
    release_latest_ver = get_lib_ver()
    current_ver = get_current_lib_ver()
    print(f"[INFO] The latest release version: {release_latest_ver}")
    print(f"[INFO] Current version of project: {current_ver}")
    if release_latest_ver != current_ver and _DRY_RUN_MODE == "false":
        # The version is not same with latest release version in PyPI, it has update. Deploy the Python package to PyPI.
        print("[INFO] VERSION UPDATE")
    else:
        # Don't have any version update. Won't deploy.
        print("[INFO] NO VERSION UPDATE")


if __name__ == "__main__":
    run()
