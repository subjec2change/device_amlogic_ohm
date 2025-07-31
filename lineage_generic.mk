#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from generic device
$(call inherit-product, device/android/generic/device.mk)

PRODUCT_DEVICE := generic
PRODUCT_NAME := lineage_generic
PRODUCT_BRAND := Android
PRODUCT_MODEL := atv_generic
PRODUCT_MANUFACTURER := android

PRODUCT_GMS_CLIENTID_BASE := android-droid-tv

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="ohm_gtv-userdebug 12 SC eng.bin.ya.20230223.173800 test-keys"

BUILD_FINGERPRINT := Amlogic/ohm_gtv/ohm:12/SC/bin.yang02231735:userdebug/test-keys
