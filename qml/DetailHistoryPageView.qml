import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {

    Rectangle {
        id: backgroundRec
        color: "#f5f5f5"
        width: parent.width
        height: parent.height
        Layout.alignment: Qt.AlignHCenter
    }

    RowLayout {
        Rectangle {
            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#f5f5f5"
            Text {
                x: 10
                verticalAlignment: Text.AlignBottom
                text: qsTr("历史记录")
                font.family: window.mFONT_FAMILY
                font.pointSize: 25
            }
        }

        Item {
            width: parent.width - 320
            height: 40
        }


        RowLayout {
            Layout.alignment: Qt.AlignRight
            MusicTextButton {
                width: 110
                height: 40
                text_: "刷新记录"
                // horizontalCenter: Qt.AlignHCenter
                onClicked: {
                    getHistory()
                }
            }

            MusicTextButton {
                width: 110
                height: 40
                text_: "清空记录"
                // horizontalCenter: Qt.AlignHCenter
                onClicked: {
                    clearHistory()
                }
            }
        }
    }

    MusicListView {
        id: historyListView
        onDeleteItem: deleteHistory(index)
    }

    Component.onCompleted: {
        getHistory();
    }

    Connections {
        id: flushHistoryList
        target: layoutBottomView
        onFlushHistory: {
            getHistory()
        }
    }

    function deleteHistory(index){
        var list =historySettings.value("history",[])
        if(list.length<index+1)return
        list.splice(index,1)
        historySettings.setValue("history",list)
        getHistory()
    }

    function getHistory() {
        historyListView.musicList_ = historySettings.value("history", [])
    }

    function clearHistory() {
        historySettings.setValue("history", [])
        getHistory();
    }
}

