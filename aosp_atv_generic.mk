#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from Android TV base products
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Android TV specific product configuration
PRODUCT_IS_ATV := true

# Inherit from generic device
$(call inherit-product, device/amlogic/ohm/device.mk)

PRODUCT_DEVICE := generic
PRODUCT_NAME := aosp_atv_generic
PRODUCT_BRAND := Android
PRODUCT_MODEL := AOSP on atv_generic
PRODUCT_MANUFACTURER := Amlogic

# Android TV specific client ID
PRODUCT_GMS_CLIENTID_BASE := android-droid-tv

# Override build properties for AOSP
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="aosp_atv_generic-userdebug 12 SC eng.android.$(shell date +%Y%m%d.%H%M%S) test-keys"

BUILD_FINGERPRINT := Android/aosp_atv_generic/generic:12/SC/$(shell date +%Y%m%d):userdebug/test-keys

# Include Android TV apps and features
PRODUCT_PACKAGES += \
    TvSettings \
    TvSampleLeanbackLauncher

# Android TV permissions and features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.leanback.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.leanback.xml \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hdmi.cec.xml \
    frameworks/native/data/etc/android.software.live_tv.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.live_tv.xml

# Android TV specific properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=320 \
    ro.config.low_ram=false