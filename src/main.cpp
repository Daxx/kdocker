/*
 *  Copyright (C) 2009 John Schember <john@nachtimwald.com>
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

#include <QLocale>
#include <QTranslator>

#include <signal.h>

#include "application.h"
#include "constants.h"

static void sighandler(int sig) {
    Q_UNUSED(sig);

    dynamic_cast<Application*> (qApp)->close();
}

QFile outFile;             // FIXME: TEMP? - DfB
QTextStream debugStream;   // FIXME: TEMP? - DfB

void debugMessageHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    QString dt  = QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss");
    QString txt = QString("[%1] (%2:%3) ").arg(dt).arg(QFileInfo(context.file).fileName(), 20).arg(context.line, 3);

    switch (type)
    {
        case QtDebugMsg:
            txt += QString("{Debug   }\t %1").arg(msg);
            break;
        case QtWarningMsg:
            txt += QString("{Warning }\t %1").arg(msg);
            break;
        case QtCriticalMsg:
            txt += QString("{Critical}\t %1").arg(msg);
            break;
        case QtFatalMsg:
            txt += QString("{*FATAL* }\t %1").arg(msg);
            abort();
            break;
    }
   debugStream << txt << endl;
}


int main(int argc, char *argv[]) {
    if ( QDir::setCurrent(QDir::homePath()) )   // FIXME: TEMP logging - DfB
    {
#ifdef DBUS_TESTING
        outFile.setFileName("kdocker-daemon-test.log");
#else
        outFile.setFileName("kdocker-daemon.log");
#endif
        outFile.open(QIODevice::WriteOnly /* | QIODevice::Append */ );
        debugStream.setDevice(&outFile);

        qInstallMessageHandler(debugMessageHandler);
    }

    Application app(argc, argv);

    // setup signal handlers that undock and quit
    signal(SIGHUP, sighandler);
    signal(SIGSEGV, sighandler);
    signal(SIGTERM, sighandler);
    signal(SIGINT, sighandler);
    signal(SIGUSR1, sighandler);

    // Setup the translator
    QTranslator translator;
    QString locale = QString("kdocker_%1").arg(QLocale::system().name());
    if (!translator.load(locale, TRANSLATIONS_PATH)) {
        if (!translator.load(locale, "./build/i18n/")) {
            translator.load(locale, "./i18n/");
        }
    }
    app.installTranslator(&translator);

    app.setOrganizationName(Constants::ORG_NAME);
    app.setOrganizationDomain(Constants::DOM_NAME);
    app.setApplicationName(Constants::APP_NAME);
    app.setApplicationVersion(Constants::APP_VERSION);
    // Quitting will be handled by the TrayItemManager -
    //  it will determine when there is nothing left running.
    app.setQuitOnLastWindowClosed(false);

    TrayItemManager manager;
    app.setTrayItemManagerInstance(&manager);

    return app.exec();
}
