
#############
DBUS_TESTING = "?"   # FIXME: (un)comment
#############

defined(DBUS_TESTING, var) {
  DEFINES += DBUS_TESTING   # define same-named variable for compiling
}

TEMPLATE = app
CONFIG  += qt

BASEDIR = $$absolute_path(..)

CONFIG(release, debug|release) {
  BUILD = $$absolute_path($$BASEDIR/build/release)
}

CONFIG(debug, debug|release) {
  BUILD = $$absolute_path($$BASEDIR/build/debug)
}

#~~~~~

DBUS_SERVICE_CHANGED = false
DBUS_CHK_FILE = $$BUILD/_DBUS_TESTING_  # (OK to delete file at any time)

exists($$DBUS_CHK_FILE) {
  !defined(DBUS_TESTING, var) {
     r = $$system( rm    $$DBUS_CHK_FILE)  # delete
     DBUS_SERVICE_CHANGED = true
  }
} else {
   defined(DBUS_TESTING, var) {
     r = $$system(touch  $$DBUS_CHK_FILE)  # create
     DBUS_SERVICE_CHANGED = true
  }
}
if(DBUS_SERVICE_CHANGED) {
  # Force recompile for objs that hold a reference to another dbus adaptor
  r = $$system(touch -cm $$BASEDIR/src/constants.h)
}

#~~~~~

DESTDIR = $$BASEDIR

VPATH += $$BASEDIR/src

DEPENDPATH +=  $$BASEDIR/src
INCLUDEPATH += $$BASEDIR/src

# Output
MOC_DIR =     $$BUILD/.moc
OBJECTS_DIR = $$BUILD/.obj
RCC_DIR =     $$BUILD
