#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/lineage_generic.mk \
    $(LOCAL_DIR)/aosp_atv_generic.mk

COMMON_LUNCH_CHOICES := \
    lineage_generic-user \
    lineage_generic-userdebug \
    lineage_generic-eng \
    aosp_atv_generic-user \
    aosp_atv_generic-userdebug \
    aosp_atv_generic-eng
