import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQml.Models 2.3

ApplicationWindow {

    //模块宽度
    property int w: 50

    //全部模块
    // @disable-check M300
    ObjectModel {
        id: modelList
        Cpu {
        }
        Ram {
        }
        Load {
        }
        Power {
        }
        Net {
        }
        Disk {
        }
    }

    //显示模块
    // @disable-check M300
    ObjectModel {
        id: showList
    }

    Component.onCompleted: {
        for (var i = 0; i < modelList.count; i++) {
            var m = modelList.get(i)
            //            m.width = m.height = w
            showList.append(m)
        }
    }

    id: root
    visible: true
    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"
    height: w
    width: showList.count * w

    MouseArea {
        anchors.fill: parent
        property int mx: 0
        property int my: 0
        onPressed: {
            mx = mouseX
            my = mouseY
        }
        onPositionChanged: {
            root.x += mouseX - mx
            root.y += mouseY - my
        }
    }

    Row {
        Repeater {
            model: showList
        }
    }

    Timer {
        repeat: true
        running: true
        onTriggered: {
            for (var i = 0; i < showList.count; i++) {
                showList.get(i).refresh()
            }
        }
    }
}
