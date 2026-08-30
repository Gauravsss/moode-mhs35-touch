#!/bin/bash
set -e
echo "Installing MHS35 touch overlay..."
grep -qxF 'dtparam=spi=on' /boot/firmware/config.txt || echo 'dtparam=spi=on' | sudo tee -a /boot/firmware/config.txt
grep -qxF 'dtoverlay=mhs35,rotate=90' /boot/firmware/config.txt || echo 'dtoverlay=mhs35,rotate=90' | sudo tee -a /boot/firmware/config.txt
sudo cp udev/99-mhs-fb.rules /etc/udev/rules.d/99-mhs-fb.rules
sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp xorg/99-fbdev.conf /etc/X11/xorg.conf.d/99-fbdev.conf
sudo cp xorg/40-touchscreen.conf /etc/X11/xorg.conf.d/40-touchscreen.conf
sudo mkdir -p /etc/systemd/system/localdisplay.service.d
sudo cp systemd/override.conf /etc/systemd/system/localdisplay.service.d/override.conf
sudo sed -i 's/--window-size="\$SCREEN_RES"/--window-size="480,320"/' ~/.xinitrc
sudo udevadm control --reload-rules
sudo systemctl daemon-reload
sudo systemctl enable localdisplay
echo "Done. Reboot to apply: sudo reboot"