/*
 *  Copyright (C) 2009, 2012 John Schember <john@nachtimwald.com>
 *  Copyright (C) 2004 Girish Ramakrishnan All Rights Reserved.
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


#include <QCoreApplication>
#include <QtDBus>

#include <iostream>
using namespace std;

#include "constants.h"


int main(int argc, char *argv[]) {
    QCoreApplication app(argc, argv);

    if (!QDBusConnection::sessionBus().isConnected()) {
        cerr << "Cannot connect to the D-Bus session bus." << endl;
        return 1;
    }
    QDBusInterface iface(Constants::DBUS_SERVICE_NAME, "/KDocker", "", QDBusConnection::sessionBus());
    // if (! iface.isValid()) {}  // FIXME: ? Fails unless daemon already active (before dbus activation)

    QStringList argList = QCoreApplication::arguments();
    argList.removeFirst();  // program name
    QDBusReply<QString> reply = iface.call("exec", argList.join('\n'));
    if (!reply.isValid()) {
        cerr << "Call failed: " << qPrintable(reply.error().message())
                         << " " << qPrintable(QDBusError::errorString(reply.error().type()))
                         << " " << qPrintable(reply.error().name()) << endl;
        return 1;
    }
    // Deliver reply to stdout
    cout << qPrintable(reply.value()) << std::flush;
    return 0;
}
