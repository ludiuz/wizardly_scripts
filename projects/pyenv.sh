#!/bin/bash

# Default version of Python
PYTHON_VERSION=$(python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
INSTALL=false
SET_ENV=false

# Parse command line arguments
for arg in "$@"
do
    case $arg in
        --help)
            echo "Usage: ./setup.sh [--install] [--create-env=x.x]"
            echo "Options:"
            echo "  --install         Install required packages"
            echo "  --create-env=x.x  Create virtual environment with specified Python version"
            echo "  --help            Show help message"
            exit 0
            ;;
        --install)
            INSTALL=true
            ;;
        --create-env)
            SET_ENV=true
            ;;
        --create-env=*)
            SET_ENV=true
            PYTHON_VERSION=${arg#--create-env=}
            ;;
        *)
            echo "Unknown option: $arg"
            exit 1
            ;;
    esac
done

# Check if virtual environment exists, and create one if requested
if [[ $SET_ENV == true ]]; then
    # Check if the specified Python version is available on the system
    if ! command -v python$PYTHON_VERSION &> /dev/null; then
        echo "Python $PYTHON_VERSION is not available on the system. Please install it or specify a different version."
        exit 1
    fi
    
    if [ -d "env" ]; then
        read -p "Virtual environment already exists. Do you want to delete it and create a new one? (y/n) " choice
        case "$choice" in
            y|Y ) echo "Deleting virtual environment..."; rm -rf env;;
            n|N ) echo "Aborting..."; exit 1;;
            * ) echo "Invalid option"; exit 1;;
        esac
    fi
    echo "Creating virtual environment with Python $PYTHON_VERSION..."
    python$PYTHON_VERSION -m venv env
    INSTALL=true

    # Check if .gitignore exists, and append 'env' to it if so
    if [ -f ".gitignore" ]; then
        if ! grep -q "^env$" .gitignore; then
            echo "env" >> .gitignore
            echo "Added 'env' to .gitignore"
        else
            echo "'env' is already in .gitignore"
        fi
    else
        echo ".gitignore not found in the current directory"
    fi
else
    if [ ! -d "env" ]; then
        echo "Virtual environment not found. Run './setup.sh --create-env=x.x' to create one."
        exit 1
    fi
fi

# Activate virtual environment
source env/bin/activate

# Install requirements if requested
if [ "$INSTALL" = true ]; then
    if [ -f "requirements.txt" ]; then
        python -m pip install -r requirements.txt
        pip install --upgrade pip
    else
        echo "requirements.txt not found. Please provide a requirements.txt file."
        exit 1
    fi
fi

exec $SHELL
