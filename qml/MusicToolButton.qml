import QtQuick 2.12
import QtQuick.Controls 2.12

ToolButton {
    id: self

    property string iconSource: ""
    property string toolTip: ""
    property bool isCheckable: false
    property bool isChecked: false

    icon.source: iconSource
    icon.width: 32
    icon.height: 32
    icon.color: "#707270"

    ToolTip.text: toolTip
    ToolTip.visible: hovered

    background: Rectangle {
        color: self.down ||
               (isCheckable && self.checked) ? "#ffffff" : "#00000000"
        radius: 3
    }

    checkable: isCheckable
    checked: isChecked
}
