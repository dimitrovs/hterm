# st - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

SRC = st.c x.c
OBJ = $(SRC:.c=.o)

all: hterm

config.h:
	cp config.def.h config.h

.c.o:
	$(CC) $(STCFLAGS) -c $<

st.o: config.h st.h win.h
x.o: arg.h config.h st.h win.h

$(OBJ): config.h config.mk

hterm: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f hterm $(OBJ) st-$(VERSION).tar.gz

dist: clean
	mkdir -p st-$(VERSION)
	cp -R FAQ LEGACY TODO LICENSE Makefile README config.mk\
		config.def.h st.info hterm.1 arg.h st.h win.h $(SRC)\
		st-$(VERSION)
	tar -cf - st-$(VERSION) | gzip > st-$(VERSION).tar.gz
	rm -rf st-$(VERSION)

install: hterm
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f hterm $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/hterm
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < hterm.1 > $(DESTDIR)$(MANPREFIX)/man1/hterm.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/hterm.1
	tic -sx st.info
	@echo Please see the README file regarding the terminfo entry of st.

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/hterm
	rm -f $(DESTDIR)$(MANPREFIX)/man1/hterm.1

.PHONY: all clean dist install uninstall
