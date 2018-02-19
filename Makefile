THEOS_DEVICE_IP = 192.168.5.68

include $(THEOS)/makefiles/common.mk

SRC = $(wildcard src/*.m)

TWEAK_NAME = DingTalkHelper
DingTalkHelper_FILES = $(wildcard src/*.m) $(wildcard src/*.xm)

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 DingTalk"
