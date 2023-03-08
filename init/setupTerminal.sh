#!/bin/bash

echo "**Keep in mind, if you use WSL you need to setup NERD font for PowerShell.**"
sleep 2
echo ""

# Download Nerd font
mkdir fonts
FONT="DejaVuSansMono"
echo "Downloading NERD font $FONT..."
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/$FONT.zip
unzip ./$FONT.zip -d ./fonts/ 
cp ./fonts/*.ttf ~/.local/share/fonts/
rm $FONT.zip
rm -r ./fonts/

# Add Starship shell prompt
echo ""
echo "Installing Starship shell prompt"
curl -sS https://starship.rs/install.sh | sh
if grep -qxF 'eval "$(starship init bash)"' ~/.bashrc; then
  echo " "
else
  echo "The line 'eval \"\$(starship init bash)\"' is not present in ~/.bashrc."
  echo '# Shell prompt' >> ~/.bashrc
  echo 'eval "$(starship init bash)"' >> ~/.bashrc
  echo ' ' >> ~/.bashrc
fi
