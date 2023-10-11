import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout{

    property string name_: ""
    property string targetId: "-"
    property string targetType: "10"

    onTargetIdChanged: {
        if(targetType == "10") {
            loadAlbum()
        } else if(targetType == "1000"){
            loadPlayList()
        }
    }



    Rectangle {
        width: parent.width
        height: parent.height

        color: "#f5f5f5"
    }

    Rectangle {
        id: nameItem
        Layout.fillWidth: true

        width: parent.width
        height: 60
        color: "#f5f5f5"

        Text {
            x: 10
            verticalAlignment: Text.AlignBottom
            text: name_
            font.family: window.mFONT_FAMILY
            font.pointSize: 25
        }
    }

    Rectangle {
        id: rec
        visible: false
        Layout.fillWidth: true
        color: "transparent"
        height: parent.height / 2
    }

    Loading {
        id: loading
        visible: false
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    }

    RowLayout {
        width: parent.width
        height: 200

        RoundImage {
            id: playListCover
            width: 180
            height: 180
            Layout.leftMargin: 20
        }

        Item {
            id: descripctItem
            Layout.fillWidth: true
            height: parent.height

            Text {
                id: playListDesc
                anchors.centerIn: parent
                width: parent.width * 0.95

                font.family: window.mFONT_FAMILY
                font.pointSize: 14
                wrapMode: Text.WrapAnywhere

                maximumLineCount: 4
                lineHeight: 1.5

                elide: Text.ElideRight
            }
        }
    }

    MusicListView {
        id: playListView
        deletable: false
    }

    function loadAlbum() {
        if(targetId.length < 1) {
            console.log("targetId < 1")
            return
        }
        var url = "album?id=" + targetId
        loading.visible = true
        rec.visible = true
        nameItem.visible = false
        playListCover.visible = false
        descripctItem.visible = false
        playListView.visible = false
        function onReply(reply) {
            httputil.onReplySignal.disconnect(onReply)
            var album = JSON.parse(reply).album
            var songs = JSON.parse(reply).songs
            name = "-" + album.name
            playListCover.imgSrc = album.blurPicUrl
            playListDesc.text = album.description

            playListView.musicList_ = songs.map(item => {
                                                   return {
                                                       id: item.id,
                                                       name: item.name,
                                                       artist: item.ar[0].name,
                                                       album: item.al.name,
                                                       cover: item.al.picUrl
                                                   }
                                               })
            loading.visible = false
            rec.visible = false
            nameItem.visible = true
            playListCover.visible = true
            descripctItem.visible = true
            playListView.visible = true
        }
        httputil.onReplySignal.connect(onReply)
        httputil.httpConnect(url)
    }

    function check(songs) {
        if(songs.length > 0) {

        }
    }

    function loadPlayList() {
        if(targetId.length < 1) {
            console.log("targetId < 1")
            return
        }
        var url = "playlist/detail?id=" + targetId
        loading.visible = true
        rec.visible = true
        nameItem.visible = false
        playListCover.visible = false
        descripctItem.visible = false
        playListView.visible = false
        function onSongDetailReply(reply) {
            httputil.onReplySignal.disconnect(onSongDetailReply)
            var songs = JSON.parse(reply).songs

            playListView.musicList_ = songs.map(item => {
                                                   return {
                                                       id: item.id,
                                                       name: item.name,
                                                       artist: item.ar[0].name,
                                                       album: item.al.name,
                                                       cover: item.al.picUrl
                                                   }
                                               })
            loading.visible = false
            rec.visible = false
            nameItem.visible = true
            playListCover.visible = true
            descripctItem.visible = true
            playListView.visible = true
        }

        function onReply(reply) {
            httputil.onReplySignal.disconnect(onReply)
            var playlist = JSON.parse(reply).playlist
            name_ = playlist.name
            playListCover.imgSrc = playlist.coverImgUrl
            playListDesc.text = playlist.description

            var ids = playlist.trackIds.map(item => item.id).join(",")

            httputil.onReplySignal.connect(onSongDetailReply)
            httputil.httpConnect("song/detail?ids=" + ids)
        }
        // 先请求到歌单 然后根据trackId去请求到具体歌曲
        httputil.onReplySignal.connect(onReply)
        httputil.httpConnect(url)
    }
}
