import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    property alias lyrics_: listView.model
    property alias current_: listView.currentIndex

    id: lyricView

    color: "#f5f5f5"

    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: parent.height * 0.8

    clip: true

    ListView {
        id: listView
        anchors.fill: parent
        model: ["暂无歌词", "暂无歌词", "暂无歌词", "暂无歌词", "暂无歌词", "暂无歌词"]
        delegate: listDelegate

        highlight: highlight
        focus: true

        preferredHighlightBegin: parent.height / 2
        preferredHighlightEnd: parent.height / 2
        highlightRangeMode: ListView.StrictlyEnforceRange
    }

    Component {
        id: highlight
        Rectangle {
            x: 5
            z: listView.z + 2
//            width: 190
            height: 50
            radius: 10
            color: "#2073a7db"
//            color: "red"
            y: listView.currentIndex * 50

            Behavior on y {
                SpringAnimation {
                    spring: 0
                    damping: 0.2
                }
            }
        }
    }

    Component {
        id: listDelegate
        Item {
            id: delegateItem
            width: parent.width
            height: 50

            Text {
                text: modelData
                anchors.centerIn: parent
                color: index === listView.currentIndex ? "black" : "#505050"
                font {
                    family: window.mFONT_FAMILY
                    pointSize: 12
                }
            }

            states: State {
                when: delegateItem.ListView.isCurrentItem
                PropertyChanges {
                    target: delegateItem
                    scale: 1.2
                }
            }

            MouseArea {
                anchors.fill: parent
                onCanceled: listView.currentIndex = index
            }
        }
    }
}
