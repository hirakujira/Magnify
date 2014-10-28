TWEAK_NAME = Magnify
Magnify_OBJCC_FILES = Tweak.xm

IP_ADDRESS=10.0.1.13
IP_ADDRESS2=127.0.0.1
IP_ADDRESS3=10.0.1.24
Magnify_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices
Magnify_FRAMEWORKS = UIKit
TARGET = :clang::7.0
ARCHS = armv7 arm64
include theos/makefiles/common.mk
include theos/makefiles/tweak.mk

sync: stage
	rsync -z _/Library/MobileSubstrate/DynamicLibraries/* root@$(IP_ADDRESS):/Library/MobileSubstrate/DynamicLibraries/
	ssh root@$(IP_ADDRESS) killall Preferences
	
sync2: stage
	rsync -e "ssh -p 2222" -z _/Library/MobileSubstrate/DynamicLibraries/* root@127.0.0.1:/Library/MobileSubstrate/DynamicLibraries/
	ssh root@127.0.0.1 -p 2222 killall Preferences
	
sync3: stage
	rsync -z _/Library/MobileSubstrate/DynamicLibraries/* root@$(IP_ADDRESS3):/Library/MobileSubstrate/DynamicLibraries/
	ssh root@$(IP_ADDRESS3) killall Preferences