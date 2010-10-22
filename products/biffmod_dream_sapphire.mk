# Inherit AOSP device configuration for dream_sapphire.
$(call inherit-product, device/htc/dream_sapphire/full_dream_sapphire.mk)

# Inherit some common cyanogenmod & biffmod stuff
$(call inherit-product, vendor/biffmod/products/common.mk)

# Include GSM-only stuff
$(call inherit-product, vendor/biffmod/products/gsm.mk)

#
# Setup device specific product configuration.
#
PRODUCT_NAME := biffmod_dream_sapphire
PRODUCT_BRAND := google
PRODUCT_DEVICE := dream_sapphire
PRODUCT_MODEL := Dream/Sapphire
PRODUCT_MANUFACTURER := HTC
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_ID=FRG83 BUILD_DISPLAY_ID=FRG83 BUILD_FINGERPRINT=google/passion/passion/mahimahi:2.2/FRG83/60505:user/release-keys PRIVATE_BUILD_DESC="passion-user 2.2 FRG83 60505 release-keys"

#PRODUCT_SPECIFIC_DEFINES += TARGET_PRELINKER_MAP=$(TOP)/vendor/biffmod/prelink-linux-arm-ds.map

# Build kernel
ifdef EZTERRYS
	PRODUCT_SPECIFIC_DEFINES += TARGET_PREBUILT_KERNEL=
	PRODUCT_SPECIFIC_DEFINES += TARGET_KERNEL_DIR=kernel-ezterry
	PRODUCT_SPECIFIC_DEFINES += TARGET_KERNEL_CONFIG=$(TOP)/kernel-ezterry/config-32b-xtra
else
	PRODUCT_SPECIFIC_DEFINES += TARGET_PREBUILT_KERNEL=
	PRODUCT_SPECIFIC_DEFINES += TARGET_KERNEL_DIR=kernel-msm
	PRODUCT_SPECIFIC_DEFINES += TARGET_KERNEL_CONFIG=$(TOP)/vendor/biffmod/biffmod_msm_defconfig
endif

# Extra DS overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/biffmod/overlay/dream_sapphire

# Disable Compcache by default on D/S
PRODUCT_PROPERTY_OVERRIDES += \
    ro.compcache.default=0

# Enable Swap by default on D/S
PRODUCT_PROPERTY_OVERRIDES += \
    ro.swap.default=1

# Set ModVersion
ifdef BIFFMOD_RELEASE
    PRODUCT_PROPERTY_OVERRIDES += \
       ro.modversion=BiffMod-V2.1
else
    PRODUCT_PROPERTY_OVERRIDES += \
       ro.modversion=BiffMod-$(shell date +%m%d%Y)
endif

# Use the audio profile hack
WITH_DS_HTCACOUSTIC_HACK := true

#
# Copy DS specific prebuilt files
#
PRODUCT_COPY_FILES +=  \
    vendor/biffmod/prebuilt/mdpi/media/bootanimation.zip:system/media/bootanimation.zip \
    vendor/biffmod/prebuilt/dream_sapphire/etc/AudioPara_dream.csv:system/etc/AudioPara_dream.csv \
    vendor/biffmod/prebuilt/dream_sapphire/etc/AudioPara_sapphire.csv:system/etc/AudioPara_sapphire.csv \
    vendor/biffmod/prebuilt/dream_sapphire/etc/init.d/02audio_profile:system/etc/init.d/02audio_profile \
    vendor/biffmod/prebuilt/common/bin/ApkManager.sh:system/bin/ApkManager.sh \
    vendor/biffmod/prebuilt/common/etc/init.d/05mountsd:system/etc/init.d/05mountsd \
    vendor/biffmod/prebuilt/common/etc/init.d/06bindcache:system/etc/init.d/06bindcache \
    vendor/biffmod/prebuilt/common/etc/init.d/08swap:system/etc/init.d/08swap \
    vendor/biffmod/prebuilt/common/etc/init.d/10apps2sd:system/etc/init.d/10apps2sd


PRODUCT_PACKAGES += Gallery Launcher2 BiffMod

PACKAGES.Gallery.OVERRIDES := Gallery3D

