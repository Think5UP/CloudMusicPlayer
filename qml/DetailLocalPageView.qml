import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import Qt.labs.platform 1.0
import Qt.labs.settings 1.1

ColumnLayout {

    Settings {
        id: localSetting
        fileName: "conf/local.ini"
    }

    Rectangle {
        id: backgroundRec
        color: "#f5f5f5"
        width: parent.width
        height: parent.height
        Layout.alignment: Qt.AlignHCenter
    }

    Rectangle {
        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#f5f5f5"
        RowLayout {
            Text {
                x: 10
                verticalAlignment: Text.AlignBottom
                text: qsTr("本地音乐")
                font.family: window.mFONT_FAMILY
                font.pointSize: 25
            }

            Item {
                width: parent.width - 320
                height: 40
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                MusicTextButton {
                    id: importFile
                    width: 110
                    height: 40
                    text_: "导入音乐"
                    // horizontalCenter: Qt.AlignHCenter
                    onClicked:fileDialog.open()
                }

                MusicTextButton {
                    width: 110
                    height: 40
                    text_: "刷新列表"
                    // horizontalCenter: Qt.AlignHCenter
                    onClicked: {
                        getLocal()
                    }
                }
            }
        }
    }
    MusicListView {
        id: localListView
        onDeleteItem: deleteLocal(index)
    }

    Component.onCompleted:  {
         getLocal()
    }

    function deleteLocal(index){
           var list =localSettings.value("local",[])
            if(list.length<index+1)return
            list.splice(index,1)
            saveLocal(list)
        }

    function getLocal() {
        var list = []
        list = localSetting.value("local", [])
        localListView.musicList_ = list
        return list
    }

    function saveLocal(list = []) {
        localSetting.setValue("local", list)
        getLocal()
    }

//    Connections {
//        id: importFileConnections
//        target: importFile
//        function onClicked() {
//            fileDialog.open()
//        }
//    }


    FileDialog {
        id: fileDialog
        fileMode: FileDialog.OpenFiles
        nameFilters: ["MP3 Music Files(*.mp3)","FLAC MUsic Files(*.flac)"]
        folder: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
        acceptLabel: "确定"
        rejectLabel: "取消"

        onAccepted: {
            var list = localListView.musicList_
            // var list = []
            for(var index in files){
                var path = files[index] + ""

                var arr = path.split("/")

                var fileNameArr = arr[arr.length-1].split(".")
                //去掉后缀
                fileNameArr.pop()
                var fileName = fileNameArr.join(".")
                //歌手-名称.mp3
                var nameArr = fileName.split("-")
                var name = ""
                var artist = ""
                if(nameArr.length > 1){
                    name = nameArr[0]
                    nameArr.shift()
                }
                artist = nameArr.join("-")
                if(list.filter(item => item.id === path).length < 1) {
                    list.push({
                                  id:path+"",
                                  name,
                                  artist,
                                  type: "local",
                                  url:path+"",
                                  album:"本地音乐",
                              })
//                    var str = qsTr("id:" + (path + "") + "," + "name:" + name + "," + "artist:" + artist + "," + "type:" + "local" + "," + "url:" + (path + "") + "," + "album:" + "本地音乐")
//                    localSetting.setValue("local", str)
                }
                saveLocal(list)
                localListView.musicList_ = list
            }
        }
    }
}

