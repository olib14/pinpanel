/*
    SPDX-FileCopyrightText: 2024 Oliver Beard <olib141@outlook.com>
    SPDX-License-Identifier: MIT
*/

import QtQuick

import org.kde.plasma.plasmoid

import "../code/enum.js" as Enum

PlasmoidItem {
    id: root

    property QtObject panelView: null

    property bool ready: (panelView != null && panelView.source.toString().endsWith("Panel.qml"))
    property bool pinned: {
        if (!ready) {
            return false;
        }

        switch (panelView.visibilityMode) {
            // Consider user configuration first
            case Plasmoid.configuration.pinnedVisibilityMode:
                return true;
            case Plasmoid.configuration.unpinnedVisibilityMode:
                return false;

            // Else, reasonable defaults
            case Enum.VisibilityModes.NormalPanel:    // 0 (default)
            case Enum.VisibilityModes.WindowsGoBelow: // 3
                return true;
            case Enum.VisibilityModes.AutoHide:       // 1 (default)
            case Enum.VisibilityModes.DodgeWindows:   // 2
                return false;
        }
    }

    function togglePinned() : void {
        panelView.visibilityMode = pinned ? Plasmoid.configuration.unpinnedVisibilityMode
                                          : Plasmoid.configuration.pinnedVisibilityMode;
    }

    Item {
        onWindowChanged: (window) => {
            root.panelView = window;
        }
    }

    preferredRepresentation: compactRepresentation
    compactRepresentation: CompactRepresentation {}
    fullRepresentation: Item {}

    toolTipMainText: {
        if (!ready) {
            return Plasmoid.title;
        }

        switch (Plasmoid.configuration.compactDelegate) {
            case Enums.CompactDelegates.ToolButton:
            default:
                return "Pin";
            case Enums.CompactDelegates.Icon:
                return pinned ? "Unpin" : "Pin";
        }
    }

    toolTipSubText: {
        if (!ready) {
            return "Place inside a panel to use";
        }

        return "";
    }
}
