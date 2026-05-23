TARGET := iphone:clang:16.5:13.0
ARCHS  := arm64
DEBUG  := 0
FINALPACKAGE := 1
PACKAGE_VERSION := 1.0.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YTLBypass
YTLBypass_FILES = Tweak.x
YTLBypass_FRAMEWORKS = UIKit Foundation
YTLBypass_CFLAGS = -fobjc-arc -DTWEAK_VERSION=$(PACKAGE_VERSION)

include $(THEOS_MAKE_PATH)/tweak.mk
