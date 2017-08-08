import QtQuick 2.0

Rectangle {
    id: ram
    width: w
    height: width
    color: "transparent"

    property string t: "负载"
    property double ratio: 0

    Ratio {
        anchors.fill: parent
        color: "#c8c8a9"
    }
    property var xhr: new XMLHttpRequest()
    function compute() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            var cpuNum = xhr.responseText.match(/processor/g).length
            xhr.onreadystatechange = null
            xhr.open("GET", "file:///proc/loadavg", false)
            xhr.send()
            ratio = xhr.responseText.split(" ")[0] / cpuNum
        }
    }
    function refresh() {
        xhr.open("GET", "file:///proc/cpuinfo")
        xhr.onreadystatechange = compute
        xhr.send()
    }
}
