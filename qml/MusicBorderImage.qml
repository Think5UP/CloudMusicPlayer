import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Rectangle {
    property string imgSrc: "qrc:/images/player"
    property int borderRadius_: 5

    property real rotationAngel_: 0.0
    property bool rotating_: false

    radius: borderRadius_

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: "#101010"
        }

        GradientStop {
            position: 0.5
            color: "#a0a0a0"
        }

        GradientStop {
            position: 1.0
            color: "#505050"
        }
    }

    Image{
        id: image
        anchors.centerIn: parent
        asynchronous: true
        source: imgSrc
        smooth: true
        visible: false
        width: parent.width * 0.9
        height: parent.height * 0.9
        fillMode: Image.PreserveAspectCrop
        antialiasing: true
    }

    Rectangle{
        id:mask
        color: "black"
        anchors.fill: parent
        radius: borderRadius_
        visible: false
        smooth: true
        border.width: 20
        border.color: "#ffffff"
        antialiasing: true
    }

    OpacityMask{
        id: maskImage
        anchors.fill: image
        source: image
        maskSource: mask
        visible: true
        antialiasing: true
    }

    NumberAnimation {
        running: rotating_
        loops: Animation.Infinite
        target: maskImage
        from: rotationAngel_
        property: "rotation"
        to: 360 + rotationAngel_
        duration: 100000
        onStopped: {
            rotationAngel_ = maskImage.rotation
        }
    }
}
