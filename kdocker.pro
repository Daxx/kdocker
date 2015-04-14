TEMPLATE = subdirs
SUBDIRS  = qmake/kdocker-client.pro \
           qmake/kdocker-daemon.pro

#~~~~~

# Shortcuts to allow 'make local-service*' ( in "kdocker-daemon.pro" )   # FIXME: TEMP? - DfB
local-service.commands         += @$(MAKE) -f qmake/Makefile.kdocker-daemon  local-service
local-service-clean.commands   += @$(MAKE) -f qmake/Makefile.kdocker-daemon  local-service-clean
QMAKE_EXTRA_TARGETS += local-service  local-service-clean

#~~~~~
