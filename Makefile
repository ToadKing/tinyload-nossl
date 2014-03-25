PREFIX = $(DEVKITPPC)/bin/powerpc-eabi-

# For a debug build, add -DDEBUG to CFLAGS
# Yeah I'm too lazy to automate this a better way :P

MACHDEP = -mcpu=750 -meabi -mhard-float -DTINY
CFLAGS = $(MACHDEP) -DDEBUG -Os -Wall -pipe -ffunction-sections -finline-functions-called-once -mno-sdata -flto -fwhole-program -ffreestanding
LDFLAGS = $(MACHDEP) -n -nostartfiles -nostdlib -flto -Wl,-T,tinyload.ld
ASFLAGS = -D_LANGUAGE_ASSEMBLY -DHW_RVL -DTINY

TARGET_STRIP = tinyload.elf
TARGET = tinyload_sym.elf

CFILES = ios.c debug.c usb.c utils.c di.c cache.c main.c
OBJS = crt0.o ios.o debug.o usb.o utils.o di.o cache.o main.o

LIBS = 

include common.mk

all: $(TARGET_STRIP)

#_all.o: $(CFILES)
#	@echo "  COMPILE ALL"
#	@mkdir -p $(DEPDIR)
#	$(CC) $(CFLAGS) $(DEFINES) -Wp,-MMD,$(DEPDIR)/$(*F).d,-MQ,"$@",-MP -c $(CFILES) -o $@


$(TARGET_STRIP): $(TARGET)
	@echo "  STRIP     $@"
	@cp $(TARGET) $(TARGET_STRIP)

upload: $(TARGET_STRIP)
	@WIILOAD=/dev/usbgecko wiiload $(TARGET_STRIP)

clean: myclean

myclean:
	rm -rf $(TARGET_STRIP)

