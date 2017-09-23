import QtQuick 2.0

Rectangle {
	color: "#eee"
	opacity: 0.6
	width: height

	Rectangle {
		width: parent.width
		height: parent.height * value
		Behavior on height{
			NumberAnimation{
				duration: 200
			}
		}

		anchors.bottom: parent.bottom
		color: "#fff"
		opacity: 0.9
	}
	Text {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
		text: name
    }
	Text {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 10
		text: (value * 100).toFixed(1) + "%"
    }
}
