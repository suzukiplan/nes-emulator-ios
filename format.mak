HEADER = $(shell for file in `find . -name *.h | grep -v Pods | grep -v emulator/ | grep -v miniz.h`;do echo $$file; done)
CPP_HEADER = $(shell for file in `find . -name *.hpp | grep -v Pods | grep -v emulator/`;do echo $$file; done)
C_SOURCE = $(shell for file in `find . -name *.c | grep -v Pods | grep -v emulator/`;do echo $$file; done)
CPP_SOURCE = $(shell for file in `find . -name *.cpp | grep -v Pods | grep -v emulator/`;do echo $$file; done)
OBJC_SOURCE = $(shell for file in `find . -name *.m | grep -v Pods | grep -v emulator/`;do echo $$file; done)
SOURCES = $(HEADER) $(CPP_HEADER) $(C_SOURCE) $(CPP_SOURCE) $(OBJC_SOURCE)

all:
	for SOURCE in $(SOURCES); do sh format.sh $$SOURCE; done

