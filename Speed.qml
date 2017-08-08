import QtQuick 2.0

Rectangle {
    opacity: 0.7
    color: parent.color
    function toGB(bytes) {
        if (bytes < 1024) {
            return bytes + "B"
        }
        if (bytes / 1024 < 1024) {
            return parseInt((bytes / 1024)) + "K"
        }
        return (bytes / 1024 / 1024).toFixed(1) + "M"
    }
    Text {
        id: title
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        text: "↑" + toGB(up)
    }
    Text {
        id: content
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 10
        text: "↓" + toGB(down)
    }
}
