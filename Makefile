it: all

include config.mak
include files.mak

HOOKS = aa-base aa-repo

%: %.in
	sed -e 's#@BINDIR@#$(bindir)#' -e 's#@LIBDIR@#$(libdir)#' $^ > $@

all: $(BINS) $(DATA)

install: it
	for bin in $(BINS); do \
		install -Dm744 $$bin $(DESTDIR)$(libdir)/$$bin; \
	done
	for f in $(DATA); do \
		install -Dm644 $$f $(DESTDIR)$(libdir)/$$f; \
	done
	for f in $(FIFO); do \
		mkfifo $(DESTDIR)$(libdir)/$$f; \
	done
	for f in $(HOOKS); do \
		install -Dm644 mkinitcpio.hooks/$$f $(DESTDIR)$(libdir)/initcpio/install/$$f; \
	done
	mkdir -p $(DESTDIR)/etc/anopa/env && echo $(bindir) > $(DESTDIR)/etc/anopa/env/PATH

clean:
	rm -f $(BINS)
distclean: clean
	rm -f config.mak files.mak

.PHONY: install it all clean distclean
