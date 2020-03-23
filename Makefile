.POSIX:

NAME = bar
VERSION = 1.1

CC	   = cc
PREFIX = /usr/local
bindir = /bin
mandir = /share/man

CFLAGS = -std=c99 -Wall -Wextra -Wpedantic -O2     \
         -I/usr/include/freetype2
CFDEBUG = $(CFLAGS) -g3

CPPFLAGS = -D_POSIX_C_SOURCE=200809L               \
           -DVERSION="\"$(VERSION)\""

LDLIBS = -lxcb -lxcb-xinerama -lxcb-randr          \
         -lxcb-ewmh -lxcb-render -lxcb-render-util \
         -lm -lX11 -lX11-xcb                       \
         -lXft -lfreetype -lz                      \
         -lfontconfig

all: $(NAME)

$(NAME): $(NAME).o
	$(CC) $(LDFLAGS) $(CFLAGS) $(NAME).o -o $(NAME) $(LDLIBS)
$(NAME).o: $(NAME).c

doc: README.pod
	pod2man --section=1 --center="bar Manual" --name "bar" README.pod > bar.1

debug: $(NAME).o
	$(CC) $(LDFLAGS) $(CFDEBUG) $(NAME).o -o $(NAME) $(LDLIBS)

install: $(NAME) doc
	install -D -m 0755 bar $(DESTDIR)$(PREFIX)$(bindir)/bar
	install -D -m 0644 bar.1 $(DESTDIR)$(PREFIX)$(mandir)/man1/bar.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)$(bindir)/bar
	rm -f $(DESTDIR)$(PREFIX)$(mandir)/man1/bar.1

clean:
	rm -f $(NAME) $(NAME).o $(NAME).1

utf8test: $(NAME)
	echo '流れてく, 時の中ででも, 気だ' | ./bar -p -f "monospace"

.PHONY: all debug clean install
