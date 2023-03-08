#!/bin/bash

PWD_=$(pwd)
PACKAGES_UNIVERSAL="git vim nano"

echo "create main folders (ignore if they already exits...)"
mkdir ~/dependencies
mkdir ~/repositories
mkdir ~/scripts

# Detect package manager and set variables accordingly
if [ -n "$(command -v apt)" ]; then
    PM="apt"
    INSTALL_CMD="install -y"
    PACKAGES_PM="micro"
elif [ -n "$(command -v dnf)" ]; then
    PM="dnf"
    INSTALL_CMD="install -y"
    PACKAGES_PM="micro"
elif [ -n "$(command -v zypper)" ]; then
    PM="zypper"
    INSTALL_CMD="install -y"
    PACKAGES_PM="micro-editor MozillaFirefox"
elif [ -n "$(command -v pacman)" ]; then
    PM="pacman"
    INSTALL_CMD="-S --noconfirm"
    PACKAGES_PM="micro"
else
    echo "Unable to detect package manager."
    exit 1
fi

# Install Python using the appropriate package manager
sudo ${PM} ${INSTALL_CMD} python3 python3-pip

echo "Do you want to proceed and install basic packages and tools? (y/n)"
read answer

if [[ $answer == "y" ]]; then
  echo "Installing packages and tools..."

  PACKAGES_UNIVERSAL+=" ${PACKAGES_PM}"

  echo "List: $PACKAGES_UNIVERSAL"
  sleep 1
  
  # Install packages and tools here using the package manager variable
  sudo ${PM} update -y
  for package in $PACKAGES_UNIVERSAL; do
    sudo ${PM} ${INSTALL_CMD} -y $package
  done
fi

read -p "Do you want to set up your terminal? (y/n): " response
if [[ "$response" =~ ^[Yy]$ ]]; then
	chmod +x ./setupTerminal.sh
	./setupTerminal.sh
fi

echo "Do you wish to do basic setup of GIT? (y/n): "
read git-answer

if [[ "$git-answer" =~ ^[Yy]$ ]]; then
	chmod +x ./setupGit.sh
	./setupGit.sh
fi
