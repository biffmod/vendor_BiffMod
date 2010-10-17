# Generic Cyanogenmod + BiffMod product
PRODUCT_NAME := biffmod
PRODUCT_BRAND := biffmod
PRODUCT_DEVICE := generic

PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=DonMessWivIt.ogg

PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=biffmod

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# Used by BusyBox
KERNEL_MODULES_DIR:=/system/lib/modules

# Tiny toolbox
TINY_TOOLBOX:=true

# Enable Windows Media if supported by the board
WITH_WINDOWS_MEDIA:=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.google.clientidbase=android-google \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.ril.hsxpa=2 \
    ro.ril.gprsclass=12 \
    ro.com.android.dataroaming=false

# CyanogenMod specific product packages
PRODUCT_PACKAGES += \
    CMParts \
    CMPartsHelper \
    BiffMod \
    Superuser

# DSPManager

# Copy over the changelog to the device
#PRODUCT_COPY_FILES += \
#    vendor/biffmod/CHANGELOG.mkdn:system/etc/CHANGELOG-CM.txt

# Common CM overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/biffmod/overlay/common

# Bring in some audio files
include frameworks/base/data/sounds/AudioPackage4.mk

PRODUCT_COPY_FILES += \
    vendor/biffmod/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/biffmod/prebuilt/common/etc/resolv.conf:system/etc/resolv.conf \
    vendor/biffmod/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf \
    vendor/biffmod/prebuilt/common/etc/terminfo/l/linux:system/etc/terminfo/l/linux \
    vendor/biffmod/prebuilt/common/etc/terminfo/u/unknown:system/etc/terminfo/u/unknown \
    vendor/biffmod/prebuilt/common/etc/profile:system/etc/profile \
    vendor/biffmod/prebuilt/common/etc/init.local.rc:system/etc/init.local.rc \
    vendor/biffmod/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/biffmod/prebuilt/common/etc/init.d/01sysctl:system/etc/init.d/01sysctl \
    vendor/biffmod/prebuilt/common/etc/init.d/03firstboot:system/etc/init.d/03firstboot \
    vendor/biffmod/prebuilt/common/etc/init.d/04modules:system/etc/init.d/04modules \
    vendor/biffmod/prebuilt/common/bin/handle_compcache:system/bin/handle_compcache \
    vendor/biffmod/prebuilt/common/bin/compcache:system/bin/compcache \
    vendor/biffmod/prebuilt/common/bin/fix_permissions:system/bin/fix_permissions \
    vendor/biffmod/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/biffmod/prebuilt/common/xbin/htop:system/xbin/htop \
    vendor/biffmod/prebuilt/common/xbin/irssi:system/xbin/irssi \
    vendor/biffmod/prebuilt/common/xbin/lsof:system/xbin/lsof \
    vendor/biffmod/prebuilt/common/xbin/powertop:system/xbin/powertop \
    vendor/biffmod/prebuilt/common/xbin/openvpn-up.sh:system/xbin/openvpn-up.sh

# Always run in insecure mode, enables root on user build variants
#ADDITIONAL_DEFAULT_PROPERTIES += ro.secure=0

ifdef CYANOGEN_WITH_GOOGLE
    PRODUCT_COPY_FILES += \
        vendor/biffmod/proprietary/CarHomeGoogle.apk:./system/app/CarHomeGoogle.apk \
        vendor/biffmod/proprietary/CarHomeLauncher.apk:./system/app/CarHomeLauncher.apk \
        vendor/biffmod/proprietary/Facebook.apk:./system/app/Facebook.apk \
        vendor/biffmod/proprietary/Gmail.apk:./system/app/Gmail.apk \
        vendor/biffmod/proprietary/GoogleBackupTransport.apk:./system/app/GoogleBackupTransport.apk \
        vendor/biffmod/proprietary/GoogleCalendarSyncAdapter.apk:./system/app/GoogleCalendarSyncAdapter.apk \
        vendor/biffmod/proprietary/GoogleContactsSyncAdapter.apk:./system/app/GoogleContactsSyncAdapter.apk \
        vendor/biffmod/proprietary/GoogleFeedback.apk:./system/app/GoogleFeedback.apk \
        vendor/biffmod/proprietary/GooglePartnerSetup.apk:./system/app/GooglePartnerSetup.apk \
        vendor/biffmod/proprietary/GoogleQuickSearchBox.apk:./system/app/GoogleQuickSearchBox.apk \
        vendor/biffmod/proprietary/GoogleServicesFramework.apk:./system/app/GoogleServicesFramework.apk \
        vendor/biffmod/proprietary/HtcCopyright.apk:./system/app/HtcCopyright.apk \
        vendor/biffmod/proprietary/HtcEmailPolicy.apk:./system/app/HtcEmailPolicy.apk \
        vendor/biffmod/proprietary/HtcSettings.apk:./system/app/HtcSettings.apk \
        vendor/biffmod/proprietary/LatinImeTutorial.apk:./system/app/LatinImeTutorial.apk \
        vendor/biffmod/proprietary/Maps.apk:./system/app/Maps.apk \
        vendor/biffmod/proprietary/MarketUpdater.apk:./system/app/MarketUpdater.apk \
        vendor/biffmod/proprietary/MediaUploader.apk:./system/app/MediaUploader.apk \
        vendor/biffmod/proprietary/NetworkLocation.apk:./system/app/NetworkLocation.apk \
        vendor/biffmod/proprietary/OneTimeInitializer.apk:./system/app/OneTimeInitializer.apk \
        vendor/biffmod/proprietary/PassionQuickOffice.apk:./system/app/PassionQuickOffice.apk \
        vendor/biffmod/proprietary/SetupWizard.apk:./system/app/SetupWizard.apk \
        vendor/biffmod/proprietary/Street.apk:./system/app/Street.apk \
        vendor/biffmod/proprietary/Talk.apk:./system/app/Talk.apk \
        vendor/biffmod/proprietary/Twitter.apk:./system/app/Twitter.apk \
        vendor/biffmod/proprietary/Vending.apk:./system/app/Vending.apk \
        vendor/biffmod/proprietary/VoiceSearch.apk:./system/app/VoiceSearch.apk \
        vendor/biffmod/proprietary/YouTube.apk:./system/app/YouTube.apk \
        vendor/biffmod/proprietary/googlevoice.apk:./system/app/googlevoice.apk \
        vendor/biffmod/proprietary/kickback.apk:./system/app/kickback.apk \
        vendor/biffmod/proprietary/soundback.apk:./system/app/soundback.apk \
        vendor/biffmod/proprietary/talkback.apk:./system/app/talkback.apk \
        vendor/biffmod/proprietary/com.google.android.maps.xml:./system/etc/permissions/com.google.android.maps.xml \
        vendor/biffmod/proprietary/features.xml:./system/etc/permissions/features.xml \
        vendor/biffmod/proprietary/com.google.android.maps.jar:./system/framework/com.google.android.maps.jar \
        vendor/biffmod/proprietary/libinterstitial.so:./system/lib/libinterstitial.so \
        vendor/biffmod/proprietary/libspeech.so:./system/lib/libspeech.so
else
    PRODUCT_PACKAGES += \
        Provision \
        GoogleSearch \
        LatinIME
endif
