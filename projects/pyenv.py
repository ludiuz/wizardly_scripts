#!/usr/bin/env python

import os
import sys
import subprocess
import shutil
from pathlib import Path

def main(args):
    python_version = f"{sys.version_info.major}.{sys.version_info.minor}"
    install = "--install" in args
    create_env = any(a.startswith("--create-env") for a in args)

    if "--help" in args:
        print("Usage: setup.py [--install] [--create-env=x.x]")
        print("Options:")
        print("  --install         Install required packages")
        print("  --create-env=x.x  Create virtual environment with specified Python version")
        print("  --help            Show help message")
        sys.exit(0)

    if create_env:
        specified_version = next((a[12:] for a in args if a.startswith("--create-env=")), None)
        if specified_version:
            python_version = specified_version

        if Path("env").exists():
            choice = input("Virtual environment already exists. Do you want to delete it and create a new one? (y/n) ")
            if choice.lower() == 'y':
                shutil.rmtree("env")
            else:
                print("Aborting...")
                sys.exit(1)

        print(f"Creating virtual environment with Python {python_version}...")

        try:
            subprocess.run([f"python{python_version}", "-m", "venv", "env"], check=True)
        except FileNotFoundError:
            print(f"Python {python_version} is not available on the system. Please install it or specify a different version.")
            sys.exit(1)

        if Path(".gitignore").exists():
            with open(".gitignore", "a+") as f:
                f.seek(0)
                if "env" not in f.read():
                    f.write("\nenv\n")
                    print("Added 'env' to .gitignore")
                else:
                    print("'env' is already in .gitignore")
        else:
            print(".gitignore not found in the current directory")

        install = True

    if not Path("env").exists():
        print("Virtual environment not found. Run 'python setup.py --create-env=x.x' to create one.")
        sys.exit(1)

    if install:
        activate_script = "env/bin/activate" if os.name != "nt" else "env\\Scripts\\activate"

        if not Path("requirements.txt").exists():
            print("requirements.txt not found. Please provide a requirements.txt file.")
            sys.exit(1)

        subprocess.run([sys.executable, "-m", "pip", "install", "-r", "requirements.txt"], check=True)
        subprocess.run([sys.executable, "-m", "pip", "install", "--upgrade", "pip"], check=True)

if __name__ == "__main__":
    main(sys.argv[1:])
