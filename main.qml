import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQml.Models 2.3

ApplicationWindow {
		id: root
		visible: true
		width: 280
		height: 40
		flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
//		flags: Qt.WindowStaysOnTopHint
		color: "transparent"

		function read(fname){
			var req=new XMLHttpRequest()
			req.open("GET","file://"+fname,false)
			req.send()
			return req.responseText
		}

		function add(sum, v) {
			return sum + v
		}

		property var monitorModel:[
			{
				name: "CPU",
				type: "R",
				getValue: function(){
					var cpu = read("/proc/stat").split("\n")[0].split(/\s+/).slice(
								1).map(Number)
					var wtime = cpu.slice(0, 3).reduce(add)
					var ttime = cpu.reduce(add)
					var v = (wtime - this.workTime) / (ttime - this.totalTime)
					this.workTime = wtime
					this.totalTime = ttime
					return v
				},
				workTime: 0,
				totalTime: 0,
			},
			{
				name: "内存",
				type: "R",
				getValue: function(){
					var meminfo = read("/proc/meminfo").split("\n")
					var memTotal = meminfo[0].split(/\s+/)[1]
					var memAvailable = meminfo[2].split(/\s+/)[1]
					return (memTotal - memAvailable) / memTotal
				}
			},
			{
				name: "负载",
				type: "R",
				getValue: function(){
					if(this.p==null){
						this.p=read("/proc/cpuinfo").match(/processor/g).length
					}
					var loadInfo = read("/proc/loadavg").split(" ")[0]
					return Number(loadInfo)/this.p
				},
				p:null
			},
			{
				name: "电池",
				type: "R",
				getValue: function(){
					return read("/sys/class/power_supply/BAT0/capacity")/100
				}
			},
			{
				name: "网络",
				type: "S",
				getValue: function(){
					var net = read("/proc/net/dev").split("\n")
					net = net.slice(2, net.length - 1).map(function (line) {
						var s = line.split(/\s+/).filter(function (s) {
							return s != ""
						})
						return [s[1], s[9]].map(Number)
					}).reduce(function (sum, v) {
						return [sum[0] + v[0], sum[1] + v[1]]
					})
					var v={up:0,down:0}
					if (this.lastNet != null) {
						v.down = net[0] - this.lastNet[0]
						v.up = net[1] - this.lastNet[1]
					}
					this.lastNet = net
					return v
				},
				lastNet:null
			},
			{
				name: "磁盘",
				type: "S",
				getValue: function(){
					var disk = read("/proc/diskstats").split("\n").map(function(d){
						d=d.split(/\s+/)
						if(d.length==15){
							return [d[6],d[10]].map(Number)
						}else{
							return [0,0]
						}
					}).reduce(function(r,d){
						return [r[0]+d[0],r[1]+d[1]]
					}).map(function(n){
						return n*512
					})
					var v={up:0,down:0}
					if(this.lastDisk!=null){
						v={up:disk[0]-this.lastDisk[0],down:disk[1]-this.lastDisk[1]}
					}
					this.lastDisk=disk
					return v
				},
				lastDisk:null,
			}
		]
		Row{
			anchors.bottom: parent.bottom
			width: parent.width
			height: 40
			Repeater{
				model: monitorModel.length
				Loader{
					source: monitorModel[modelData].type+".qml"

					height: parent.height

					property string name: monitorModel[modelData].name
					property var value: monitorModel[modelData].type=="R"?0:{up:0,down:0}
					Timer{
						repeat: true
						running: true
						onTriggered: {
							parent.value=monitorModel[modelData].getValue()
						}
					}
				}
			}
		}
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
//    //模块宽度
//    property int w: 50

//    //全部模块
//    // @disable-check M300
//    ObjectModel {
//        id: modelList
//        Cpu {
//        }
//        Ram {
//        }
//        Load {
//        }
//        Power {
//        }
//        Net {
//        }
//        Disk {
//        }
//    }

//    //显示模块
//    // @disable-check M300
//    ObjectModel {
//        id: showList
//    }

//    Component.onCompleted: {
//        for (var i = 0; i < modelList.count; i++) {
//            var m = modelList.get(i)
//            //            m.width = m.height = w
//            showList.append(m)
//        }
//    }

//    id: root
//    visible: true
//    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
//    color: "transparent"
//    height: w
//    width: showList.count * w

//    MouseArea {
//        anchors.fill: parent
//        property int mx: 0
//        property int my: 0
//        onPressed: {
//            mx = mouseX
//            my = mouseY
//        }
//        onPositionChanged: {
//            root.x += mouseX - mx
//            root.y += mouseY - my
//        }
//    }

//    Row {
//        Repeater {
//            model: showList
//        }
//    }

//    Timer {
//        repeat: true
//        running: true
//        onTriggered: {
//            for (var i = 0; i < showList.count; i++) {
//                showList.get(i).refresh()
//            }
//        }
//    }
}
