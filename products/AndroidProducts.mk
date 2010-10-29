PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/biffmod_dream_sapphire.mk

biffmod-ota: otapackage
	echo "SquishIt :)"
	./vendor/biffmod/tools/squisher

