/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project on Qt Labs.
**
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions contained
** in the Technology Preview License Agreement accompanying this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/

import QtQuick 1.0
import "." 1.0

FocusScopeItem {
    id: root

    // Common public API
    property alias font: textEdit.font
    property alias cursorPosition: textEdit.cursorPosition
    property alias horizontalAlignment: textEdit.horizontalAlignment
    property alias inputMethodHints: textEdit.inputMethodHints
    property alias verticalAlignment: textEdit.verticalAlignment
    property alias readOnly: textEdit.readOnly
    property alias selectedText: textEdit.selectedText
    property alias selectionEnd: textEdit.selectionEnd
    property alias selectionStart: textEdit.selectionStart
    property alias text: textEdit.text
    property alias textFormat: textEdit.textFormat
    property alias wrapMode: textEdit.wrapMode
    property bool errorHighlight: false

    function copy() {
        textEdit.copy()
    }

    function paste() {
        textEdit.paste()
    }

    function cut() {
        textEdit.cut()
    }

    function select(start, end) {
        textEdit.select(start, end)
    }

    function selectAll() {
        textEdit.selectAll()
    }

    function selectWord() {
        textEdit.selectWord()
    }

    function positionAt(x, y) {
        var p = mapToItem(textEdit, x, y);
        return textEdit.positionAt(p.x, p.y)
    }

    function positionToRectangle(pos) {
        var rect = textEdit.positionToRectangle(pos)
        var point = mapFromItem(textEdit, rect.x, rect.y)
        rect.x = point.x; rect.y = point.y
        return rect;
    }

    // API extensions
    property alias placeholderText: placeholder.text
    // TODO: Refactor implicit size when following bugs are resolved
    // http://bugreports.qt.nokia.com/browse/QTBUG-14957
    // http://bugreports.qt.nokia.com/browse/QTBUG-16665
    // http://bugreports.qt.nokia.com/browse/QTBUG-16710 (fixed in Qt 4.7.2)
    // http://bugreports.qt.nokia.com/browse/QTBUG-12305 (fixed in QtQuick1.1)
    property bool enabled: true // overriding due to QTBUG-15797 and related bugs
    property real platformMaxImplicitWidth: (parent ? parent.width : screen.width) - root.x
    property real platformMaxImplicitHeight: (parent ? parent.height : screen.height) - root.y

    implicitWidth: {
        var preferredWidth = Math.max(flick.contentWidth, privy.minImplicitWidth)
        preferredWidth += container.verticalMargins
        return Math.min(preferredWidth, root.platformMaxImplicitWidth)
    }

    implicitHeight: {
        // first check content's height (text or placeholder) and reserve room for paddings
        var preferredHeight = Math.max(flick.contentHeight, placeholder.model.paintedHeight)
        preferredHeight += container.horizontalMargins
        // layout spec gives minimum height (textFieldHeight) which includes required padding
        preferredHeight = Math.max(privateStyle.textFieldHeight, preferredHeight)
        return Math.min(preferredHeight, root.platformMaxImplicitHeight)
    }

    Connections {
         target: screen
         onCurrentOrientationChanged: {
             delayedEnsureVisible.start()
             fade.start()
             scroll.start()
         }
    }

    QtObject {
        id: privy
        // TODO: More consistent minimum width for empty TextArea than 20 * " " on current font?
        property real minImplicitWidth: placeholder.text ? placeholder.model.paintedWidth
                                                         : privateStyle.textWidth("                    ", textEdit.font)

        function bg_postfix() {
            if (root.errorHighlight)
                return "error"
            else if (root.readOnly || !root.enabled)
                return "uneditable"
            else if (textEdit.activeFocus)
                return "highlighted"
            else
                return "editable"
        }
    }

    BorderImage {
        id: background
        anchors.fill: parent
        source: privateStyle.imagePath("qtg_fr_textfield_" + privy.bg_postfix())
        border {
            left: platformStyle.borderSizeMedium
            top: platformStyle.borderSizeMedium
            right: platformStyle.borderSizeMedium
            bottom: platformStyle.borderSizeMedium
        }
        smooth: true
    }

    Item {
        id: container

        property real verticalMargins:   container.anchors.leftMargin
                                       + container.anchors.rightMargin
                                       + flick.anchors.leftMargin
                                       + flick.anchors.rightMargin

        property real horizontalMargins:  container.anchors.topMargin
                                        + container.anchors.bottomMargin
                                        + flick.anchors.topMargin
                                        + flick.anchors.bottomMargin

        anchors {
            fill: parent
            leftMargin: platformStyle.paddingSmall; rightMargin: platformStyle.paddingSmall
            topMargin: platformStyle.paddingMedium; bottomMargin: platformStyle.paddingMedium
        }

        clip: true

        // TODO: Should placeholder also be scrollable?
        Text {
            id: placeholder
            objectName: "placeholder"

            // TODO: See TODO: Refactor implicit size...
            property variant model: Text {
                font: textEdit.font
                text: placeholder.text
                visible: false
                wrapMode: textEdit.wrapMode
                horizontalAlignment: textEdit.horizontalAlignment
                verticalAlignment: textEdit.verticalAlignment
                height: root.platformMaxImplicitHeight - container.horizontalMargins
                width: root.platformMaxImplicitWidth - container.verticalMargins
                opacity: 0
            }

            color: platformStyle.colorNormalMid
            font: textEdit.font
            horizontalAlignment: textEdit.horizontalAlignment
            verticalAlignment: textEdit.verticalAlignment
            visible: {
                if (text && (textEdit.paintedWidth == 0 && textEdit.paintedHeight <= textEdit.cursorRectangle.height))
                    return (readOnly || !textEdit.activeFocus)
                else
                    return false
            }
            wrapMode: textEdit.wrapMode
            x: flick.x; y: flick.y
            height: flick.height; width: flick.width
        }

        Flickable {
            id: flick

            property real tiny: Math.round(platformStyle.graphicSizeTiny / 2)

            function ensureVisible(rect) {
                if (Math.round(contentX) > Math.round(rect.x))
                    contentX = rect.x
                else if (Math.round(contentX + width) < Math.round(rect.x + rect.width))
                    contentX = rect.x + rect.width - width

                if (Math.round(contentY) > Math.round(rect.y))
                    contentY = rect.y
                else if (Math.round(contentY + height) < Math.round(rect.y + rect.height))
                     contentY = rect.y + rect.height - height
            }

            anchors {
                fill: parent
                leftMargin: tiny
                rightMargin: tiny
                topMargin: tiny / 2
                bottomMargin: tiny / 2
            }

            boundsBehavior: Flickable.StopAtBounds
            contentHeight: textEdit.model.paintedHeight
            contentWidth: textEdit.model.paintedWidth +
                         (textEdit.wrapMode == TextEdit.NoWrap ? textEdit.cursorRectangle.width : 0)
            interactive: root.enabled

            TextEdit {
                id: textEdit
                objectName: "textEdit"

                // TODO: See TODO: Refactor implicit size...
                property variant model: TextEdit {
                    font: textEdit.font
                    text: textEdit.text
                    horizontalAlignment: textEdit.horizontalAlignment
                    verticalAlignment: textEdit.verticalAlignment
                    wrapMode: textEdit.wrapMode
                    visible: false
                    opacity: 0
                    height: root.platformMaxImplicitHeight - container.horizontalMargins
                    width: root.platformMaxImplicitWidth - container.verticalMargins

                }
                enabled: root.enabled
                focus: true
                font { family: platformStyle.fontFamilyRegular; pixelSize: platformStyle.fontSizeMedium }
                color: platformStyle.colorNormalDark
                cursorVisible: activeFocus && !selectedText
                selectedTextColor: platformStyle.colorNormalLight
                selectionColor: platformStyle.colorTextSelection
                textFormat: TextEdit.AutoText
                wrapMode: TextEdit.Wrap
                // TODO: Use desktop text selection behaviour for now.
                selectByMouse: true
                height: flick.height
                width: flick.width
                // TODO: Make bug report?
                // Called too early (before TextEdit size is adjusted) delay ensureVisible call a bit
                onCursorRectangleChanged: delayedEnsureVisible.start()
                onActiveFocusChanged: {
                    if (activeFocus) {
                        horizontal.flash()
                        vertical.flash()
                        textEdit.openSoftwareInputPanel()
                    } else {
                        textEdit.closeSoftwareInputPanel()
                    }
                }
                onEnabledChanged: {
                    if (!enabled) {
                        select(0, 0)
                        // De-focusing requires setting focus elsewhere, in this case editor's parent
                        if (root.parent)
                            root.parent.forceActiveFocus()
                    }
                }

                TextTouchController {
                    id: touchController

                    anchors {
                        top: editor.top; topMargin: -container.horizontalMargins
                        left: editor.left; leftMargin: -container.verticalMargins
                    }
                    height: Math.max(root.height, flick.contentHeight + container.horizontalMargins * 2)
                    width: Math.max(root.width, flick.contentWidth + container.verticalMargins * 2)
                    editorScrolledX: flick.contentX - container.verticalMargins
                    editorScrolledY: flick.contentY - container.horizontalMargins
                    copyEnabled: textEdit.selectedText
                    cutEnabled: !textEdit.readOnly && textEdit.selectedText
                    // TODO: QtQuick 1.1 has textEdit.canPaste
                    pasteEnabled: !textEdit.readOnly
                    Component.onCompleted: flick.movementEnded.connect(touchController.flickEnded)
                    Connections { target: screen; onCurrentOrientationChanged: touchController.updateGeometry() }
                    Connections {
                        target: textEdit
                        onHeightChanged: touchController.updateGeometry()
                        onWidthChanged: touchController.updateGeometry()
                        onHorizontalAlignmentChanged: touchController.updateGeometry()
                        onVerticalAlignmentChanged: touchController.updateGeometry()
                        onWrapModeChanged: touchController.updateGeometry()
                        onFontChanged: touchController.updateGeometry()
                    }
                }


            }

            PropertyAnimation { id: fade; target: textEdit; property: "opacity"; from: 0; to: 1; duration: 250 }
            PropertyAnimation { id: scroll; target: flick; property: "contentY"; duration: 250 }
        }

        ScrollBar {
            id: vertical
            anchors {
                top: flick.top;
                topMargin: -flick.tiny / 2;
                right: flick.right;
            }
            flickableItem: flick
            interactive: false
            orientation: Qt.Vertical
            height: container.height
        }

        ScrollBar {
            id: horizontal
            anchors {
                left: flick.left;
                leftMargin: -flick.tiny;
                bottom: flick.bottom;
                rightMargin: vertical.opacity ? vertical.width : 0
            }
            flickableItem: flick
            interactive: false
            orientation: Qt.Horizontal
            width: container.width
        }

        Timer {
            id: delayedEnsureVisible
            interval: 1
            onTriggered: flick.ensureVisible(textEdit.cursorRectangle)
        }
    }
}
