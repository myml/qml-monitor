import QtQuick 2.0

Rectangle {
    id: cpu
    width: w
    height: width
    color: "transparent"

    property string t: "磁盘"
    property int up: 0
    property int down: 0

    Speed {
        anchors.fill: parent
        color: "#007a87"
    }

    function add(sum, v) {
        return sum + v
    }
    property var lastDisk: null
    property var xhr: new XMLHttpRequest()
    function compute() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            var disk = xhr.responseText.split("\n")[0].split(/\s+/)
            disk = [disk[6] * 512, disk[10] * 512]
            if (lastDisk != null) {
                up = disk[0] - lastDisk[0]
                down = disk[1] - lastDisk[1]
            }
            lastDisk = disk
        }
    }
    function refresh() {
        xhr.open("GET", "file:///proc/diskstats")
        xhr.onreadystatechange = compute
        xhr.send()
    }
}
