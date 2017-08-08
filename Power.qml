import QtQuick 2.0

Rectangle {
    id: cpu
    width: w
    height: width
    color: "transparent"

    property string t: "电池"
    property double ratio: 0
    Ratio {
        anchors.fill: parent
        color: "#1d86ae"
    }

    function add(sum, v) {
        return sum + v
    }

    property var xhr: new XMLHttpRequest()
    property int workTime: 0
    property int totalTime: 0
    function compute() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            ratio = xhr.responseText / 100
            xhr.open("GET", "file:///sys/class/power_supply/AC/online", false)
            xhr.onreadystatechange = null
            xhr.send()
            if (xhr.responseText == 1) {
                t = "交流电"
            } else {
                t = "电池"
            }
        }
    }
    function refresh() {
        xhr.open("GET", "file:///sys/class/power_supply/BAT0/capacity")
        xhr.onreadystatechange = compute
        xhr.send()
    }
}
