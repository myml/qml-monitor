import QtQuick 2.0

Rectangle {
    id: ram
    width: w
    height: width
    color: "transparent"

    property string t: "内存"
    property double ratio: 0

    Ratio {
        anchors.fill: parent
        color: "#d40045"
    }
    property var xhr: new XMLHttpRequest()
    function compute() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            var meminfo = xhr.responseText.split("\n")
            var memTotal = meminfo[0].split(/\s+/)[1]
            var memAvailable = meminfo[2].split(/\s+/)[1]
            ratio = (memTotal - memAvailable) / memTotal
        }
    }
    function refresh() {
        xhr.open("GET", "file:///proc/meminfo")
        xhr.onreadystatechange = compute
        xhr.send()
    }
}
