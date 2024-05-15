"""
This script provides functions to check for and update the latest versions of Python packages listed in a
requirements file. It includes the following functions:
- get_latest_version(package_name, current_version): Retrieves the latest version of a package from PyPI.
- update_requirements_file(file_path): Updates the requirements file with the latest package versions.
- main(): Updates all requirements files in the 'requirements' directory.

To use this script, simply run it, and it will update all requirements files in the 'requirements' directory
with the latest package versions.
"""

import re
import subprocess
from pathlib import Path


def get_latest_version(package_name, current_version):
    """
    Get the latest version of a package.

    Args:
    package_name (str): The name of the package.
    current_version (str): The current version of the package.

    Returns:
    str: The latest version of the package if it's different from the current version, otherwise None.
    """
    try:
        available_version = (
            subprocess.check_output(["pip", "install", "--upgrade", package_name])
            .decode("utf-8")
            .split("(")[1]
            .split(")")[0]
        )
        if current_version != available_version:
            return available_version
        else:
            return None
    except subprocess.CalledProcessError:
        return None


def update_requirements_file(file_path):
    """
    Update the requirements file with the latest package versions.

    Args:
    file_path (str): The path to the requirements file.
    """
    with open(file_path, "r") as file:
        lines = file.readlines()

        updated_lines = []

        pattern = r"^(?P<package_name>[\w-]+)==(?P<current_version>[\d.]+(?:\s\w+)?)\s*#\s*(?P<description>.*)$"

        for line in lines:

            match = re.match(pattern, line)

            if match:
                package_name = match.group("package_name")
                current_version = match.group("current_version")
                description = match.group("description")
            else:
                updated_lines.append(line)
                continue

            package_name, current_version = re.search(r"^(.*?)==(.*)", line).groups()
            latest_version = get_latest_version(package_name, current_version)
            if latest_version:
                updated_lines.append(
                    f"{package_name}=={latest_version} # {description}\n"
                )
            else:
                updated_lines.append(line)

    with open(file_path, "w") as file:
        file.writelines(updated_lines)


def main():
    """
    Update all requirements files in the 'requirements' directory.
    """
    requirements_dir = Path(__file__).resolve().parent.parent / "requirements"
    for file_name in requirements_dir.glob("**/*.txt"):
        file_path = requirements_dir / file_name
        update_requirements_file(file_path)


if __name__ == "__main__":
    main()
