import QtQuick 2.0

Rectangle {
    id: cpu
    width: w
    height: width
    color: "transparent"

    property string t: "CPU"
    property double ratio: 0
    Ratio {
        anchors.fill: parent
        color: "#ee0026"
    }

    function add(sum, v) {
        return sum + v
    }

    property var xhr: new XMLHttpRequest()
    property int workTime: 0
    property int totalTime: 0
    function compute() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            var cpu = xhr.responseText.split("\n")[0].split(/\s+/).slice(
                        1).map(Number)
            var wtime = cpu.slice(0, 3).reduce(add)
            var ttime = cpu.reduce(add)
            ratio = (wtime - workTime) / (ttime - totalTime)
            workTime = wtime
            totalTime = ttime
        }
    }
    function refresh() {
        xhr.open("GET", "file:///proc/stat")
        xhr.onreadystatechange = compute
        xhr.send()
    }
}
