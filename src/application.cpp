/*
 *  Copyright (C) 2009 John Schember <john@nachtimwald.com>
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

#include "application.h"

extern QFile outFile;             // FIXME: TEMP? - DfB
extern QTextStream debugStream;   // FIXME: TEMP  - DfB

Application::Application(int &argc, char **argv) : QApplication(argc, argv) {
    m_manager = 0;

    debugStream << "\n\n" << argv[0] << "\nDaemon starting @ " << QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss") << endl;   // FIXME: TEMP - DfB
}

void Application::setTrayItemManagerInstance(TrayItemManager *manager) {
    m_manager = manager;
}

void Application::close() {
    if (m_manager) {
        m_manager->undockAll();
    }
    debugStream << "\nDaemon stopping" << endl;   // FIXME: TEMP  - DfB
    outFile.close();                              // FIXME: TEMP? - DfB
    quit();
}
