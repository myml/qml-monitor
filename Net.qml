import QtQuick 2.0

Rectangle {
    id: cpu
    width: w
    height: width
    color: "transparent"

    property string t: "网络"
    property int up: 0
    property int down: 0

    Speed {
        anchors.fill: parent
        color: "#f9cdad"
    }

    function add(sum, v) {
        return sum + v
    }
    property var lastNet: null
    property var xhr: new XMLHttpRequest()
    function compute() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            var net = xhr.responseText.split("\n")
            net = net.slice(2, net.length - 1).map(function (line) {
                var s = line.split(/\s+/).filter(function (s) {
                    return s != ""
                })
                return [s[1], s[9]].map(Number)
            }).reduce(function (sum, v) {
                return [sum[0] + v[0], sum[1] + v[1]]
            })
            if (lastNet != null) {
                down = net[0] - lastNet[0]
                up = net[1] - lastNet[1]
            }
            lastNet = net
        }
    }
    function refresh() {
        xhr.open("GET", "file:///proc/net/dev")
        xhr.onreadystatechange = compute
        xhr.send()
    }
}
