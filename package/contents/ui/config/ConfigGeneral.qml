/*
    SPDX-FileCopyrightText: 2024 Oliver Beard <olib141@outlook.com>
    SPDX-License-Identifier: MIT
*/

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

import "../../code/enum.js" as Enum

KCM.SimpleKCM {
    id: root

    property int cfg_pinnedVisibilityMode
    property int cfg_unpinnedVisibilityMode
    property int cfg_compactDelegate

    // HACK: Suppresses errors
    // https://invent.kde.org/plasma/plasma-desktop/-/merge_requests/2619
    property int cfg_pinnedVisibilityModeDefault
    property int cfg_unpinnedVisibilityModeDefault
    property int cfg_compactDelegateDefault

    readonly property list<string> visibilityModes: ["Always visible", "Auto hide", "Dodge windows", "Windows go below"]

    Kirigami.FormLayout {

        Item {
            Kirigami.FormData.label: "Behavior"
            Kirigami.FormData.isSection: true
        }

        QQC2.ComboBox {
            Kirigami.FormData.label: "Pinned:"

            model: visibilityModes
            currentIndex: cfg_pinnedVisibilityMode
            onActivated: (index) => { cfg_pinnedVisibilityMode = index; }
        }

        QQC2.ComboBox {
            Kirigami.FormData.label: "Unpinned:"

            model: visibilityModes
            currentIndex: cfg_unpinnedVisibilityMode
            onActivated: (index) => { cfg_unpinnedVisibilityMode = index; }
        }

        Item {
            Kirigami.FormData.label: "Appearance"
            Kirigami.FormData.isSection: true
        }

        QQC2.ButtonGroup {
            id: compactDelegateGroup
        }

        QQC2.RadioButton {
            Kirigami.FormData.label: "Style:"
            QQC2.ButtonGroup.group: compactDelegateGroup

            text: "Button"
            checked: cfg_compactDelegate == Enum.CompactDelegates.ToolButton;
            onCheckedChanged: if (checked) { cfg_compactDelegate = Enum.CompactDelegates.ToolButton; }
        }

        QQC2.RadioButton {
            QQC2.ButtonGroup.group: compactDelegateGroup

            text: "Icon"
            checked: cfg_compactDelegate == Enum.CompactDelegates.Icon;
            onCheckedChanged: if (checked) { cfg_compactDelegate = Enum.CompactDelegates.Icon; }
        }
    }
}
