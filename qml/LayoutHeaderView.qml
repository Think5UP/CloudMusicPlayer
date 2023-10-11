import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12

// 顶部工具栏
ToolBar {

    property point point_: Qt.point(x, y)
    property bool smallWindow_: false


    width: parent.width
    Layout.fillWidth: true;
    height: 32

    background: Rectangle {
        color: "#f5f5f5"
    }

    RowLayout {
        anchors.fill: parent

        MusicToolButton {
            iconSource: "qrc:/images/music"
            toolTip: "音乐"
        }

        MusicToolButton {
            iconSource: "qrc:/images/about"
            toolTip: "关于"

            onClicked: {
                aboutPop.open()
            }
        }

        Popup {
            id: aboutPop

            topInset: 0
            bottomInset: 0
            leftInset: -2
            rightInset: 0

            parent: Overlay.overlay
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2

            background: Rectangle {
                color: "#e9f4ff"
                radius: 5
                border.color: "#2273a7ab"
            }

            contentItem: ColumnLayout {
                width: parent.width
                height: parent.height
                Layout.alignment: Qt.AlignHCenter

                Image {
                    Layout.preferredHeight: 60
                    source: "qrc:/images/music"
                    Layout.fillWidth: true
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: qsTr("云音乐")
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 16
                    color: "#8573a7ab"
                    font.family: window.mFONT_FAMILY
                    font.bold: true
                }

                Text {
                    text: qsTr("this is a demo")
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 16
                    color: "#8573a7ab"
                    font.family: window.mFONT_FAMILY
                    font.bold: true
                }

                Text {
                    text: qsTr("think5uph@gmail.com")
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 16
                    color: "#8573a7ab"
                    font.family: window.mFONT_FAMILY
                    font.bold: true
                }
            }
        }

        MusicToolButton {
            id: smallwindow
            iconSource: "qrc:/images/small-window"
            toolTip: "小窗播放"
            visible: !smallWindow_
            onClicked: {
                setWindowSize(330, 650)
                smallWindow_ = true
                pageHomeView.visible = false
                pageDetailView.visible = true

            }
        }

        MusicToolButton {
            id: normalwindow
            iconSource: "qrc:/images/exit-small-window"
            toolTip: "退出小窗"
            visible: smallWindow_
            onClicked: {
                setWindowSize();
                smallWindow_ = false
                pageHomeView.visible = true
                pageDetailView.visible = false
            }
        }

        Item {
            Layout.fillWidth: true
            height: 32

            Text {
                anchors.centerIn: parent
                text: qsTr("")
                font.family: window.mFONT_FAMILY
                font.pointSize: 15
                color: "#ffffff"
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onPressed: setPoint(mouseX, mouseY)
                onMouseXChanged: moveX(mouseX)
                onMouseYChanged: moveY(mouseY)
            }
        }

        MusicToolButton {
            iconSource: "qrc:/images/minimize-screen"
            toolTip: "最小化"

            onClicked: {
                window.visibility = Window.Minimized
            }
        }

        MusicToolButton {
            id: fullScreen

            property bool statusOfScreen: true
            iconSource: "qrc:/images/full-screen"
            toolTip: "全屏"

            onClicked: {
                window.visibility = Window.Maximized
                fullScreen.visible = false
                exitFullScreen.visible = true
            }
        }

        MusicToolButton {
            id: exitFullScreen
            iconSource: "qrc:/images/small-screen"
            toolTip: "退出全屏"
            visible: false

            onClicked: {
                // setWindowSize()
                window.visibility = Window.AutomaticVisibility
                fullScreen.visible = true
                exitFullScreen.visible = false
            }
        }

        MusicToolButton {
            iconSource: "qrc:/images/power"
            toolTip: "关闭"

            onClicked: {
                Qt.quit()
            }
        }
    }

    function setWindowSize(width = window.mWINDOW_WIDTH, height = window.mWINDOW_HEIGHT) {
        window.width = width
        window.height = height
        window.x = (Screen.desktopAvailableWidth - window.width) / 2
        window.y = (Screen.desktopAvailableHeight - window.height) / 2
    }

    function setPoint(mouseX = 0, mouseY = 0) {
        point_ = Qt.point(mouseX, mouseY)
    }

    function moveX(mouseX = 0) {
        var x = window.x + mouseX - point_.x
        if(x<-(window.width-70)) x = - (window.width-70)
        if(x>Screen.desktopAvailableWidth-70) x = Screen.desktopAvailableWidth-70
        window.x = x
    }

    function moveY(mouseY = 0) {
        var y = window.y + mouseY-point_.y
        if(y<=0) y = 0
        if(y>Screen.desktopAvailableHeight-70) y = Screen.desktopAvailableHeight-70
        window.y = y
    }
}
