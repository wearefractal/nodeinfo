$(function () {
  var ramdata = [];
  var cpudata = [];

  var socket = io.connect('http://localhost');
  socket.on('start', function (data) {
    console.log("start received!");
    var node = data.node;
    var npm = data.npm;
    var system = data.system;

    $("#sysinfo").html("<p>Operating System: " + system.platform + "</p>");
    $("#sysinfo").append("<p>CPU Type: " + system.cpu.name + "</p>");
    $("#sysinfo").append("<p>CPU Cores: " + system.cpu.count + "</p>");
    $("#sysinfo").append("<p>RAM: " + system.ram + "</p>");

    $("#nodeinfo").html("<p>Version: " + node.version + "</p>");
    $("#nodeinfo").append("<p>Location: " + node.location + "</p>");
    $("#nodeinfo").append("<p>Environment: " + node.environment + "</p>");

    $("#npminfo").html("<p>Version: " + npm.version + "</p>");
    $("#npminfo").append("<p>Packages: " + JSON.stringify(npm.packages) + "</p>");

  });
  socket.on('beat', function (data) {
    console.log("heartbeat received!");
    var system = data.system;
    if (ramdata.length > 30){
        ramdata.splice(0, 1);
    }
    if (cpudata.length > 30){
        cpudata.splice(0, 1);
    }
    //ramdata.splice(0, 1);
    ramdata.push([new Date(), system.memoryUsage.usedRatio]);
    cpudata.push([new Date(), system.cpuUsage.usedRatio]);
    
    $("#meminfo").html('<div id="mem_chart"></div>');
    $("#meminfo").append('<div id="disk_chart"></div>');
    
    $("#mem_chart").jqChart({
      title: {
        text: 'Resource Usage'
      },
      background: '#eeeeee',
      axes: [{
        type: 'linear',
        location: 'left',
        minimum: 0,
        maximum: 100,
        interval: 10
      }],
      series: [{
        title: 'RAM Usage',
        type: 'area',
        data: ramdata
      }, {
        title: 'CPU Usage',
        type: 'area',
        data: cpudata
      }]
    });

    $("#disk_chart").jqChart({
      title: {
        text: system.diskUsage.disk
      },
      background: '#eeeeee',
      series: [{
        type: 'pie',
        labels: {
          stringFormat: '%d%%',
          valueType: 'percentage',
          font: '15px sans-serif',
          fillStyle: 'white'
        },
        data: [
          ['Free', system.diskUsage.free],
          ['Used', system.diskUsage.used]
        ]
      }]
    });

  });
  $("#tabs").tabs().find(".ui-tabs-nav").sortable({
    axis: "x"
  });
});
