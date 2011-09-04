$(document).ready(function () {
  var ramdata = [];
  var cpudata = [];

  var socket = io.connect(document.location.href);
  socket.on('start', function (data) {
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
    $("#npminfo").append("<p>Installed Packages:</p>");
    $("#npminfo").append("<div id='packages'></div>");
    $("#packages").wijlist({
      selected: function (e, item) {
        window.open(item.item.value, '_newtab');
      }
    });
    $("#packages").wijlist('setItems', npm.packages);
    $("#packages").wijlist('renderList');

  });
  socket.on('beat', function (data) {
    var system = data.system;

    if (ramdata.length > 30) {
      ramdata = [];
    }
    if (cpudata.length > 30) {
      cpudata = [];
    }
    
    ramdata.push([new Date(), system.memoryUsage.usedRatio]);
    cpudata.push([new Date(), system.cpuUsage.usedRatio]);
    
    //CPU/RAM usage graph
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
    //Disk pie chart
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

    //Process table
    $('#procinfo').html('<table width="100%" cellpadding="0" cellspacing="0" border="0" class="display" id="processes"></table>');
    $('#processes').dataTable({
      "bJQueryUI": true,
      "aaData": data.system.processes,
      "aoColumns": [{
        "sTitle": "PID"
      }, {
        "sTitle": "CPU Usage"
      }, {
        "sTitle": "Memory Usage"
      }, {
        "sTitle": "Arguments"
      }, {
        "sTitle": "Uptime"
      }, {
        "sTitle": "User"
      }, ]
    });
  });
  
  $("#tabs").tabs().find(".ui-tabs-nav").sortable({
    axis: "x"
  });
});
