# Cloning required repositories for making rum:

# Kernel and Vendor Source:
git clone https://github.com/ShitijHalder/kernel_realme_salaa kernel/realme/salaa
git clone https://github.com/ShitijHalder/vendor_realme_salaa vendor/realme/salaa

# Hardware of Mediatek and Oplus:
git clone https://github.com/ShitijHalder/android_hardware_mediatek hardware/mediatek
git clone https://github.com/ShiChiyooo/platform_hardware_oplus hardware/oplus

# Mediatek SEPolicy VNDR:
git clone https://github.com/ShitijHalder/android_device_mediatek_sepolicy_vndr device/mediatek/sepolicy_vndr

# Lineage SEPolicy:
git clone https://github.com/LineageOS/android_device_lineage_sepolicy device/lineage/sepolicy

# Basic Call Recorder (BCR):
git clone https://github.com/kenway214/vendor_bcr.git vendor/bcr

# Custom KeyGen
curl -O https://raw.githubusercontent.com/ShitijHalder/Key-Gen-signed-script/main/generate_all_keys.sh
chmod +x generate_all_keys.sh
./generate_all_keys.sh

# Make the build faster using ccache
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
ccache -M 50G
ccache -o compression=true

# Disable and stop systemd-oomd service.
systemctl disable --now systemd-oomd


