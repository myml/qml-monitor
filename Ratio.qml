import QtQuick 2.0

Rectangle {
    opacity: 0.7
    color: parent.color
    Rectangle {
        width: parent.width
        height: parent.height * ratio
        anchors.bottom: parent.bottom
        color: parent.color
        opacity: 0.9
    }
    Text {
        id: title
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        text: t
    }
    Text {
        id: content
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 10
        text: (ratio * 100).toFixed(1) + "%"
    }
}
