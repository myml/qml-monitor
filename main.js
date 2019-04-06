// .pragma library

function main(resources = Object.keys(AvailableResource)) {
  const result = resources.map(key => {
    return {
      type: AvailableResource[key].type,
      name: AvailableResource[key].name,
      limit: AvailableResource[key].limit,
      value: AvailableResource[key].getValue(),
    };
  });
  return result;
}

const AvailableResource = {
  cpu: {
    type: 'R',
    name: 'CPU',
    limit: 0.9,

    workTime: 0,
    totalTime: 0,

    getValue() {
      var cpu = readFile('/proc/stat')
        .split('\n')[0]
        .split(/\s+/)
        .slice(1)
        .map(Number);
      var wtime = cpu.slice(0, 3).reduce(add);
      var ttime = cpu.reduce(add);
      var v = (wtime - this.workTime) / (ttime - this.totalTime);
      this.workTime = wtime;
      this.totalTime = ttime;
      return v;
    },
  },
  mem: {
    name: '内存',
    type: 'R',
    limit: 0.9,

    getValue() {
      var meminfo = readFile('/proc/meminfo').split('\n');
      var memTotal = meminfo[0].split(/\s+/)[1];
      var memAvailable = meminfo[2].split(/\s+/)[1];
      return (memTotal - memAvailable) / memTotal;
    },
  },
  load: {
    name: '负载',
    type: 'R',

    p: null,

    getValue() {
      if (this.p == null) {
        this.p = readFile('/proc/cpuinfo').match(/processor/g).length;
      }
      var loadInfo = readFile('/proc/loadavg').split(' ')[0];
      return Number(loadInfo) / this.p;
    },
  },
  power: {
    name: '电池',
    type: 'R',

    getValue() {
      return readFile('/sys/class/power_supply/BAT0/capacity') / 100;
    },
  },
  network: {
    name: '网络',
    type: 'S',

    lastNet: null,

    getValue() {
      var net = readFile('/proc/net/dev').split('\n');
      net = net
        .slice(2, net.length - 1)
        .map(function(line) {
          var s = line.split(/\s+/).filter(function(s) {
            return s != '';
          });
          return [s[1], s[9]].map(Number);
        })
        .reduce(function(sum, v) {
          return [sum[0] + v[0], sum[1] + v[1]];
        });
      var v = {
        up: 0,
        down: 0,
      };
      if (this.lastNet != null) {
        v.down = net[0] - this.lastNet[0];
        v.up = net[1] - this.lastNet[1];
      }
      this.lastNet = net;
      return v;
    },
  },
  disk: {
    name: '磁盘',
    type: 'S',

    lastDisk: null,

    getValue() {
      var disk = readFile('/proc/diskstats')
        .split('\n')
        .map(function(d) {
          d = d.split(/\s+/);
          if (d.length == 15) {
            return [d[6], d[10]].map(Number);
          } else {
            return [0, 0];
          }
        })
        .reduce(function(r, d) {
          return [r[0] + d[0], r[1] + d[1]];
        })
        .map(function(n) {
          return n * 512;
        });
      var v = {
        up: 0,
        down: 0,
      };
      if (this.lastDisk != null) {
        v = {
          up: disk[0] - this.lastDisk[0],
          down: disk[1] - this.lastDisk[1],
        };
      }
      this.lastDisk = disk;
      return v;
    },
  },
};

function resources() {
  const set = new Set(['cpu', 'mem', 'load', 'power', 'network', 'disk']);
  if (!Boolean(AvailableResource['power'].getValue())) {
    set.delete('power');
  }
  return [...set.values()];
}

function readFile(fname) {
  const xhr = new XMLHttpRequest();
  var req = new XMLHttpRequest();
  req.open('GET', 'file://' + fname, false);
  req.send();
  return req.responseText;
}

function add(sum, v) {
  return sum + v;
}
