import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
 import QtGraphicalEffects 1.0

ColumnLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true

    Rectangle {
        width: parent.width
        height: parent.height

        color: "#f5f5f5"
    }


    Rectangle {
        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#f5f5f5"
        Text {
            x: 10
            verticalAlignment: Text.AlignBottom
            text: qsTr("搜索音乐")
            font.family: window.mFONT_FAMILY
            font.pointSize: 25
        }
    }

    Item {
        width: parent.width
        height: 40

        Rectangle {

            width: parent.width
            height: parent.height

            radius: 10
            color: "#ffffff"


            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                MusicIconButton {
                    id: iconButton
                    width: 40
                    height: 40

                    iconSource: "qrc:/images/search"
                    toolTip: "搜索"
                    onClicked: {
                        doSearch()
                    }
                }

                TextField {
                    id: searchInput

                    color: "black"
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 14

                    selectByMouse: true
                    selectionColor: "gray"
                    placeholderText: qsTr("搜索音乐")
                    background: Rectangle {
                        color: "#ffffff"
                        opacity: 0.5
                        implicitWidth: 300
                        implicitHeight: 40

                        radius: 10
                        width: parent.hovered ? 350 : 300
                        height: parent.height

//                        LinearGradient {
//                            id: gradient
//                            anchors.fill: parent

//                            start: Qt.point(0, 0)
//                            end: Qt.point(parent.width, 0)

//                            gradient: Gradient {
//                                GradientStop { position: 0.0; color: "#caced7" }
//                                GradientStop { position: 1.0; color: "#e3dae3" }
//                            }
//                        }

                        Behavior on width {
                            NumberAnimation {
                                duration: 300 // 动画持续时间，单位为毫秒
                                easing.type: Easing.InOutQuad // 渐变效果
                            }
                        }
                    }
                    focus: true
                    Keys.onPressed:
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) doSearch()
                }
            }
        }
    }

    Loading {
        id: loading
        visible: false
        Layout.alignment: Qt.AlignHCenter
    }

    MusicListView {
        id: musicListView
        deletable: false
        onLoadMore: doSearch(offset, current)
        Layout.topMargin: 10
    }

    function doSearch (offset = 0, current = 0) {
        var keywords = searchInput.text
        if(keywords.length < 1) return
        loading.visible = true
        musicListView.visible = false
        function onReply(reply) {
            httputil.onReplySignal.disconnect(onReply)
            // console.log(reply)
            var result = JSON.parse(reply).result
            musicListView.currentPage = current
            var songsList = result.songs
            musicListView.all = result.songCount
            musicListView.musicList_ = songsList.map(item => {
                                                         return {
                                                             id: item.id,
                                                             name: item.name,
                                                             artist: item.artists[0].name,
                                                             album: item.album.name,
                                                             cover: ""
                                                         }
                                                     })
            loading.visible = false
            musicListView.visible = true
        }
        httputil.onReplySignal.connect(onReply)
        httputil.httpConnect("search?keywords=" + keywords + "&offset=" + offset + "&limit=60")
    }
}
