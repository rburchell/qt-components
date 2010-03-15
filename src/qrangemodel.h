/****************************************************************************
**
** Copyright (C) 2008-2009 Nokia Corporation and/or its subsidiary(-ies).
** Contact: Qt Software Information (qt-info@nokia.com)
**
** This file is part of the Qt Components project on Trolltech Labs.
**
** This file may be used under the terms of the GNU General Public
** License version 2.0 or 3.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of
** this file.  Please review the following information to ensure GNU
** General Public Licensing requirements will be met:
** http://www.fsf.org/licensing/licenses/info/GPLv2.html and
** http://www.gnu.org/copyleft/gpl.html.
**
** If you are unsure which license is appropriate for your use, please
** contact the sales department at qt-sales@nokia.com.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
****************************************************************************/

#ifndef QRANGEMODEL_H
#define QRANGEMODEL_H

#include <QtCore/qobject.h>
#include <QtGui/qgraphicsitem.h>
#include <QtGui/qabstractslider.h>
#include <QtDeclarative/qdeclarative.h>

class QRangeModelPrivate;

class QRangeModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int minimumValue READ minimum WRITE setMinimum NOTIFY rangeChanged)
    Q_PROPERTY(int maximumValue READ maximum WRITE setMaximum NOTIFY rangeChanged)
    Q_PROPERTY(int singleStep READ singleStep WRITE setSingleStep)
    Q_PROPERTY(int pageStep READ pageStep WRITE setPageStep)
    Q_PROPERTY(int value READ value WRITE setValue NOTIFY valueChanged USER true)
    Q_PROPERTY(int sliderPosition READ sliderPosition WRITE setSliderPosition NOTIFY sliderMoved)
    Q_PROPERTY(int position READ position WRITE setPosition NOTIFY positionChanged) // ###
    Q_PROPERTY(int minimumPosition READ minimumPosition WRITE setMinimumPosition NOTIFY positionRangeChanged) // ###
    Q_PROPERTY(int maximumPosition READ maximumPosition WRITE setMaximumPosition NOTIFY positionRangeChanged) // ###
    Q_PROPERTY(bool tracking READ hasTracking WRITE setTracking)
    Q_PROPERTY(Qt::Orientation orientation READ orientation WRITE setOrientation)
    Q_PROPERTY(bool invertedAppearance READ invertedAppearance WRITE setInvertedAppearance)
    Q_PROPERTY(bool invertedControls READ invertedControls WRITE setInvertedControls)
    Q_PROPERTY(bool sliderDown READ isSliderDown WRITE setSliderDown DESIGNABLE false)
    Q_PROPERTY(bool wrapping READ wrapping WRITE setWrapping)

public:
    QRangeModel(QAbstractSlider *widget = 0);
    QRangeModel(QGraphicsObject *graphicsObject);
    virtual ~QRangeModel();

    void sedate();
    void awake();

    Qt::Orientation orientation() const;

    void setMinimum(int);
    int minimum() const;

    void setMaximum(int);
    int maximum() const;

    void setRange(int min, int max);
    bool hasNullRange() const;  // min == max

    int bound(int val) const;

    void setSingleStep(int);
    int singleStep() const;

    void setPageStep(int);
    int pageStep() const;

    void setTracking(bool enable);
    bool hasTracking() const;

    void setSliderDown(bool);
    bool isSliderDown() const;

    void setSliderPosition(int);
    int sliderPosition() const;

    void setMinimumPosition(int);
    int minimumPosition() const;

    void setMaximumPosition(int);
    int maximumPosition() const;

    void setPositionRange(int min, int max);

    void setPosition(int position);
    int position() const;

    void setPressValue(int);
    int pressValue() const;

    void setInvertedAppearance(bool);
    bool invertedAppearance() const;

    void setInvertedControls(bool);
    bool invertedControls() const;

    void setWrapping(bool);
    bool wrapping() const;

    // Control property linked to the QStyle::SH_Slider_StopMouseOverSlider style hint.
    void setStopMouseOverSlider(bool);
    bool stopMouseOverSlider() const;

    void startRepeatActionTimer(int ms);
    bool repeatActionTimerActive() const;

    enum SliderAction {
        SliderNoAction,
        SliderSingleStepAdd,
        SliderSingleStepSub,
        SliderPageStepAdd,
        SliderPageStepSub,
        SliderToMinimum,
        SliderToMaximum,
        SliderMove
    };

    int value() const;

#ifdef QT_KEYPAD_NAVIGATION
    void saveValue();
#endif

    void triggerAction(SliderAction action);

public Q_SLOTS:
    void setValue(int);
    void setOrientation(Qt::Orientation);

Q_SIGNALS:
    void valueChanged(int value);

    void sliderPressed();
    void sliderMoved(int position);
    void sliderReleased();

    void positionChanged(int position);

    void rangeChanged(int min, int max);
    void positionRangeChanged(int min, int max);

    void actionTriggered(int action);

public:
    void setRepeatAction(SliderAction action, int thresholdTime = 500, int repeatTime = 50);
    SliderAction repeatAction() const;

    enum SliderChange {
        SliderRangeChange,
        SliderOrientationChange,
        SliderStepsChange,
        SliderValueChange
    };
    virtual void sliderChange(SliderChange change);

    void keyPressEvent(QEvent *ev);
    void timerEvent(QTimerEvent *);
#ifndef QT_NO_WHEELEVENT
    void wheelEvent(QEvent *e);
#endif
    void changeEvent(QEvent *e);

protected:
    QRangeModel(QRangeModelPrivate &dd, QObject *parent);

private:
    Q_DISABLE_COPY(QRangeModel)
    Q_DECLARE_PRIVATE(QRangeModel)

};

QML_DECLARE_TYPE(QRangeModel);

#endif // QRANGEMODEL_H
