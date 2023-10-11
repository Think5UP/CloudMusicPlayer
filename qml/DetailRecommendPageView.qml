import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

// 推荐界面
ScrollView {
    id: scrollView
    background: Rectangle {
        color: "#f5f5f5"
    }

    contentHeight: 2100

    ScrollBar.vertical: ScrollBar {
        id: scrollBar
        parent: scrollView

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: scrollView.availableHeight

        interactive: true
        snapMode: ScrollBar.SnapAlways

        background: Rectangle {
            anchors.fill: parent
            color: "#f5f5f5"
        }
        //        contentItem: Rectangle {
        //            implicitWidth: scrollBar.interactive ? 8 : 2
        //            implicitHeight: scrollBar.interactive ? 8 : 2

        //            radius: width / 2
        //            color: scrollBar.pressed ? Qt.darker("#9c91f7") : scrollBar.hovered ? Qt.lighter("#9c91f7") : "#9c91f7"
        //            //修改为widgets那种alwayson/超出范围才显示的样子
        //            opacity:(scrollBar.policy === ScrollBar.AlwaysOn || scrollBar.size < 1.0) ? 1.0 : 0.0
        //        }

    }


    ColumnLayout {
        clip: true

        Rectangle {
            id: recomentRec
            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#f5f5f5"
            Text {
                x: 10
                verticalAlignment: Text.AlignBottom
                text: qsTr("推荐内容")
                font.family: window.mFONT_FAMILY
                font.pointSize: 25
            }
        }

        Loading {
            id: loading
            visible: false
            Layout.alignment: Qt.AlignHCenter
        }

        MusicBannerView {
            id: bannerView
            Layout.preferredWidth: window.width - 220
            Layout.preferredHeight: (window.width - 200) * 0.3
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Rectangle {
            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#f5f5f5"
            Text {
                id: hotsongRec
                x: 10
                verticalAlignment: Text.AlignBottom
                text: qsTr("热门歌单")
                font.family: window.mFONT_FAMILY
                font.pointSize: 25
            }
        }

        MusicGridView {
            id: gridView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (window.width - 230) * 0.1 * 10
            Layout.bottomMargin: 20
        }

        Rectangle {
            id: newsongRec
            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#f5f5f5"
            Text {
                x: 10
                verticalAlignment: Text.AlignBottom
                text: qsTr("新歌速递")
                font.family: window.mFONT_FAMILY
                font.pointSize: 25
            }
        }

        MusicGridSongView {
            id: gridSongView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (window.width - 230) * 0.1 * 10
            Layout.bottomMargin: 20
        }
    }

    Component.onCompleted: {
        getBannerList()
    }

    function transformVisiable() {
        loading.visible = !loading.visible
        recomentRec.visible = !recomentRec.visible
        bannerView.visible = !bannerView.visible
        hotsongRec.visible = !hotsongRec.visible
        gridView.visible = !gridView.visible
        newsongRec.visible = !newsongRec.visible
        gridSongView.visible = !gridSongView.visible
    }

    function getBannerList() {
        transformVisiable()
        function onReply(reply) {
            httputil.onReplySignal.disconnect(onReply)
            var banners = JSON.parse(reply).banners
            bannerView.bannerList = banners
            getGridList()
            transformVisiable()
        }
        httputil.onReplySignal.connect(onReply)
        httputil.httpConnect("banner")
    }

    function getGridList() {

        function onReply(reply) {
            httputil.onReplySignal.disconnect(onReply)
            var playlists = JSON.parse(reply).playlists
            gridView.list_ = playlists
            getLatestList()
        }
        httputil.onReplySignal.connect(onReply)
        httputil.httpConnect("/top/playlist?limit=20")
    }

    function getLatestList(){
        function onReply(reply){
            httputil.onReplySignal.disconnect(onReply)
            var latestList = JSON.parse(reply).data
            gridSongView.list_ = latestList.slice(0, 30)
        }

        httputil.onReplySignal.connect(onReply)
        httputil.httpConnect("top/song")
    }
}
