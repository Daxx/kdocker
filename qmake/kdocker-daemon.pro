
include(common.pri)

QT      += widgets dbus x11extras

defined(DBUS_TESTING, var) {
  TARGET = kdocker-daemon-test

  SERVICE = com.kdockertest

  !build_pass:message("kdocker-daemon.pro: DBUS_TESTING (using $${SERVICE}.service)")
  POST_TARGETDEPS += local-service  # FIXME: Extremely TEMP !!

} else {
  TARGET = kdocker-daemon

  SERVICE = com.kdocker
}

#~~~~~

DBUS_ADAPTORS += $$BASEDIR/dbus/$${SERVICE}.xml
SERVICE_TEMPLATE = $$absolute_path($$BASEDIR/dbus/$${SERVICE}.service_template)

INCLUDEPATH += /usr/include/X11
QMAKE_LIBDIR += /usr/X11/lib
LIBS = -lX11 -lXpm -lXmu

# Input
HEADERS += application.h \
           constants.h \
           scanner.h \
           trayitem.h \
           trayitemmanager.h \
           xlibutil.h
SOURCES += application.cpp \
           constants.cpp \
           main.cpp \
           scanner.cpp \
           trayitem.cpp \
           trayitemmanager.cpp \
           xlibutil.cpp

RESOURCES += $$BASEDIR/resources/resources.qrc

INSTALL_PATH = /usr/share/kdocker

target.path = $$INSTALL_PATH
INSTALLS += target

#~~~~~

# Rebuild these if constants.h was "touched" by common.pri
DBUS_OBJS = $$OBJECTS_DIR/constants.o \
            $$OBJECTS_DIR/trayitemmanager.o
dbus_test_xtra.target  = $$DBUS_OBJS
dbus_test_xtra.depends = $$BASEDIR/src/constants.h
QMAKE_EXTRA_TARGETS += dbus_test_xtra

#~~~~~

icons.path = /usr/share/pixmaps
icons.files = $$BASEDIR/resources/images/kdocker.png  # FIXME: Other images appear in /usr/share/kdocker (root) - wrong?
INSTALLS += icons

#~~~

SERVICE_INSTALL_PATH_LOCAL = ~/.local/share/dbus-1/services

# Ensure LOCAL directory structure for .service file
local-service.commands += @test -d $${SERVICE_INSTALL_PATH_LOCAL}/ || mkdir -p  $${SERVICE_INSTALL_PATH_LOCAL}/  $$escape_expand(\n\t)
# Create LOCAL .service file (for testing)
local-service.commands += sed \'s|!DAEMON_PATH!|$$absolute_path($$DESTDIR)/$${TARGET}|g\' $$SERVICE_TEMPLATE > $${BUILD}/$${SERVICE}_build.service  $$escape_expand(\n\t)
local-service.commands += $(INSTALL_FILE) -T $${BUILD}/$${SERVICE}_build.service $${SERVICE_INSTALL_PATH_LOCAL}/$${SERVICE}.service

local-service-clean.commands += $(DEL_FILE) $${SERVICE_INSTALL_PATH_LOCAL}/$${SERVICE}.service
#? QMAKE_CLEAN += local-service-clean

QMAKE_EXTRA_TARGETS += local-service  local-service-clean   # (Also shortcuts to these targets in kdocker.pro)

#~~~~~

SERVICE_INSTALL_PATH = /usr/share/dbus-1/services

dbus_service.path = $${SERVICE_INSTALL_PATH}
# Create SYSTEM .service file from template
dbus_service.commands += sed \'s|!DAEMON_PATH!|$${INSTALL_PATH}/$${TARGET}|g\' $$SERVICE_TEMPLATE > $${BUILD}/$${SERVICE}.service  $$escape_expand(\n\t)
dbus_service.commands += $(INSTALL_FILE) -T $${BUILD}/$${SERVICE}.service $${SERVICE_INSTALL_PATH}/$${SERVICE}.service

INSTALLS += dbus_service

#~~~~~

TRANSLATIONS_PATH = $$INSTALL_PATH
DEFINES += TRANSLATIONS_PATH=\\\"$${TRANSLATIONS_PATH}/i18n\\\"

#DO_KDOCKER_TRANSLATION = (un)comment

defined(DO_KDOCKER_TRANSLATION, var) {
  TRANSLATIONS += $$BASEDIR/i18n/

  isEmpty(QMAKE_LRELEASE) {
    QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease
    !exists($$QMAKE_LRELEASE) { QMAKE_LRELEASE = lrelease-qt4 }
  }
  updateqm.input = TRANSLATIONS
  updateqm.output = $$BUILD/i18n/${QMAKE_FILE_BASE}.qm
  updateqm.commands = $$QMAKE_LRELEASE -silent ${QMAKE_FILE_IN} -qm $$BUILD/i18n/${QMAKE_FILE_BASE}.qm
  updateqm.CONFIG += no_link target_predeps
  QMAKE_EXTRA_COMPILERS += updateqm

  translations.path = $$TRANSLATIONS_PATH
  translations.files = $$BUILD/i18n

  INSTALLS += translations
}

#~~~~~
