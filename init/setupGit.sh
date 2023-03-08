#!/bin/bash

# username
read -p "Set up your username?: " username
echo "git config --global user.name '$username'"
git config --global user.name '$username'

# email
read -p "Set up your email?: " email
echo "git config --global user.email '$email'"
git config --global user.email '$email'

echo "Default editor is nano, do you wish to change it? (y/n)"
read answ

if [[ "$answ" =~ ^[Yy]$ ]]; then
	echo "What is editor of your choice?: "
	read editor
	git config --global core.editor "$editor"
fi

echo "Now generating SSH key for websites like github..."
ssh-keygen -t rsa -b 4096 -C '$email'
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

echo ""
echo "Copy this SHH key:"
cat ~/.ssh/id_rsa
echo ""

echo "Short describtion of how to set up SSH Key:"
echo "	1. Go to GitHub and click on your profile photo in the top-right corner of any page."
echo "	2. Click on Settings and then click on SSH and GPG keys in the left sidebar."
echo "	3. Click on New SSH key, give your key a title and paste your public SSH key into the Key field."
echo "	4. Click on Add SSH key."
echo ""

echo "After you set up SSH key, run this command to check connection:"
echo "	ssh -T git@github.com"
echo ""

echo "You should get this result:"
echo "	Hi $username! You've successfully authenticated, but GitHub does not provide shell access."
