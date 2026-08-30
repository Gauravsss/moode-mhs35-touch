# moOde MHS35 Touch Setup

Get a GoodTFT MHS-3.5inch SPI display (ILI9486 + XPT2046 touch) working as a
secondary local-display screen on moOde Audio 10 / Raspberry Pi 5, while
keeping HDMI as the primary display.

## Usage

sudo apt update && sudo apt install -y git
git clone https://github.com/Gauravsss/moode-mhs35-touch.git
cd moode-mhs35-touch
chmod +x install.sh
./install.sh
sudo reboot

## Verify after reboot

ls -l /dev/fb_mhs
systemctl status localdisplay
sudo evtest

## Hardware
- Raspberry Pi 5, 1GB RAM
- moOde Audio 10.3.3
- GoodTFT MHS-3.5inch SPI display (ILI9486 panel, XPT2046 touch controller)

## Re-running after updates

If you pull future changes to this repo:

git pull
chmod +x install.sh
./install.sh
sudo reboot

install.sh is idempotent — safe to re-run any time (it only appends
config.txt lines if missing, and overwrites config files with the repo's
version each time).