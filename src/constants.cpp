/*
 *  Copyright (C) 2009, 2012, 2015 John Schember <john@nachtimwald.com>
 *
 * This is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
 * USA.
 */

#include "constants.h"


const QString Constants::APP_NAME    = "KDocker";
const QString Constants::ORG_NAME    = "com.kdocker";
const QString Constants::DOM_NAME    = "kdocker.com";
const QString Constants::WEBSITE     = "http://kdocker.com";
const QString Constants::APP_VERSION = "5.1.1";   // FIXME: KDVER

#ifdef DBUS_TESTING
    const QString Constants::DBUS_SERVICE_NAME = "com.kdockertest";
#else
    const QString Constants::DBUS_SERVICE_NAME = "com.kdocker";
#endif

//const char *Constants::OPTIONSTRING = "+abd:e:fhi:jklmn:op:qrstvuw:x:";
const char *Constants::OPTIONSTRING = "+abd:De:fhi:jklmn:op:qrstvuw:x:Z";  // FIXME: TEMP? - DfB

const QString Constants::ABOUT_MESSAGE = QString("%1 %2\n\n%3").arg(Constants::APP_NAME).arg(Constants::APP_VERSION).arg(Constants::WEBSITE);
