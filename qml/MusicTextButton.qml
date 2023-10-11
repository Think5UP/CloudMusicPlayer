import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Item {

    property alias text_: mytext.text

    id : mybutton
    width: 110
    height: 40

    signal clicked();

    //    Rectangle {
    //        id : bgrect;
    //        y : 20
    //        x : 1
    //        color: "#dedede";
    //        width: mybutton.width - 2;
    //        height: mybutton.height - 25
    //        radius: height / 2
    //    }

    //    DropShadow {
    //        id : shadow
    //        anchors.fill: bgrect
    //        horizontalOffset: 1
    //        verticalOffset: 12
    //        radius: 8.0
    //        // samples: 17
    //        color: "#dedede"
    //        source: bgrect
    //    }

//    Rectangle {
//        id: shadow
//        anchors.centerIn: parent
//        width: mybutton + 4
//        height: mybutton + 4
//        color: "#e3e3e3"
//        radius: height / 2
//    }


    Rectangle{
        id : toprect
        color: "#dedede"
        width: mybutton.width;
        height: mybutton.height - 2
        radius: height / 2

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled : true
            onClicked: {
                seqAnimation.start();
                mybutton.clicked();
            }
            onEntered: {
                numAnimation.start()
                toprect.color = "#aea2fa";
                //                bgrect.color = "#a299f7";
                // shadow.color = "#a096f7"
                mytext.color = "white"
            }
            onExited: {
                backAnimation.start()
                toprect.color = "#dedede";
                //                bgrect.color = "#dedede";
                // shadow.color = "#dedede"
                mytext.color = "black"
            }

        }

    }

    Text {
        id: mytext
        anchors.centerIn: toprect
        color: "black"
        font.pixelSize : toprect.height/2
    }

    NumberAnimation {
        id: numAnimation
        target: toprect
        property: "y"
        to: toprect.y - 10
        duration: 100
    }

    NumberAnimation {
        id: backAnimation
        target: toprect
        property: "y"
        to: 0
        duration: 100
    }


    SequentialAnimation {
        id : seqAnimation
        NumberAnimation {
            target: toprect;
            property: "y";
            to: toprect.y + 2;
            duration: 100
        }
        NumberAnimation {
            target: toprect;
            property: "y";
            to: toprect.y - 2;
            duration: 100
        }
    }


}
