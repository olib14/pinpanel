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
    property bool wasPinned: false
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

    function setPinned(pinned: bool) : void {
        panelView.visibilityMode = pinned ? Plasmoid.configuration.pinnedVisibilityMode
                                          : Plasmoid.configuration.unpinnedVisibilityMode;
    }

    function togglePinned() : void {
        setPinned(!pinned);
        root.wasPinned = root.pinned;
    }

    Connections {
        target: Plasmoid.configuration

        function onPinnedVisibilityModeChanged()   : void { setPinned(wasPinned); }
        function onUnpinnedVisibilityModeChanged() : void { setPinned(wasPinned); }
    }

    Item {
        onWindowChanged: (window) => {
            root.panelView = window;
            root.wasPinned = root.pinned;
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
            case Enum.CompactDelegates.ToolButton:
            default:
                return "Pin";
            case Enum.CompactDelegates.Icon:
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
