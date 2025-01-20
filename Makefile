export THEOS = /var/mobile/theos
THEOS_PLATFORM_DEB_COMPRESSION_TYPE = xz
ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1
TARGET = iphone:clang:latest:13.0


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ESP
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation SystemConfiguration SafariServices IOKit CoreFoundation Metal MetalKit CoreGraphics QuartzCore CoreText
$(TWEAK_NAME)_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG -fexceptions
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-return-type -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value -Wno-unused-function
$(TWEAK_NAME)_LDFLAGS += JRMemory.framework/JRMemory
$(TWEAK_NAME)_FILES = Esp_Full.mm $(wildcard LIB/IMGUI/*.mm) $(wildcard LIB/IMGUI/*.cpp) $(wildcard LIB/Esp/*.mm) $(wildcard LIB/Esp/*.m) $(wildcard hook/*.c) $(wildcard Hosts/*.m)

# $(TWEAK_NAME)_LIBRARIES += substrate

include $(THEOS_MAKE_PATH)/tweak.mk
