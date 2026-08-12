import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtCore

import "main.js" as Main

ApplicationWindow {
	id: root
	visible: true
    width: Math.max(row.width, 1)
	height: 40
	x: Screen.width - width
	y: Screen.height - height
	flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"
    property var resources: []
    property var result: []
    Component.onCompleted: {
        root.resources=Main.resources()
    }

	Row {
        id: row
        anchors.bottom: parent.bottom
        height: parent.height
        Repeater {
            model: result
            Loader{
                source: modelData.type+".qml"
                height: parent.height
                property var name: modelData.name
                property var value: modelData.value
                property var limit: modelData.limit
            }
        }

//		Repeater {
//			model: monitorModel.length
//			Loader {
//				source: monitorModel[modelData].type + ".qml"

//				height: parent.height

//				property string name: monitorModel[modelData].name
//				property var value: monitorModel[modelData].type == "R" ? 0 : {
//																			  up: 0,
//																			  down: 0
//																		  }
//				property var limit: monitorModel[modelData].limit
//				Timer {
//					repeat: true
//					running: true
//					onTriggered: {
//						parent.value = monitorModel[modelData].getValue()
//					}
//				}
//			}
//		}
	}

    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            root.result = Main.main(root.resources)
        }
    }

    MouseArea {
		anchors.fill: parent
		onPressed: {
			exec.startSystemMove(root)
		}
	}

    Settings {
        property alias x: root.x
        property alias y: root.y
    }
}
