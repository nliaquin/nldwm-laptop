# Common settings
PREFIX  := /usr/local
CC      := cc
VERSION := 1.0
CFLAGS  := -pedantic -Wall -Wno-deprecated-declarations -Os -I. -I/usr/include/freetype2 -DVERSION=\"${VERSION}\"
LDFLAGS := -lX11 -lXft -lfontconfig

# Source files
DWM_SRC = drw.c dwm.c util.c
DWMBLOCKS_SRC = dwmblocks.c

# Object files
DWM_OBJ = ${DWM_SRC:.c=.o}
DWMBLOCKS_OBJ = ${DWMBLOCKS_SRC:.c=.o}

all: dwm dwmblocks

# Build dwm
dwm: ${DWM_OBJ}
	${CC} -o $@ ${DWM_OBJ} ${LDFLAGS}

# Build dwmblocks
dwmblocks: ${DWMBLOCKS_OBJ} blocks.h
	${CC} -o $@ ${DWMBLOCKS_OBJ} ${CFLAGS} ${LDFLAGS}

# Dependencies
${DWM_OBJ}: config.h config.mk
${DWMBLOCKS_OBJ}: blocks.h

# Copy default headers if they don't exist
config.h:
	cp config.def.h $@

blocks.h:
	cp blocks.def.h $@

# Compilation rules
.c.o:
	${CC} -c ${CFLAGS} $< -o $@

# Clean
clean:
	rm -f dwm dwmblocks ${DWM_OBJ} ${DWMBLOCKS_OBJ}

# Install
install: all
	# Install dwm
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1

	# Install dwmblocks
	cp -f dwmblocks ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwmblocks

# Uninstall
uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/dwm\
		${DESTDIR}${MANPREFIX}/man1/dwm.1
	rm -f ${DESTDIR}${PREFIX}/bin/dwmblocks

.PHONY: all clean install uninstall
