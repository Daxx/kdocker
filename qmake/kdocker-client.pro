
include(common.pri)

QT -= gui
QT += dbus

TARGET   = kdocker

# Input
HEADERS += constants.h
SOURCES += constants.cpp \
           kdocker.cpp

INSTALL_PATH = /usr/bin

target.path = $$INSTALL_PATH
INSTALLS += target

#~~~~~

# Rebuild these if constants.h was "touched" by common.pri
DBUS_OBJS  = $$OBJECTS_DIR/constants.o \
             $$OBJECTS_DIR/kdocker.o
dbus_test_xtra.target  = $$DBUS_OBJS
dbus_test_xtra.depends = $$BASEDIR/src/constants.h
QMAKE_EXTRA_TARGETS += dbus_test_xtra

#~~~~~

desktop.path = /usr/share/applications
desktop.files = $$BASEDIR/helpers/kdocker.desktop
INSTALLS += desktop

#~~~~~

completion.path = /etc/bash_completion.d
completion.files = $$BASEDIR/helpers/kdocker
INSTALLS += completion

#~~~~~

# Create man page (kdocker.1) from pod template
man1.commands = pod2man --center  \'General Commands Manual\' \
                        --release \'Version 5.1\'             \   # TODO: KDVER
                        --date    \"$(date +'%e %B, %Y')\"    \
                        $$BASEDIR/helpers/kdocker.pod         \
                        $$BUILD/kdocker.1
man1.path = /usr/share/man
man1.files = $$BUILD/kdocker.1
INSTALLS += man1

#~~~~~
