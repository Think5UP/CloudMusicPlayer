import QtQuick 2.12
import QtMultimedia 5.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {

    property var playList_: []
    property int current_: -1

    property int sliderValue_: 0
    property int sliderStart_: 0
    property int sliderEnd_: 100

    property bool playingState_: false
    property int currentMode_: 0
    property var playModeList_: [{icon: "single-repeat", name: "单曲循环"}, {icon: "repeat", name: "单曲循环"}, {icon: "random", name: "随机播放"}]

    property string name_: " "
    property string artist_: " "
    // property string coverImage_: "qrc:/images/player"

    signal finished()

    signal flushHistory()
    signal flushFavorite()

    Layout.fillWidth: true
    height: 60
    color: "#ffffff"

    RowLayout {
        anchors.fill: parent

        Item {
            Layout.preferredWidth: parent.width/10
            Layout.fillWidth: true
        }

        RoundImage {
            id: musicCover
            width: 50
            height: 50

            visible: !layoutHeaderView.smallWindow_

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onPressed: {
                    musicCover.scale = 0.9
                }
                onReleased: {
                    musicCover.scale = 1.0
                }

                onClicked: {
                    pageHomeView.visible = !pageHomeView.visible
                    pageDetailView.visible = !pageDetailView.visible

                }
            }
            onImgSrcChanged: {
                pageDetailView.name_ = name_
                pageDetailView.artist_ = artist_
                pageDetailView.imgSource_ = musicCover.imgSrc
            }
        }

        MusicIconButton {
            iconSource: "qrc:/images/previous"
            iconWidth: 32
            iconHeight: 32
            toolTip: "上一首"

            onClicked: playPrevious()
        }

        MusicIconButton {
            iconSource: playingState_ ? "qrc:/images/stop" : "qrc:/images/pause"
            iconWidth: 32
            iconHeight: 32
            toolTip: "暂停/播放"

            onClicked: {
                if(!mediaPlayer.source) return
                if(mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                    mediaPlayer.pause()
                    return
                }
                mediaPlayer.play()
            }
        }

        MusicIconButton {
            iconSource: "qrc:/images/next"
            iconWidth: 32
            iconHeight: 32
            toolTip: "下一首"
            onClicked: playNext(false)
        }

        Item {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width/2
            Layout.fillWidth: true
            Layout.topMargin: 25

            visible: !layoutHeaderView.smallWindow_

            Text {
                id: nameText
                anchors.left: slider.left
                anchors.bottom: slider.top
                anchors.leftMargin: 5
                font.family: window.mFONT_FAMILY
                color: "black"
            }

            Text {
                id: timeText
                anchors.right: slider.right
                anchors.bottom: slider.top
                anchors.rightMargin: 5
                font.family: window.mFONT_FAMILY
                color: "black"
            }

            Slider {
                id: slider
                width: parent.width
                Layout.fillWidth: true
                height: 25

                value: sliderValue_
                from: sliderStart_
                to: sliderEnd_

                background: Rectangle {
                    x: slider.leftPadding
                    y: slider.topPadding + (slider.availableHeight - height) / 2
                    width: slider.availableWidth
                    height: 4
                    radius: 2
                    color: "#e9f4ff"
                    Rectangle {
                        width: slider.visualPosition * parent.width
                        height: parent.height
                        color: "#9c91f7"
                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: slider.leftPadding + (slider.availableWidth - width) * slider.visualPosition
                    y: slider.topPadding + (slider.availableHeight - height) / 2
                    width: 15
                    height: 15
                    radius: 5
                    color: "#f0f0f0"
                    border.color: "#73a7ab"
                    border.width: 0.5
                }

                onMoved: {
                    mediaPlayer.seek(value)
                }
            }
        }

        MusicIconButton {
            Layout.preferredWidth: 50
            iconSource: "qrc:/images/favorite"
            iconWidth: 32
            iconHeight: 32
            toolTip: "喜欢"
            onClicked: saveFavorite(playList_[current_])
        }

        MusicIconButton {
            id: playMode
            iconSource: "qrc:/images/" + playModeList_[currentMode_].icon
            iconWidth: 32
            iconHeight: 32
            toolTip: playModeList_[currentMode_].name

            onClicked: changePlayMode()
        }

        Item {
            Layout.preferredWidth: parent.width/10
            Layout.fillWidth: true
        }
    }

    Component.onCompleted: {
        currentMode_ = settings.value("currentMode_", 0)
    }

    onCurrent_Changed: {
        playMusic(current_)
        mediaPlayer.play()
    }


    function playPrevious() {
        current_ = (current_ + playList_.length - 1) % playList_.length
    }

    function playNext(ending) {
        if(currentMode_ === 0 && ending === true) {
            playRepeat()
            return
        }
        current_ = ((current_ + 1) % playList_.length)
        // mediaPlayer.play()
        playingState_ = true
    }

    function playRepeat() {
        playMusic(current_)
    }

    function changePlayMode() {
        currentMode_ = (currentMode_ + 1) % playModeList_.length
        settings.setValue("currentMode_", currentMode_)
    }


    function saveHistory(index = 0) {
        if(playList_.length < index + 1) return
        var item = playList_[index]
        if(!item || !item.id) return
        var history = historySettings.value("history", [])
        var i = history.findIndex(value => value.id === item.id)
        if(i >= 0) {
            history.slice(i, 1)
        }
        history.unshift({
                            id: item.id,
                            name: item.name + "",
                            artist: item.artist + "",
                            url: item.url ? item.url : "",
                            cover: item.cover ? cover : "",
                            type: item.type ? item.type : "",
                            album:item.album ? item.album : "本地音乐"
                        })
        if(history.length > 500) {
            history.pop()
        }
        historySettings.setValue("history", history)
        flushHistory()
    }

    function saveFavorite(value = {}){
            if(!value || !value.id) return
            var favorite =  favoriteSettings.value("favorite", [])
            var i =  favorite.findIndex(item => value.id === item.id)
            if(i >= 0) favorite.splice(i, 1)
            favorite.unshift({
                                id: value.id + "",
                                name: value.name + "",
                                artist: value.artist + "",
                                url: value.url ? value.url : "",
                                type: value.type ? value.type : "",
                                album: value.album ? value.album : "本地音乐"
                            })
            if(favorite.length > 500){
                //限制五百条数据
                favorite.pop()
            }
            favoriteSettings.setValue("favorite", favorite)
            flushFavorite()
        }

    function playMusic(index) {

        if(playList_[current_].type === "local") {
            playlocalMusic()
            return
        }
        playWebMusic(current_)
    }

    function playlocalMusic() {
        var currentItem = playList_[current_]
        mediaPlayer.source = currentItem.url
        mediaPlayer.play()
        name_ = currentItem.name
        artist_ = currentItem.artist
        nameText.text = name_ + "-" + artist_
        console.log(name_ + " " + artist_)
        saveHistory(current_)
    }

    function playWebMusic(index) {
        var id = playList_[index].id
        name_ = playList_[index].name
        artist_ = playList_[index].artist
        var cover = playList_[index].cover
        musicCover.imgSrc = playList_[index].cover
        if(cover.length < 1){
            getCover(id, index)
        }
        nameText.text = name_ + "-" + artist_
        getSongInfo(id)
        // getLyric(id)
        saveHistory(current_)
    }


    function getSongInfo(id) {
        function onReply(reply){
            httputil.onReplySignal.disconnect(onReply)
            var data = JSON.parse(reply).data[0]
            var url = data.url
            var time = data.time
            setSlider(0, time, 0)

            mediaPlayer.source = url
            mediaPlayer.play()
            getLyric(id)
        }
        httputil.onReplySignal.connect(onReply)
        httputil.httpConnect("song/url?id=" + id)
    }

    function getCover(id, index) {
        function onReply(reply) {
            httputil.onReplySignal.disconnect(onReply)
            var cover = JSON.parse(reply).songs[0].al.picUrl
            playList_[index].cover = cover
        }
        httputil.onReplySignal.connect(onReply)
        httputil.httpConnect("song/detail?ids=" + id)
    }

    function getLyric(id) {
        function onReply(reply) {
            httputil.onReplySignal.disconnect(onReply)
            var lyric = JSON.parse(reply).lrc.lyric
            if(lyric.length < 1) return
            var lyrics = (lyric.replace(/\[.*\]/gi,"")).split("\n")
            if(lyrics.length > 0) pageDetailView.lyricsList_ = lyrics

            var times = []

            lyric.replace(/\[.*\]/gi, function(match, index) {
                if(match.length > 2) {
                    var time = match.substr(1, match.length - 2)
                    var arr = time.split(":")
                    var timeValue = arr.length > 0 ? parseInt(arr[0]) * 60 * 1000 : 0

                    arr = arr.length>1?arr[1].split("."):[0,0]
                    timeValue += arr.length>0?parseInt(arr[0])*1000:0
                    timeValue += arr.length>1?parseInt(arr[1])*10:0

                    times.push(timeValue)
                }
            })
            mediaPlayer.times_ = times
        }
        httputil.onReplySignal.connect(onReply)
        httputil.httpConnect("lyric?id=" + id)
    }

    function setSlider(start = 0, end = 100, value = 0) {
        sliderStart_ = start
        sliderEnd_ = end
        sliderValue_ = value

        var totleMin = parseInt(end / 60000) + ""
        var totleSec = parseInt(end / 1000 % 60) + ""
        totleMin = totleMin.length < 2 ? "0" + totleMin : totleMin
        totleSec = totleSec.length < 2 ? "0" + totleSec : totleSec

        var currMin = parseInt(value / 60000) + ""
        var currSec = parseInt(value / 1000 % 60) + ""
        currMin = currMin.length < 2 ? "0" + currMin : currMin
        currSec = currSec.length < 2 ? "0" + currSec : currSec

        if(end !== 0 && end === value) {
            finished()
        }

        timeText.text = currMin + ":" + currSec + "/" + totleMin + ":" + totleSec
    }
}
