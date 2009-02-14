#
# Makefile for the Scripting VDR plugin
#
PLUGIN = scripting

### The version number of this plugin (taken from the main source file):

VERSION = $(shell grep 'static const char VERSION\[\] =' src/Version.h | \
  awk '{ print $$6 }' | sed -e 's/[";]//g')

### The C++ compiler and options:

CXX      ?= g++
CXXFLAGS ?= -fPIC -O2 -Wall -Woverloaded-virtual

### The Ruby interpreter to be used:

RUBY ?= /usr/bin/ruby1.8

### The directory environment:

DVBDIR = ../../../../DVB
VDRDIR = ../../..
LIBDIR = ../../lib
TMPDIR = /tmp

### Conditionals:
#DEBUG=1

### Allow user defined options to overwrite defaults:

-include $(VDRDIR)/Make.config

### The version number of VDR's plugin API (taken from VDR's "config.h"):

APIVERSION = $(shell sed -ne '/define APIVERSION/s/^.*"\(.*\)".*$$/\1/p' \
  $(VDRDIR)/config.h)

### The name of the distribution archive:

ARCHIVE = $(PLUGIN)-$(VERSION)
PACKAGE = vdr-$(ARCHIVE)

### SWIG stuff:

SWIG    ?= swig
SWIGOPT  = -Wall -w473 -ruby -c++ -Iswig -Iswig/custom -autorename

### Includes and Defines (add further entries here):

INCLUDES += -I. -I$(VDRDIR)/include -I$(DVBDIR)/include
INCLUDES += `$(RUBY) ruby-config.rb --cflags`

DEFINES  += -D_GNU_SOURCE -DPLUGIN_NAME_I18N='"$(PLUGIN)"'
DEFINES  += -DRUBY_EMBEDDED

LIBS     += `$(RUBY) ruby-config.rb --libs`

ifdef DEBUG
	DEFINES += -DDEBUG
endif

### The source files (add further files here):

-include sources.mk
-include swig.mk

### The object files

OBJS := $(addsuffix .o,$(basename ${SRCS}))

### The SWIG wrappers

OBJS += $(addsuffix _wrap.o,$(basename ${INTERFACES}))

### Implicit rules:

.PRECIOUS: %_wrap.cc
%_wrap.cc: %.i
	$(SWIG) $(SWIGOPT) -o $@.in $<
	$(RUBY) swig-postprocess.rb $@.in $@

swigrubyrun.h:
	$(SWIG) -ruby -external-runtime

%.o: %.cc
	$(CXX) $(CXXFLAGS) -c $(DEFINES)  $(INCLUDES) $< -o $@

# Dependencies:

MAKEDEP = $(CXX) -MM
BUILD_DEPFILE = .dependencies

$(BUILD_DEPFILE): Makefile swigrubyrun.h
	@$(MAKEDEP) $(DEFINES) $(INCLUDES) $(SRCS) \
	  | sed "s/.*: \([^ ]*\/\).*/\1\0/" > $@
	@$(SWIG) $(SWIGOPT) -MM $(INTERFACES) >> $@

-include $(BUILD_DEPFILE)

### Internationalization (I18N):

PODIR     = po
LOCALEDIR = $(VDRDIR)/locale
I18Npo    = $(wildcard $(PODIR)/*.po)
I18Nmsgs  = $(addprefix $(LOCALEDIR)/, $(addsuffix /LC_MESSAGES/vdr-$(PLUGIN).mo, $(notdir $(foreach file, $(I18Npo), $(basename $(file))))))
I18Npot   = $(PODIR)/$(PLUGIN).pot

%.mo: %.po
	msgfmt -c -o $@ $<

$(I18Npot): $(SRCS)
	xgettext -C -cTRANSLATORS --no-wrap --no-location -k -ktr -ktrNOOP --msgid-bugs-address='<tg@e-tobi.net>' -o $@ $^

%.po: $(I18Npot)
	msgmerge -U --no-wrap --no-location --backup=none -q $@ $<
	@touch $@

$(I18Nmsgs): $(LOCALEDIR)/%/LC_MESSAGES/vdr-$(PLUGIN).mo: $(PODIR)/%.mo
	@mkdir -p $(dir $@)
	mv $< $@

.PHONY: i18n
i18n: $(I18Nmsgs)

### Targets:

all: libvdr-$(PLUGIN).so i18n

test:
	spec -c -fs .

libvdr-$(PLUGIN).so: $(OBJS)
	$(CXX) $(CXXFLAGS) -shared $(OBJS) -L. $(LIBS) -o $@
	@cp $@ $(LIBDIR)/$@.$(APIVERSION)

dist: test clean
	@-rm -rf $(TMPDIR)/$(ARCHIVE)
	@mkdir $(TMPDIR)/$(ARCHIVE)
	@cp -a * $(TMPDIR)/$(ARCHIVE)
	@tar czf $(PACKAGE).tar.gz -C $(TMPDIR) --exclude debian --exclude .git \
	  --exclude .svn --exclude tools --exclude .cproject --exclude .project \
	  --exclude .settings $(ARCHIVE)
	@-rm -rf $(TMPDIR)/$(ARCHIVE)
	@echo Distribution package created as $(PACKAGE).tar.gz

clean:
	@-rm -f $(BUILD_DEPFILE) *.so* *.tar.gz core* *~
	@-rm -f swig/*_wrap.* swigrubyrun.h
	@-find . -name \*.\o -exec rm -f {} \; 
