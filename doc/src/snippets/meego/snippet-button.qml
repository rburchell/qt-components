/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/
//! [0]
import QtQuick 2.1
import com.nokia.meego 1.2
//![0]


Rectangle {

    width: 400; height: 650
    color: "lightblue"

    property string output

    Column {
        id: col

        spacing: 10
        anchors.margins: 100
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

//! [1]
        Button {
            id: buttondefault
            onClicked: output = text + " clicked"
        }
//! [1] //! [2]

        Button {
            id: button
            text: "Click Me!"
            onClicked: text = "Thank You!"
        }
//! [2] //! [3]

        Button {
            id: button1
            width: 200; height: 50
            text: "Checkable"
            checkable: true
            onClicked: output = text + " clicked"

        }
//! [3] //! [4]

        Button {
            id: button3
            width: 200; height: 50
            text: "Disabled"
            enabled: false
            onClicked: output = text + " clicked"
        }
//! [4] //! [5]

        Button {
            id: visibleSwitch
            text: "Visible switch"
            width: 250;
            checkable: true
            onClicked: {
                output = text + " clicked"
                button5.visible = !button5.visible
            }
        }
//! [5]
    }

//! [6]

        Button {
            id: button5
            width: 150; height: 150
            anchors.top: col.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 10
            text: "Visible"
            smooth: false
            visible: false
            onClicked: output = text + " clicked"
        }
//! [6]
    Text {
        id: outputText
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 30
        font.pointSize: 12
        text: output
    }
}

