#
# Copyright (C) 2024 The AOSP - Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/non_ab_device.mk)

# Inherit from device makefile.
$(call inherit-product, device/realme/salaa/device.mk)
PRODUCT_NAME := derp_salaa
PRODUCT_DEVICE := salaa
PRODUCT_MANUFACTURER := realme
PRODUCT_BRAND := realme
PRODUCT_MODEL := realme 7/Narzo 20 Pro/Narzo 30 4G

# Inherit some common derp stuff
$(call inherit-product, vendor/derp/config/common_full_phone.mk)

DERP_BUILDTYPE := Unofficial
USE_LEGACY_BOOTANIMATION := true
TARGET_INCLUDE_LIVE_WALLPAPERS := true

# Bootanimation Resolution
TARGET_BOOT_ANIMATION_RES := 1080

PRODUCT_GMS_CLIENTID_BASE := android-realme

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=RMX2156L1 \
    PRODUCT_NAME=RMX2156 \
    PRIVATE_BUILD_DESC="sys_mssi_64_cn_armv82-user 12 SP1A.210812.016 1689241820072 release-keys"

BUILD_FINGERPRINT := realme/RMX2156/RMX2156L1:12/SP1A.210812.016/Q.1579e30_414da:user/release-keys
