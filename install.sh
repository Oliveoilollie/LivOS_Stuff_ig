#!/bin/bash

HALF_HOME=$(pwd)

apt install -y dialog

BLOCK_NVIDIA=$(dialog --menu "Would you like to install nvidia drivers?: " 10 30 3 \
  1 "Yes" \
  2 "No" \ 
  2>&1 >/dev/tty)

source config.cfg

# people will hate me for this lmao
if [ $BLOCK_NVIDIA == "No" ]; then
  echo "skipping nvidia detection"
else
  apt install -y nvidia-detect 
  driver=$(nvidia-detect 2>/dev/null | grep "It is recommended to install the" | awk '{print $6}')
  if [ -n "$driver"]; then
    echo "we are installing: $driver"
    apt install -y $driver
  else
    apt remove -y nvidia-detect
    dialog --title "Notice" --msgbox "Nvidia Card not detected, you will have to install the nvidia drivers manually or troubleshoot" 7 40
  fi
fi

# install dependencys
for pkg in $DEPENDENCYS; do
  about=$(apt show $pkg | grep Description: &> /dev/null)
  dialog --title "installing: $pkg" --msgbox "$about" 7 40 &
  apt install -y pkg && killall dialog # dirty trick
done

# check for configs
CONFIGS=$(dialog --menu "Would you like to install my custom config files?, all older configs will have a .old extention: " 10 30 3 \
  1 "Yes" \
  2 "No" \ 
  2>&1 >/dev/tty)

# actually check the user and like move the configs
if [ $CONFIGS == "No"]; then
  echo "not messing with configs"
else
  user=$(dialog --stdout --inputbox "Enter your Users name (a new one will be created if its invalid) :" 8 40)
  if id "$user" &>/dev/null; then
    cd $user/.config
    new_config=$(ls $HALF_HOME/configs)
    for f in $new_config; do
      mv "$f" "$new_config.old"
      cp "$new_config/configs/$f" "$new_config"
    done
  else 
    new_config=$(ls $HALF_HOME/configs)
    usermod -aG sudo "$user"
    cd "$user/.config"
    for f in $new_config; do
      cp "$new_config/configs/$f" "$new_config"
    done
  fi

PROGRAMS=$(dialog --menu "Would you like to install nice small and minimal extra programs?" 10 30 3 \
  1 "Yes" \
  2 "No" \ 
  2>&1 >/dev/tty)

if [ $PROGRAMS == "Yes" ]; then
    for pkg in $SOFTWARE; do
      about=$(apt show $pkg | grep Description: &> /dev/null)
      dialog --title "installing: $pkg" --msgbox "$about" 7 40 &
      apt install -y pkg && killall dialog # dirty trick
    done
fi

cd $HALF_HOME

cp -p SUCKLESS $user/.config/suckless

for dir in SUCKLESS; do
  if [ -d "$dir" ]; then
    dialog --title "installing: $dir" --msgbox "Please wait" 7 40 &
    (cd "$dir" && make) || { echo "Make failed in $dir"; exit 1; }
  fi
done

dialog --title "we have finished installing!" --msgbox "thank you" 7 40 &


  













