import QtQml 2.12
import QtQuick.Layouts 1.12
import QtQuick 2.12
import QtQuick.Controls 2.12

Item {

    property alias list_: gridRepeater.model


    Grid {
        id: gridLayout
        anchors.fill: parent
        columns: 5
        Repeater {
            id: gridRepeater
            Pane {
                padding: 3
                width: parent.width * 0.333
                height: parent.width * 0.1
                background: Rectangle {
                    id: background
                    color: "#f5f5f5"
                }
                clip: true

                RoundImage {
                    id: image
                    width: parent.width * 0.25
                    height: parent.height
                    imgSrc: modelData.album.picUrl
                }

                Text {
                    id: name
                    anchors {
                        left: image.right
                        verticalCenter: parent.verticalCenter
                        bottomMargin: 10
                        leftMargin: 5
                    }
                    width: parent.width * 0.72
                    height: 30
                    text: modelData.album.name
                    font.pointSize: 11
                    font.family: window.mFONT_FAMILY

                    elide: Qt.ElideMiddle
                }

                Text{
                    anchors {
                        left: image.right
                        top: name.bottom
                        leftMargin: 5
                    }
                    width: parent.width * 0.72
                    height: 30
                    text: modelData.artists[0].name
                    font.family: window.mFONT_FAMILY
                    elide: Qt.ElideRight
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        background.color = "#50000000"
                    }
                    onExited: {
                        background.color = "#f5f5f5"
                    }

                }
            }
        }
    }
}
