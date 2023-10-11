import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: self

    property string iconSource: ""
    property string toolTip: ""
    property int iconWidth: 32
    property int iconHeight: 32
    property bool isCheckable: false
    property bool isChecked: false

    icon.source: iconSource
    icon.width: iconWidth
    icon.height: iconHeight
    icon.color: self.down ? "#394153" : "#636A7A"

    ToolTip.text: toolTip
    ToolTip.visible: hovered

    background: Rectangle {
        color: self.down ||
               (isCheckable && self.checked) ? "#497563" : "#20e9f4ff"

    }

    checkable: isCheckable
    checked: isChecked
}
