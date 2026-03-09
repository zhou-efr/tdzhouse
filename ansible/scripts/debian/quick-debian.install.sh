# Packages update
apt-get update -y
apt-get upgrade -y

# Setup zsh
apt-get -y install git zsh curl sudo

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

rm ~/.zshrc
wget https://raw.githubusercontent.com/zhou-efr/PimpMyParrot/refs/heads/main/.zshrc -P ~

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

mkdir -p ~/.config/gtk-3.0
wget https://raw.githubusercontent.com/zhou-efr/PimpMyParrot/main/gtk.css -P ~/.config/gtk-3.0
