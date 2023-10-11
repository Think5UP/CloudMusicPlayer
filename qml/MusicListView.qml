import QtQml 2.12
import QtQuick 2.12
import QtQuick.Shapes 1.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Pane {
    property var musicList_: []
    property int all: 0
    property int pageSize: 60
    property int currentPage: 0

    property bool favoritable: true
    property bool deletable: true

    signal loadMore(int offset, int current)
    signal deleteItem(int index)

    onMusicList_Changed: {

        listViewModel.clear()
        listViewModel.append(musicList_)
    }

    clip: true
    spacing: 0
    padding: 0
    Layout.fillWidth: true
    Layout.fillHeight: true


    background: Rectangle {
        color: "#f5f5f5"
    }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.bottomMargin: 70

        header: listViewHeader
        delegate: listViewDelegate

        highlight: highlight
        highlightMoveDuration: 0
        highlightResizeDuration: 0

        model: ListModel {
            id: listViewModel
        }

        ScrollBar.vertical: ScrollBar {
            anchors.right: parent.right
        }

        onCurrentSectionChanged: {
            console.log("1111");
        }

    }

    Component {
        id: highlight
        Rectangle {
            x: 5
            z: listView.z + 2
            // width: listView.width - 30
            height: 45
            radius: 10
            color: "#809c91f7"
            y: listView.currentIndex * 45

            Behavior on y {
                SpringAnimation {
                    spring: 2
                    damping: 0.2
                }
            }
        }
    }

    Component {
        id: listViewHeader

        Rectangle {
            color: "#f5f5f5"
            width: listView.width
            height: 45
            RowLayout {
                width: parent.width
                height: parent.height
                spacing: 15
                x: 5

                Text {
                    text: qsTr("序号")
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * 0.05
                    font.pointSize: 13
                    font.family: window.mFONT_FAMILY
                    color: "black"
                    elide: Qt.ElideRight
                }

                Text {
                    text: qsTr("歌名")
                    // horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * 0.3
                    font.pointSize: 13
                    font.family: window.mFONT_FAMILY
                    color: "black"
                    elide: Qt.ElideRight
                }

                Text {
                    text: qsTr("歌手")
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * 0.15
                    font.pointSize: 13
                    font.family: window.mFONT_FAMILY
                    color: "black"
                    elide: Qt.ElideRight
                }

                Text {
                    text: qsTr("专辑")
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * 0.25
                    font.pointSize: 13
                    font.family: window.mFONT_FAMILY
                    color: "black"
                    elide: Qt.ElideMiddle
                }

                Text {
                    text: qsTr("操作")
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * 0.15
                    font.pointSize: 13
                    font.family: window.mFONT_FAMILY
                    color: "black"
                    elide: Qt.ElideRight
                }
            }
        }
    }

    Component {
        id: listViewDelegate
        Rectangle {
            id: listViewDelegateItem
            width: listView.width - 25
            height: 45
            radius: 10
            color: "#f5f5f5"
            //            Shape {
            //                anchors.fill: parent
            //                ShapePath {
            //                    strokeColor: "#50000000"
            //                    strokeStyle: ShapePath.SolidLine
            //                    startX: 0
            //                    startY: 45
            //                    PathLine {
            //                        x: 0
            //                        y: 45
            //                    }
            //                    PathLine {
            //                        x: width
            //                        y: 45
            //                    }
            //                }
            //            }

            MouseArea {

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    color = "#ffffff"
                }
                onExited: {
                    color = "#f5f5f5"
                }
                onClicked: {
                    listViewDelegateItem.ListView.view.currentIndex = index
                }
                onDoubleClicked: {
                    layoutBottomView.playList_ = musicList_
                    layoutBottomView.current_ = index
                    listViewDelegateItem.ListView.view.currentIndex = index
                }

                RowLayout {
                    width: parent.width
                    height: parent.height
                    spacing: 15
                    x: 5

                    Text {
                        text: index + 1 + pageSize * currentPage
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width * 0.05
                        font.pointSize: 13
                        font.family: window.mFONT_FAMILY
                        color: "black"
                        elide: Qt.ElideRight
                    }

                    Text {
                        text: name
                        // horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width * 0.3
                        font.pointSize: 13
                        font.family: window.mFONT_FAMILY
                        color: "black"
                        elide: Qt.ElideRight
                    }

                    Text {
                        text: artist
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width * 0.15
                        font.pointSize: 13
                        font.family: window.mFONT_FAMILY
                        color: "black"
                        elide: Qt.ElideRight
                    }

                    Text {
                        text: album
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width * 0.25
                        font.pointSize: 13
                        font.family: window.mFONT_FAMILY
                        color: "black"
                        elide: Qt.ElideMiddle
                    }
                    Item {
                        Layout.preferredWidth: parent.width * 0.15
                        RowLayout {
                            anchors.centerIn: parent
                            MusicIconButton {
                                iconSource: "qrc:/images/pause"
                                iconWidth: 16
                                iconHeight: 16
                                toolTip: "播放"
                                onClicked: {
                                    // TODO: 播放
                                    layoutBottomView.playList_ = musicList_
                                    layoutBottomView.current_ = index
                                    listViewDelegateItem.ListView.view.currentIndex = index
                                }
                            }
                            MusicIconButton {
                                iconSource: "qrc:/images/favorite"
                                iconWidth: 16
                                iconHeight: 16
                                visible: favoritable
                                toolTip: "喜欢"
                                onClicked: {
                                    // TODO: 喜欢
                                    console.log("id: ", musicList_[index].id)
                                    layoutBottomView.saveFavorite(musicList_[index])
                                }
                            }
                            MusicIconButton {
                                iconSource: "qrc:/images/clear"
                                iconWidth: 16
                                iconHeight: 16
                                visible: deletable
                                toolTip: "删除"
                                onClicked: {
                                    // TODO: 删除
                                    deleteItem(index)
                                }
                            }
                        }
                    }
                }
            }
        }
    }


    Item {
        id: pageButton
        visible: (musicList_.length && all) ? true : false
        width: parent.width
        height: 40
        anchors.top: listView.bottom
        anchors.topMargin: 20

        ButtonGroup {
            buttons: buttons.children
        }
        RowLayout {
            id: buttons
            anchors.centerIn: parent
            Repeater {
                id: repeater
                model: all % pageSize ? all / pageSize + 1 : all / pageSize
                Button {
                    Text {
                        anchors.centerIn: parent
                        text: modelData + 1
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 14
                        color: checked ? "#497563" : "black"
                    }
                    background: Rectangle {
                        implicitWidth: 30
                        implicitHeight: 30
                        color: checked ? "#e2f0f8" : "#20e9f4ff"
                        radius: 3
                    }
                    checkable: true
                    checked: modelData === currentPage
                    onClicked: {
                        if(currentPage === index) return
                        currentPage = index
                        loadMore(currentPage * pageSize, index)
                    }
                }
            }
        }
    }



}
