import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

RowLayout {

    property int defaultindex: 0

    property var qmlList: [
        {icon:"recommend-white", value:"推荐内容", qml:"DetailRecommendPageView", menu: true},
        {icon:"cloud-white", value:"搜索音乐", qml:"DetailSearchPageView", menu: true},
        {icon:"local-white", value:"本地音乐", qml:"DetailLocalPageView", menu: true},
        {icon:"history-white", value:"播放历史", qml:"DetailHistoryPageView", menu: true},
        {icon:"favorite-big-white", value:"我喜欢的", qml:"DetailFavoritePageView", menu: true},
        {icon:"", value:"", qml:"DetailPlayListPageView", menu: false}
    ]

    spacing: 0

    Pane {
        Layout.preferredWidth: 200
        Layout.fillHeight: true
        padding: 0

        background: Rectangle {
            color: "#f5f5f5"
        }

        ColumnLayout {
            anchors.fill: parent

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 150
                MusicBorderImage {
                    anchors.centerIn: parent
                    height: 100
                    width: 100
                    borderRadius_: 100
                }
            }

            ListView {
                id: menuView
                x: 10
                width: parent.width
                height: parent.height
                Layout.fillWidth: true
                Layout.fillHeight: true
                // clip: true
                model: ListModel {
                    id:menuViewModel
                }
                delegate: menuViewDelegate
                highlight: highlight
                highlightFollowsCurrentItem: false
                focus: true
            }
        }

        Component {
            id: highlight
            Rectangle {
                x: 5
                z: menuView.z + 2
                width: 190
                height: 50
                radius: 10
                color: "#809c91f7"
                y: menuView.currentItem.y

                Behavior on y {
                    SpringAnimation {
                        spring: 2
                        damping: 0.2
                    }
                }
            }
        }

        Component {
            id: menuViewDelegate
            Rectangle {
                id: menuViewDelegateItem
                x: 5
                width: 190
                height: 50
                color: "#f5f5f5"
                radius: 10
                RowLayout {
                    anchors.fill: parent
                    anchors.centerIn: parent
                    spacing: 15
                    Item {
                        width: 30
                    }

                    Image {
                        // color: "black"
                        id: icons
                        source: "qrc:/images/" + icon
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: 20
                        smooth: true
                        visible: false
                    }

                    ColorOverlay {
                        Layout.alignment: Qt.AlignCenter
                        width: 20
                        height: 20

                        source: icons
                        color: "black"
                    }

                    Text {
                        text: value
                        Layout.fillWidth: true
                        height: 50
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 12
                        color: "#0e0e0e"
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        color = "#809c91f7"
                    }
                    onExited: {
                        color = "#f5f5f5"
                    }
                    onClicked: {
                        hidePlayList()

                        repeater.itemAt(menuViewDelegateItem.ListView.view.currentIndex).visible = false
                        menuViewDelegateItem.ListView.view.currentIndex = index

                        var loader = repeater.itemAt(index)
                        loader.visible = true
                        loader.source = qmlList[index].qml + ".qml"
                    }
                }
            }
        }

        Component.onCompleted: {
            menuViewModel.append(qmlList.filter(item => item.menu))
            var loader = repeater.itemAt(defaultindex)
            loader.visible = true
            loader.source = qmlList[defaultindex].qml + ".qml"
            menuView.currentIndex = defaultindex
        }
    }

    Repeater {
        id: repeater
        model: qmlList.length
        Loader {
            visible: false
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    function showPlayList(targetId, targetType = "10") {
        repeater.itemAt(menuView.currentIndex).visible = false
        var loader = repeater.itemAt(5)
        loader.visible = true
        loader.source = qmlList[5].qml + ".qml"
        loader.item.targetType = targetType
        loader.item.targetId = targetId
    }

    function hidePlayList() {
        repeater.itemAt(menuView.currentIndex).visible = true
        var loader = repeater.itemAt(5)
        loader.visible = false
    }
}
