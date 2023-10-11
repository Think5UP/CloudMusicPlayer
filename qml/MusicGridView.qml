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
                padding: 5
                width: parent.width * 0.2
                height: parent.width * 0.25
                background: Rectangle {
                    id: background
                    color: "#f5f5f5"
                }
                clip: true

                RoundImage {
                    id: image
                    width: parent.width
                    height: parent.height - 40
                    imgSrc: modelData.coverImgUrl
                }

                Text {
                    anchors {
                        top: image.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    width: parent.width
                    height: contentHeight
                    text: modelData.name
                    font.family: window.mFONT_FAMILY
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                    elide: Qt.ElideMiddle
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
                    onClicked: {
                        var item = gridRepeater.model[index]

                        pageHomeView.showPlayList(item.id, "1000")
                    }
                }
            }
        }
    }
}
