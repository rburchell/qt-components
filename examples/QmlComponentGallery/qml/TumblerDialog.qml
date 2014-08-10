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

import QtQuick 2.0
import com.nokia.meego 1.2

Page {
    id: container
    anchors.margins: UiConstants.DefaultMargin
    tools: commonTools

    Item {
        anchors {
            margins: 16
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        TumblerButton {
            id: tumblerButton
            anchors.top: parent.top
            anchors.topMargin: 10
            width: 206
            text: "Open Tumbler"
            onClicked: launchDialog()
        }
    }

    function launchDialog() {
        console.log("main::launchDialog");
        tDialog.open();
    }

    function callbackFunction() {
        tumblerButton.text =
            dayList.get(dayColumn.selectedIndex).value + " " +
            monthList.get(monthColumn.selectedIndex).value + " " +
            yearList.get(yearColumn.selectedIndex).value;
    }

    TumblerDialog {
        id: tDialog
        titleText: "Date of birth"
        acceptButtonText: "Ok"
        rejectButtonText: "Cancel"
        columns: [ dayColumn, monthColumn, yearColumn ]
        onAccepted: callbackFunction()
    }

    function initializeDataModels() {
        for (var year = 2000; year <= 2020; year++) {
            yearList.append({"value" : year});
        }

        for (var day = 1; day <= 31; day++) {
            dayList.append({"value" : day});
        }
    }

    Component.onCompleted: {
        initializeDataModels();
    }

    TumblerColumn {
        id: dayColumn
        items: ListModel { id: dayList }
        label: "DAY"
        selectedIndex: 21
    }

    TumblerColumn {
        id: monthColumn
        items: ListModel {
            id: monthList
            ListElement { value: "Jan" }
            ListElement { value: "Feb" }
            ListElement { value: "Mar" }
            ListElement { value: "Apr" }
            ListElement { value: "May" }
            ListElement { value: "Jun" }
            ListElement { value: "Jul" }
            ListElement { value: "Aug" }
            ListElement { value: "Sep" }
            ListElement { value: "Oct" }
            ListElement { value: "Nov" }
            ListElement { value: "Dec" }
        }
        label: "MONTH"
        selectedIndex: 9
    }

    TumblerColumn {
        id: yearColumn
        items: ListModel { id: yearList }
        label: "YEAR"
        selectedIndex: 10
    }
}
