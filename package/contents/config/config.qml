/*
    SPDX-FileCopyrightText: 2024 Oliver Beard <olib141@outlook.com>
    SPDX-License-Identifier: MIT
*/

import QtQuick
import org.kde.plasma.configuration

ConfigModel {

    ConfigCategory {
        name: i18n("General")
        icon: "preferences-other"
        source: "config/ConfigGeneral.qml"
    }
}
