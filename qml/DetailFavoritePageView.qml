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
                text: qsTr("我的收藏")
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
                    getFavorite()
                }
            }

            MusicTextButton {
                width: 110
                height: 40
                text_: "清空记录"
                // horizontalCenter: Qt.AlignHCenter
                onClicked: {
                    clearFavorite()
                }
            }
        }
    }

    MusicListView {
        id: favoriteListView
        favoritable: false
        onDeleteItem: deleteFavorite(index)
    }

    Component.onCompleted: {
        getFavorite()
    }

    Connections {
        id: flushFavoriteListConnection
        target: layoutBottomView
        onFlushFavorite: {
            getFavorite()
        }
    }

    function deleteFavorite(index){
        var list =favoriteSettings.value("favorite",[])
        if(list.length<index+1)return
        list.splice(index,1)
        favoriteSettings.setValue("favorite",list)
        getFavorite()
    }

    function getFavorite(){
        favoriteListView.musicList_ = favoriteSettings.value("favorite",[])
    }

    function clearFavorite(){
        favoriteSettings.setValue("favorite", [])
        getFavorite()
    }

}

