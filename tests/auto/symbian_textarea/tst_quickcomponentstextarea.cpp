/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
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

#include <QtTest/QtTest>
#include <QGraphicsObject>
#include <QFont>
#include "tst_quickcomponentstest.h"

class tst_quickcomponentstextarea : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();
    void validateSymbianProperties();
    void defaultPropertyValues();
    void placeholderText();
    void placeholderTextAndPresetText();
    void placeholderTextAndReadOnly();
    void implicitSize();

private:
    QObject* m_componentObject;
    QScopedPointer<QDeclarativeView> m_view;
};

void tst_quickcomponentstextarea::initTestCase()
{
    QString errors;
    m_componentObject = tst_quickcomponentstest::createComponentFromFile("tst_quickcomponentstextarea.qml", &errors);
    QVERIFY2(m_componentObject, qPrintable(errors));

    m_view.reset(tst_quickcomponentstest::createDeclarativeView("tst_quickcomponentstextarea.qml"));
    QTest::qWaitForWindowShown(m_view.data());
    QVERIFY(m_view.data());
    QVERIFY(m_view->rootObject());
    QTRY_COMPARE(QApplication::activeWindow(), static_cast<QWidget *>(m_view.data()));
}

void tst_quickcomponentstextarea::validateSymbianProperties()
{
    QGraphicsObject* textArea = m_componentObject->findChild<QGraphicsObject*>("testTextArea");
    QVERIFY(textArea);
    QVariant property;

    //placeholderText
    property = textArea->property("placeholderText");
    QVERIFY(property.isValid());
    QVERIFY(property.canConvert(QVariant::String));

    // ImplicitHeight
    property = textArea->property("implicitHeight");
    QVERIFY(property.isValid());
    QVERIFY(property.canConvert(QVariant::Double));

    // ImplicitWidth
    property = textArea->property("implicitWidth");
    QVERIFY(property.isValid());
    QVERIFY(property.canConvert(QVariant::Double));

    // maxImplicitHeight
    property = textArea->property("maxImplicitHeight");
    QVERIFY(property.isValid());
    QVERIFY(property.canConvert(QVariant::Double));

    // maxImplicitWidth
    property = textArea->property("maxImplicitWidth");
    QVERIFY(property.isValid());
    QVERIFY(property.canConvert(QVariant::Double));
}

void tst_quickcomponentstextarea::defaultPropertyValues()
{
    QGraphicsObject* textArea = m_componentObject->findChild<QGraphicsObject*>("testTextArea");
    QVERIFY(textArea);
    QVariant property;

    // Font
    property = textArea->property("font");
    QCOMPARE(property.toString(), QString("Nokia Sans,-1,14,5,50,0,0,0,0,0"));

    // CursorPosition
    property = textArea->property("cursorPosition");
    int cursorPosition = property.toInt();
    QCOMPARE(cursorPosition, 0);

    // HorizontalAlignment
    property = textArea->property("horizontalAlignment");
    Qt::Alignment horizontalAlignment = static_cast<Qt::Alignment>(property.toInt());
    QCOMPARE(horizontalAlignment, Qt::AlignLeft);

    // VerticalAlignment
    property = textArea->property("verticalAlignment");
    Qt::Alignment verticalAlignment = static_cast<Qt::Alignment>(property.toInt());
    QCOMPARE(verticalAlignment, Qt::AlignTop);

    // ReadOnly
    property = textArea->property("readOnly");
    bool readOnly = property.toBool();
    QCOMPARE(readOnly, false);

    // SelectedText
    property = textArea->property("selectedText");
    QString selectedText = property.toString();
    QVERIFY(selectedText.isEmpty());

    // SelectionEnd
    property = textArea->property("selectionEnd");
    int selectionEnd = property.toInt();
    QCOMPARE(selectionEnd, 0);

    // SelectionStart
    property = textArea->property("selectionStart");
    int selectionStart = property.toInt();
    QCOMPARE(selectionStart, 0);

    // Text
    property = textArea->property("text");
    QString text = property.toString();
    QVERIFY(text.isEmpty());

    // TextFormat
    property = textArea->property("textFormat");
    Qt::TextFormat textFormat = static_cast<Qt::TextFormat>(property.toInt());
    QCOMPARE(textFormat, Qt::AutoText);

    // WrapMode
    property = textArea->property("wrapMode");
    QTextOption::WrapMode wrapMode = static_cast<QTextOption::WrapMode>(property.toInt());
    QCOMPARE(wrapMode, QTextOption::WrapAtWordBoundaryOrAnywhere);

    //placeholderText
    property = textArea->property("placeholderText");
    QString promptText = property.toString();
    QVERIFY(promptText.isEmpty());
}

void tst_quickcomponentstextarea::placeholderText()
{
    QGraphicsObject* textArea = m_view->rootObject()->findChild<QGraphicsObject*>("testTextArea");
    QGraphicsObject *button = m_view->rootObject()->findChild<QGraphicsObject*>("testButton");
    QGraphicsObject *textEdit = m_view->rootObject()->findChild<QGraphicsObject*>("textEdit");
    QGraphicsObject *placeHolder = m_view->rootObject()->findChild<QGraphicsObject*>("placeholder");

    QVERIFY(textArea);
    QVERIFY(button);
    QVERIFY(textEdit);
    QVERIFY(placeHolder);

    textArea->setProperty("text", QString(""));
    textArea->setProperty("placeholderText", QString("placeholderText"));

    // Place holder should be visible
    QVERIFY(placeHolder->property("visible").toBool());
    QVERIFY(textEdit->property("visible").toBool());
    QCOMPARE(textArea->property("placeholderText").toString(), QString("placeholderText"));
    QCOMPARE(textArea->property("text").toString(), QString(""));

    // Focus textArea
    QTest::mouseClick(m_view->viewport(), Qt::LeftButton, 0, m_view->mapFromScene(textArea->scenePos()));
    QApplication::processEvents();

    QVERIFY(!placeHolder->property("visible").toBool());
    QVERIFY(textEdit->property("visible").toBool());
    QCOMPARE(textArea->property("placeholderText").toString(), QString("placeholderText"));
    QCOMPARE(textArea->property("text").toString(), QString(""));

    //Type something
    textArea->setProperty("text", QString("Test"));
    QVERIFY(!placeHolder->property("visible").toBool());
    QVERIFY(textEdit->property("visible").toBool());
    QCOMPARE(textArea->property("placeholderText").toString(), QString("placeholderText"));
    QCOMPARE(textArea->property("text").toString(), QString("Test"));

    // Focus another component
    QTest::mouseClick(m_view->viewport(), Qt::LeftButton, 0, m_view->mapFromScene(button->scenePos()));
    QApplication::processEvents();

    QVERIFY(!placeHolder->property("visible").toBool());
    QVERIFY(textEdit->property("visible").toBool());
    QCOMPARE(textArea->property("placeholderText").toString(), QString("placeholderText"));
    QCOMPARE(textArea->property("text").toString(), QString("Test"));

    // Focus back, empty text and focus out again
#ifdef Q_OS_SYMBIAN
    // To avoid virtual keyboard on symbian
    textArea->setProperty("readOnly", QVariant(true));
#endif
    QTest::mouseClick(m_view->viewport(), Qt::LeftButton, 0, m_view->mapFromScene(textArea->scenePos()));
    QApplication::processEvents();

    textArea->setProperty("text", QString(""));
    QTest::mouseClick(m_view->viewport(), Qt::LeftButton, 0, m_view->mapFromScene(button->scenePos()));
    QApplication::processEvents();

    QVERIFY(placeHolder->property("visible").toBool());
    QVERIFY(textEdit->property("visible").toBool());
    QCOMPARE(textArea->property("placeholderText").toString(), QString("placeholderText"));
    QCOMPARE(textArea->property("text").toString(), QString(""));
#ifdef Q_OS_SYMBIAN
    // To avoid virtual keyboard on symbian
    textArea->setProperty("readOnly", QVariant(false));
#endif

    // Empty prompt text
    textArea->setProperty("placeholderText", QString(""));
    QVERIFY(!placeHolder->property("visible").toBool());
    QVERIFY(textEdit->property("visible").toBool());
    QCOMPARE(textArea->property("placeholderText").toString(), QString(""));
    QCOMPARE(textArea->property("text").toString(), QString(""));
}

void tst_quickcomponentstextarea::placeholderTextAndPresetText()
{
    QGraphicsObject* textArea = m_view->rootObject()->findChild<QGraphicsObject*>("testTextArea");
    QGraphicsObject *button = m_view->rootObject()->findChild<QGraphicsObject*>("testButton");
    QGraphicsObject *textEdit = m_view->rootObject()->findChild<QGraphicsObject*>("textEdit");
    QGraphicsObject *placeHolder = m_view->rootObject()->findChild<QGraphicsObject*>("placeholder");

    QVERIFY(textArea);
    QVERIFY(button);
    QVERIFY(textEdit);
    QVERIFY(placeHolder);

    textArea->setProperty("text", QString("Preset text here."));
    textArea->setProperty("placeholderText", QString("placeholderText"));

    // Preset text should displayed
    QVERIFY(!placeHolder->property("visible").toBool());
    QVERIFY(textEdit->property("visible").toBool());
    QCOMPARE(textArea->property("placeholderText").toString(), QString("placeholderText"));
    QCOMPARE(textArea->property("text").toString(), QString("Preset text here."));

    // Focus textArea
    QTest::mouseClick(m_view->viewport(), Qt::LeftButton, 0, m_view->mapFromScene(textArea->scenePos()));
    QApplication::processEvents();

    QVERIFY(!placeHolder->property("visible").toBool());
    QVERIFY(textEdit->property("visible").toBool());
    QCOMPARE(textArea->property("placeholderText").toString(), QString("placeholderText"));
    QCOMPARE(textArea->property("text").toString(), QString("Preset text here."));

    // Focus out
    QTest::mouseClick(m_view->viewport(), Qt::LeftButton, 0, m_view->mapFromScene(button->scenePos()));
    QApplication::processEvents();

    QVERIFY(!placeHolder->property("visible").toBool());
    QVERIFY(textEdit->property("visible").toBool());
    QCOMPARE(textArea->property("placeholderText").toString(), QString("placeholderText"));
    QCOMPARE(textArea->property("text").toString(), QString("Preset text here."));

    // Focus back and empty text and focus out again
#ifdef Q_OS_SYMBIAN
    // To avoid virtual keyboard on symbian
    textArea->setProperty("readOnly", QVariant(true));
#endif
    QTest::mouseClick(m_view->viewport(), Qt::LeftButton, 0, m_view->mapFromScene(textArea->scenePos()));
    QApplication::processEvents();

    textArea->setProperty("text", QString(""));

    QTest::mouseClick(m_view->viewport(), Qt::LeftButton, 0, m_view->mapFromScene(button->scenePos()));
    QApplication::processEvents();

    QVERIFY(placeHolder->property("visible").toBool());
    QVERIFY(textEdit->property("visible").toBool());
    QCOMPARE(textArea->property("placeholderText").toString(), QString("placeholderText"));
    QCOMPARE(textArea->property("text").toString(), QString(""));
#ifdef Q_OS_SYMBIAN
    // To avoid virtual keyboard on symbian
    textArea->setProperty("readOnly", QVariant(false));
#endif

    // Empty prompt text
    textArea->setProperty("placeholderText", QString(""));
    QVERIFY(!placeHolder->property("visible").toBool());
    QVERIFY(textEdit->property("visible").toBool());
    QCOMPARE(textArea->property("placeholderText").toString(), QString(""));
    QCOMPARE(textArea->property("text").toString(), QString(""));
}

void tst_quickcomponentstextarea::placeholderTextAndReadOnly()
{
    QGraphicsObject* textArea = m_view->rootObject()->findChild<QGraphicsObject*>("testTextArea");
    QGraphicsObject *button = m_view->rootObject()->findChild<QGraphicsObject*>("testButton");
    QGraphicsObject *textEdit = m_view->rootObject()->findChild<QGraphicsObject*>("textEdit");
    QGraphicsObject *placeHolder = m_view->rootObject()->findChild<QGraphicsObject*>("placeholder");

    QVERIFY(textArea);
    QVERIFY(button);
    QVERIFY(textEdit);
    QVERIFY(placeHolder);

    textArea->setProperty("text", QString(""));
    textArea->setProperty("placeholderText", QString("placeholderText"));
    textArea->setProperty("readOnly", QVariant(true));

    // Prompt should be visible
    QVERIFY(placeHolder->property("visible").toBool());
    QVERIFY(textEdit->property("visible").toBool());
    QCOMPARE(textArea->property("placeholderText").toString(), QString("placeholderText"));
    QCOMPARE(textArea->property("text").toString(), QString(""));

    // Focus textArea
    QTest::mouseClick(m_view->viewport(), Qt::LeftButton, 0, m_view->mapFromScene(textArea->scenePos()));
    QApplication::processEvents();

    QVERIFY(placeHolder->property("visible").toBool());
    QVERIFY(textEdit->property("visible").toBool());
    QCOMPARE(textArea->property("placeholderText").toString(), QString("placeholderText"));
    QCOMPARE(textArea->property("text").toString(), QString(""));
}

void tst_quickcomponentstextarea::implicitSize()
{
    QGraphicsObject* textArea = m_componentObject->findChild<QGraphicsObject*>("testTextArea");
    QVERIFY(textArea);

    QFontMetricsF metrics(textArea->property("font").value<QFont>());
    qreal parentHeight = m_componentObject->property("height").toDouble();
    qreal parentWidth = m_componentObject->property("width").toDouble();
    qreal implicitHeight = textArea->property("implicitHeight").toDouble();
    qreal implicitWidth = textArea->property("implicitWidth").toDouble();
    qreal maxImplicitHeight = textArea->property("maxImplicitHeight").toDouble();
    qreal maxImplicitWidth = textArea->property("maxImplicitWidth").toDouble();

    QVERIFY(implicitHeight >= metrics.height());
    QVERIFY(implicitWidth >= metrics.width("                    "));
    QCOMPARE(maxImplicitHeight, parentHeight);
    QCOMPARE(maxImplicitWidth, parentWidth);

    textArea->setProperty("text", QString("TestString"));
    implicitHeight = textArea->property("implicitHeight").toDouble();
    implicitWidth = textArea->property("implicitWidth").toDouble();

    QVERIFY(implicitHeight >= metrics.height());
    QVERIFY(implicitWidth >= metrics.width("TestString"));

    // Type over parent width
    do {
        textArea->setProperty("text", textArea->property("text").toString() + QString("Aaaaaa"));
        implicitWidth = textArea->property("implicitWidth").toDouble();
    } while (implicitHeight <= metrics.height());

    // Type some more
    textArea->setProperty("text", textArea->property("text").toString() + QString("Aaaaaa"));
    QVERIFY(implicitWidth <= maxImplicitWidth);

    // Type until parent height
    do {
        textArea->setProperty("text", textArea->property("text").toString() + QString("Aaaaaaaaaa"));
        implicitHeight = textArea->property("implicitHeight").toDouble();
        QVERIFY(implicitHeight >= metrics.height());
    } while (implicitHeight < maxImplicitHeight);

    // Type some more
    textArea->setProperty("text", textArea->property("text").toString() + QString("A"));
    QCOMPARE(implicitHeight, maxImplicitHeight);
}

QTEST_MAIN(tst_quickcomponentstextarea)

#include "tst_quickcomponentstextarea.moc"
