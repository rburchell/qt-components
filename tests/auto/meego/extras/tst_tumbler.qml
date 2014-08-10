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

import QtQuick 1.1
import QtQuickTest 1.0
import com.nokia.meego 1.1

Item {
    width: 600
    height: 600

    ListModel {
        id: model
        ListElement { value: "A" }
        ListElement { value: "B" }
        ListElement { value: "C" }
        ListElement { value: "D" }
        ListElement { value: "E" }
    }

    TumblerColumn {
        id: aColumn
        items: model
        label: "a"
        selectedIndex: 0
        enabled: true
    }

    TumblerColumn {
        id: bColumn
        items: model
        label: "b"
        selectedIndex: 0
        enabled: false
    }

    Tumbler {
        id: tb
        columns: [ aColumn, bColumn ]

        Component.onCompleted: {
            test1.when = true;
        }
    }

    SignalSpy {
        id: spy
        target: tb
        signalName: "changed"
    }

    TestCase {
        id: test1
        name: "Tumbler"
        when: false

        function test_selected() {
            compare(tb.columns[0].selectedIndex, 0);
            compare(tb.columns[1].selectedIndex, 0);

            // changing columns
            aColumn.selectedIndex = 2;
            bColumn.selectedIndex = 4;
            compare(tb.columns[0].selectedIndex, 2);
            compare(tb.columns[1].selectedIndex, 4);
        }

        function test_property_enabled() {
            compare(tb.columns[0].enabled, true);
            compare(tb.columns[1].enabled, false);

            bColumn.enabled = true;

            compare(tb.columns[0].enabled, true);
            compare(tb.columns[1].enabled, true);
        }

        function test_property_labels() {
            // labels can only be set at creation time!
            compare(tb.columns[0].label, "a");
            compare(tb.columns[1].label, "b");
        }

        function test_property_selectedItems() {
            // selectedItems can only be set at creation time!
            compare(tb.columns[0].selectedIndex, 0);
            compare(tb.columns[1].selectedIndex, 0);
        }

        function test_property_items() {
            // items can only be set at creation time!
            compare(tb.columns[0].items, model);
            compare(tb.columns[1].items, model);
        }

        function test_signal_changed() { // common api
            compare(spy.count, 0);
            tb.changed(3);
            compare(spy.count, 1);
        }
    }
}
