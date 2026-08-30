#!/bin/bash
set -e

echo "=== Step 0: Ensure git is installed ==="
if ! command -v git >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y git
fi

echo "=== Step 0b: Install evtest (for touch verification) ==="
sudo apt install -y evtest

echo "=== Step 1: Enable SPI ==="
sudo raspi-config nonint do_spi 0

echo "=== Step 2: Get MHS35 overlay ==="
if [ ! -d ~/LCD-show ]; then
    git clone https://github.com/goodtft/LCD-show.git ~/LCD-show
fi
sudo cp ~/LCD-show/usr/mhs35-overlay.dtb /boot/firmware/overlays/mhs35.dtbo

echo "=== Step 3: Update config.txt ==="
grep -qxF 'dtparam=spi=on' /boot/firmware/config.txt || echo 'dtparam=spi=on' | sudo tee -a /boot/firmware/config.txt
grep -qxF 'dtoverlay=mhs35,rotate=90' /boot/firmware/config.txt || echo 'dtoverlay=mhs35,rotate=90' | sudo tee -a /boot/firmware/config.txt

echo "=== Step 4: udev rule for stable framebuffer symlink ==="
sudo cp udev/99-mhs-fb.rules /etc/udev/rules.d/99-mhs-fb.rules

echo "=== Step 5: Xorg configs ==="
sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp xorg/99-fbdev.conf /etc/X11/xorg.conf.d/99-fbdev.conf
sudo cp xorg/40-touchscreen.conf /etc/X11/xorg.conf.d/40-touchscreen.conf

echo "=== Step 6: systemd override for boot race condition ==="
sudo mkdir -p /etc/systemd/system/localdisplay.service.d
sudo cp systemd/override.conf /etc/systemd/system/localdisplay.service.d/override.conf

echo "=== Step 7: Fix chromium window size in xinitrc ==="
sudo sed -i 's/--window-size="\$SCREEN_RES"/--window-size="480,320"/' ~/.xinitrc

echo "=== Step 8: Reload and enable services ==="
sudo udevadm control --reload-rules
sudo systemctl daemon-reload
sudo systemctl enable localdisplay

echo "=== Done. Reboot now: sudo reboot ==="