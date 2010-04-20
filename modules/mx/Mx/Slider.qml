/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project on Trolltech Labs.
**
** $QT_BEGIN_LICENSE:LGPL-ONLY$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
** $QT_END_LICENSE$
**
****************************************************************************/
import Qt 4.7
import Components 1.0

Item {
    id: basicSlider;

    property variant sliderEdgeOffset: 6
    property alias value: model.value
    property alias inverted: model.inverted
    property alias minimum: model.minimumValue
    property alias maximum: model.maximumValue
    property alias tooltipText: tooltip.text

    height: 22
    width: 108

    Rectangle {
        id: sliderBase
        color: '#dadada'
        width: parent.width - 12
        x: 6
        anchors.verticalCenter: parent.verticalCenter
        height: 8

        Rectangle {
            id: sliderBar
            color: '#84dbf5'
            anchors.left: parent.left
            anchors.right: knob.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: 8
        }

        // XXX Maybe use image primitives rather than a real Button ?
        Button {
            id: knob
            x: model.position
            anchors.verticalCenter: parent.verticalCenter
            text: ""
            width: 22
            height: 16
        }

        MouseArea {
            id: grooveArea
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            height: 20
            onPressed: { model.setPosition(mouseX - knob.width/2); }
            hoverEnabled: tooltip.text;
        }

        MouseArea {
            id: knobArea
            anchors.fill: knob
            hoverEnabled: tooltip.text
            drag.target: knob
            drag.axis: "XAxis"
            drag.minimumX: -sliderEdgeOffset
            drag.maximumX: sliderBase.width - knob.width / 2 - sliderEdgeOffset
        }
    }

    RangeModel {
        id: model
        minimumValue: 0
        maximumValue: 100
        positionAtMinimum: -sliderEdgeOffset
        positionAtMaximum: sliderBase.width - knob.width / 2 - sliderEdgeOffset
        position: knob.x
    }

    TooltipLoader {
        id: tooltip;
        anchors.fill: parent;

        property bool pressDismiss: false;
        property bool containsMouse: grooveArea.containsMouse
                                  || knobArea.containsMouse
        property bool mousePressed: grooveArea.pressed
                                 || knobArea.pressed;
        property bool resetState: !containsMouse && !mousePressed

        // Dismiss on press
        onMousePressedChanged: {
            if (mousePressed)
                pressDismiss = true;
        }

        // Reset on leave and release
        // ### Ugly: We use this timer to debounce the value of this property when the
        //     mouse moves from one area to another
        onResetStateChanged: {
            if (resetState)
                dismissTimer.start();
        }
        Timer {
            id: dismissTimer;
            interval: 10;
            onTriggered: {
                // Condition for "onExited" event
                if (tooltip.resetState)
                    tooltip.pressDismiss = false;
            }
        }

        shown: containsMouse && !pressDismiss;
    }
}
