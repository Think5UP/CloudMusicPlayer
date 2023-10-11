import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12


Item {

    property string name_: "1"
    property string artist_: "1"
    property string imgSource_: "qrc:/images/player"

    property alias lyricsList_: lyricView.lyrics_
    property alias lyrics_: lyricView.lyrics_
    property alias current_ : lyricView.current_

    Layout.fillWidth: true
    Layout.fillHeight: true

    Rectangle {
        anchors.fill: parent

        color: "#f5f5f5"
    }

    RowLayout {
        anchors.fill: parent
        Pane {
            Layout.preferredWidth: parent.width * 0.4
            Layout.fillHeight: true
            Layout.fillWidth: true

            background: Rectangle {
                color: "#f5f5f5"
            }

            Text {
                id: name
                anchors {
                    bottom: artist.top
                    bottomMargin: 20
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                font.family: window.mFONT_FAMILY
                font.pointSize: 16
            }

            Text {
                id: artist
                anchors {
                    bottom: cover.top
                    bottomMargin: 20
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                font.family: window.mFONT_FAMILY
                font.pointSize: 14
            }

            MusicBorderImage {
                id: cover
                anchors.centerIn: parent
                width: parent.width * 0.6
                height: width
                borderRadius_: width

                rotating_: layoutBottomView.playingState_

                imgSrc: imgSource_
            }

            Text {
                id: lyric
                anchors {
                    top: cover.bottom
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                visible: layoutHeaderView.smallWindow_

                text: lyricView.lyrics_[lyricView.current_] ? lyricView.lyrics_[lyricView.current_] : "暂无歌词"
                font.family: window.mFONT_FAMILY
                font.pointSize: 14
            }
        }

        Pane {

            visible: !layoutHeaderView.smallWindow_

            background: Rectangle {
                color: "#f5f5f5"
            }
            Layout.preferredWidth: parent.width * 0.6 - 5
            Layout.fillHeight: true

            MusicLyricView {
                id: lyricView
                anchors.fill: parent
            }
        }

    }
    onImgSource_Changed: {
        name.text = name_
        artist.text = artist_
        cover.imgSrc = imgSource_
    }

}
