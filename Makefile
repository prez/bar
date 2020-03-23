# This snippet has been shmelessly stol^Hborrowed from thestinger's repose Makefile
VERSION = 1.1
GIT_DESC=$(shell test -d .git && git describe --always 2>/dev/null)

ifneq "$(GIT_DESC)" ""
	VERSION=$(GIT_DESC)
endif

CC	?= clang
CFLAGS += -Wall -std=c99 -O2 -DVERSION="\"$(VERSION)\"" -D_POSIX_C_SOURCE=200809L -I/usr/include/freetype2
LDFLAGS += -lxcb -lxcb-xinerama -lxcb-randr -lxcb-ewmh \
		   -lxcb-render -lxcb-render-util -lm -lX11 -lX11-xcb -lXft -lfreetype -lz -lfontconfig
CFDEBUG = -g3 -pedantic -Wall -Wunused-parameter -Wlong-long \
          -Wsign-conversion -Wconversion -Wimplicit-function-declaration

EXEC = bar
SRCS = bar.c
OBJS = ${SRCS:.c=.o}

PREFIX?=${HOME}/usr/local
BINDIR=${PREFIX}/bin

all: ${EXEC}

doc: README.pod
	pod2man --section=1 --center="bar Manual" --name "bar" --release="bar $(VERSION)" README.pod > bar.1

.c.o:
	${CC} ${CFLAGS} -o $@ -c $<

${EXEC}: ${OBJS}
	${CC} -o ${EXEC} ${OBJS} ${LDFLAGS}

debug: ${EXEC}
debug: CC += ${CFDEBUG}

clean:
	rm -f ./*.o
	rm -f ./${EXEC}

install: bar doc
	install -D -m 755 bar ${DESTDIR}${BINDIR}/bar
	install -D -m 644 bar.1 ${HOME}/usr/man/man1/bar.1

uninstall:
	rm -f ${DESTDIR}${BINDIR}/bar
	rm -f $(DESTDIR)$(PREFIX)/share/man/man1/bar.1

.PHONY: all debug clean install
