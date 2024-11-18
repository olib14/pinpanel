/*
    SPDX-FileCopyrightText: 2024 Oliver Beard <olib141@outlook.com
    SPDX-License-Identifier: MIT
*/

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

import "../code/enum.js" as Enum

Loader {
    id: compactRoot

    readonly property bool isVertical: (Plasmoid.formFactor == PlasmaCore.Types.Vertical)

    Layout.preferredWidth:  isVertical ? width : height
    Layout.preferredHeight: isVertical ? width : height

    sourceComponent: {
        if (!root.ready) {
            return iconComponent;
        }

        switch (Plasmoid.configuration.compactDelegate) {
            case Enum.CompactDelegates.ToolButton:
            default:
                return toolButtonComponent;
            case Enum.CompactDelegates.Icon:
                return iconComponent;
        }
    }

    Component {
        id: toolButtonComponent

        PlasmaComponents.ToolButton {
            anchors.fill: parent

            enabled: root.ready

            icon.name: "pin-symbolic"
            text: "Pin"
            display: PlasmaComponents.ToolButton.IconOnly

            checkable: true
            checked: root.pinned
            onToggled: root.togglePinned()
        }
    }

    Component {
        id: iconComponent

        Kirigami.Icon {
            anchors.fill: parent

            source: root.pinned ? "window-unpin-symbolic" : "window-pin-symbolic"
            active: mouseArea.containsMouse

            MouseArea {
                id: mouseArea
                anchors.fill: parent

                hoverEnabled: true
                onClicked: root.togglePinned()
            }
        }
    }
}
