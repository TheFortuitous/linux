#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Zsh
if ! command_exists zsh; then
    echo "Installing zsh..."
    sudo apt update && sudo apt install -y zsh
else
    echo "Zsh is already installed."
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# Install Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo "Powerlevel10k is already installed."
fi

# Set Powerlevel10k as the theme in .zshrc
echo "Setting Powerlevel10k as the theme in .zshrc..."
sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Install zsh-autosuggestions plugin
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions is already installed."
fi

# Add zsh-autosuggestions to plugins in .zshrc if not already present
if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
    echo "Adding zsh-autosuggestions to plugins in .zshrc..."
    sed -i 's/plugins=(/&zsh-autosuggestions /' ~/.zshrc
fi

# Download the Powerlevel10k configuration file (.p10k.zsh) from the given GitHub URL
echo "Downloading Powerlevel10k configuration..."
curl -o ~/.p10k.zsh https://raw.githubusercontent.com/TheFortuitous/linux/master/.p10k.zsh

# Ensure the .p10k.zsh is sourced in .zshrc
if ! grep -q "source ~/.p10k.zsh" ~/.zshrc; then
    echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
fi

# Reload Zsh to apply the changes
echo "Reloading zsh..."
exec zsh
