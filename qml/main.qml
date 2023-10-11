import QtQuick 2.12
import QtMultimedia 5.12
import Qt.labs.settings 1.1
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import MyUtil 1.0

Window {
    id: window

    property int mWINDOW_WIDTH: 1200
    property int mWINDOW_HEIGHT: 800

    property string mFONT_FAMILY: "微软雅黑"

    width: 1200
    height: 800
    visible: true
//    flags: Qt.Window | Qt.FramelessWindowHint
    title: qsTr("Demo Cloud Music Player")



    Rectangle {
        anchors.fill: parent
        radius: 20
    }

    HttpUtil {
        id: httputil
    }

    Settings {
        id: settings
        fileName: "conf/settings.ini"
    }

    Settings{
        id:historySettings
        fileName: "conf/history.ini"
    }

    Settings{
        id:favoriteSettings
        fileName: "conf/favorite.ini"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 顶部工具栏
        LayoutHeaderView {
            id: layoutHeaderView
            visible: false
        }

        PageHomeView {
            id: pageHomeView
        }

        PageDetailView {
            id: pageDetailView
            visible: false
        }

        // 底部工具栏
        LayoutBottomView {
            id: layoutBottomView
        }
    }

    // 音乐播放
    MediaPlayer {
        id: mediaPlayer

        property var times_: []


        onPlaybackStateChanged: {
            if(playbackState !== MediaPlayer.PlayingState) {
                layoutBottomView.playingState_ = false
                return
            }
            layoutBottomView.playingState_ = true
        }

        onPositionChanged: {
            layoutBottomView.setSlider(0, duration, mediaPlayer.position)
            if(times_.length > 0) {
                var count = times_.filter(time => time < position).length
                pageDetailView.current_ = (count === 0) ? 0 : count - 1
            }
        }
    }

    Connections {
        id: mediaPlayerConnection
        target: layoutBottomView
        //        function onFinished() {
        //            layoutBottomView.playNext(layoutBottomView.currentMode_ === 0)
        //            mediaPlayer.play()
        //        }
        onFinished: {
            layoutBottomView.playNext(layoutBottomView.currentMode_ === 0)
            mediaPlayer.play()
        }
    }

}

