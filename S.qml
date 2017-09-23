import QtQuick 2.0

Rectangle {
	opacity: 0.7
	color: "#eee"
	width: height*1.5
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
		anchors.centerIn: parent
		anchors.verticalCenterOffset: -10
		text: "↑" + toGB(value.up)
	}
	Text {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 10
		text: "↓" + toGB(value.down)
    }
}
