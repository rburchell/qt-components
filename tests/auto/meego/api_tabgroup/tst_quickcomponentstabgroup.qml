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

import QtQuick 2.1
import com.nokia.meego 1.2

Item {
    id: container
    
    property string currentTabName: tabGroup.currentTab==undefined? "0" : tabGroup.currentTab.objectName
  
    TabGroup {
        id: tabGroup
        currentTab: tabPage1
        
        Page {
          id:tabPage1
          objectName: "tabPage1"
        }
        
        Page {
          id:tabPage2
          objectName: "tabPage2"
        }
        
        Page {
          id:tabPage3
          objectName: "tabPage3"
        }        
    }
    
    TabButton {
        id:tabButton1
        text:"TabButton1"
        tab:tabPage1
    }

    TabButton {
        id:tabButton2
        text:"TabButton2"
        tab:tabPage2
    }
    
    TabButton {
        id:tabButton3
        text:"TabButton3"
        tab:tabPage3
    }    
    
    function goToTab1() {
        tabButton1.clicked();
    }

    function goToTab2() {
        tabButton2.clicked();

    }
    
    function goToTab3() {
        tabButton3.clicked();
    }
    
    function amountOfTabs() {
        return tabGroup.children.length;
    }   
}
