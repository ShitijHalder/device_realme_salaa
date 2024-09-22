#!/bin/bash

# Menu options
menu_option=""

while [[ "$menu_option" != "1" && "$menu_option" != "2" ]]; do
  echo "Select build type:"
  echo "  1) Vanilla"
  echo "  2) GApps"
  read -r menu_option

  if [[ "$menu_option" != "1" && "$menu_option" != "2" ]]; then
    echo "Invalid choice. Please select 1 for Vanilla or 2 for GApps."
  fi
done

# Process user choice
case $menu_option in
  1)
    # Check if lines already exist (modify pattern for exact match)
    if grep -qE '^BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE\s+:=.*' device/realme/salaa/BoardConfig.mk && \
       grep -qE '^BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE\s+:=.*' device/realme/salaa/BoardConfig.mk && \
       grep -qE '^BOARD_SYSTEM_EXTIMAGE_PARTITION_RESERVED_SIZE\s+:=.*' device/realme/salaa/BoardConfig.mk; then
      echo "Lines already present in BoardConfig.mk, skipping edit."
    else
      # Edit BoardConfig.mk (Vanilla)
      # Explicit path to BoardConfig.mk
      boardconfig_file="device/realme/salaa/BoardConfig.mk"

      if [[ ! -f "$boardconfig_file" ]]; then
        echo "Error: BoardConfig.mk not found at $boardconfig_file."
        exit 1
      fi

      # Insert lines at line 83 using awk (more robust for potential leading/trailing whitespace)
      awk 'NR==83 {print; print "BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 1073741824\nBOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 1073741824\nBOARD_SYSTEM_EXTIMAGE_PARTITION_RESERVED_SIZE := 536870912"} 1' "$boardconfig_file" > /tmp/edited_boardconfig.mk && mv /tmp/edited_boardconfig.mk "$boardconfig_file"
      echo "BoardConfig.mk edited for Vanilla build."
    fi
    ;;
  2)
    echo "No changes required for GApps build."
    ;;
  *)
    echo "Unexpected error occurred."
    ;;
esac



# Cloning required repositories for making rum:

# Kernel and Vendor Source:
git clone https://github.com/ShitijHalder/kernel_realme_salaa kernel/realme/salaa
git clone https://github.com/ShitijHalder/vendor_realme_salaa vendor/realme/salaa

# Hardware of Mediatek and Oplus:
git clone https://github.com/ShitijHalder/android_hardware_mediatek hardware/mediatek
git clone https://github.com/ShiChiyooo/platform_hardware_oplus hardware/oplus

# Confirmation prompt for both repositories
read -p "Keep the existing sauce or get a freshly cooked one for both Mediatek & Lineage SEPolicy? [y/N]: " confirm

if [[ $confirm =~ ^[Yy]$ ]]; then
    # Mediatek SEPolicy VNDR:
    if [ -d "device/mediatek/sepolicy_vndr" ]; then
        rm -rf device/mediatek/sepolicy_vndr
    fi
    git clone https://github.com/ShitijHalder/android_device_mediatek_sepolicy_vndr device/mediatek/sepolicy_vndr

    # Lineage SEPolicy:
    if [ -d "device/lineage/sepolicy" ]; then
        rm -rf device/lineage/sepolicy
    fi
    git clone https://github.com/LineageOS/android_device_lineage_sepolicy device/lineage/sepolicy
else
    echo "Skipping Mediatek & Lineage SEPolicy clones."
fi


# Basic Call Recorder (BCR):
git clone https://github.com/kenway214/vendor_bcr.git vendor/bcr

# Custom KeyGen
curl -O https://raw.githubusercontent.com/ShitijHalder/Key-Gen-signed-script/main/generate_all_keys.sh
chmod +x generate_all_keys.sh
./generate_all_keys.sh

# Make the build faster using ccache
export USE_CCACHE=1
export CCACHE_COMPRESS=1
export CCACHE_DIR=~/ccache
export CCACHE_MAXSIZE=50G

# Disable and stop systemd-oomd service.
systemctl disable --now systemd-oomd
