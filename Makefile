include theos/makefiles/common.mk
#export ARCHS = armv7 armv6
#export SDKVERSION=5.1

TWEAK_NAME = CTChineseFixer
CTChineseFixer_FILES = Tweak.xm
CTChineseFixer_FRAMEWORKS = CoreText
CTChineseFixer_LDFLAGS = -lsubstrate

include $(THEOS_MAKE_PATH)/tweak.mk
