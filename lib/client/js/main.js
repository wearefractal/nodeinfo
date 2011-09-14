$(document).ready(function () {
    //$('#switcher').themeswitcher();
    var ramdata = [];
    var cpudata = [];
    var loaddata = [];
    var procTable;

    procTable = $('#processes').dataTable({
        "bJQueryUI": true,
        "bRetrieve": true,
        "bDestroy": true,
        "aoColumns": [{
            "sTitle": "PID"
        }, {
            "sTitle": "CPU"
        }, {
            "sTitle": "Memory"
        }, {
            "sTitle": "Command"
        }, {
            "sTitle": "Time"
        }, {
            "sTitle": "User"
        }, ]
    });
    var socket = io.connect(document.location.href);

    socket.on('start', function (data) {
        var node = data.node;
        var npm = data.npm;
        var system = data.system;

        var t = system.uptime;
        var h = Math.floor(t / 3600);
        t %= 3600;
        var m = Math.floor(t / 60);
        var s = t % 60;
        var uptime = (h > 0 ? h + ' hours ' : '') + (m > 0 ? m + ' minutes ' : '') + s + ' seconds';

        $("#sysinfo").html("<p>Operating System: " + system.platform + "</p>");
        $("#sysinfo").append("<p>Uptime: " + uptime + "</p>");
        $("#sysinfo").append("<p>CPU Type: " + system.cpu.name + "</p>");
        $("#sysinfo").append("<p>CPU Cores: " + system.cpu.count + "</p>");
        $("#sysinfo").append("<p>RAM: " + system.ram + "</p>");
        $("#sysinfo").append('<center><div id="disk_chart" style="width: 500px;"></div></center>');

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

        //Disk pie chart
        $("#disk_chart").jqChart({
            title: {
                text: system.diskUsage.disk
            },
            border: {
                lineWidth: 0
            },
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
        procTable.fnClearTable();
        procTable.fnAddData(system.processes);
    });

    socket.on('beat', function (data) {
        var system = data.system;

        ramdata.push([new Date(), system.memoryUsage.usedRatio]);
        cpudata.push([new Date(), system.cpuUsage.usedRatio]);
        loaddata.push([new Date(), system.load]);

        if (ramdata.length > 25) {
            ramdata.shift();
        }
        if (cpudata.length > 25) {
            cpudata.shift();
        }

        if (loaddata.length > 25) {
            loaddata.shift();
        }
        var ramseries = {
            label: "Memory Usage",
            lines: {
                show: true
            },
            points: {
                show: false
            },
            data: ramdata
        };
        var cpuseries = {
            label: "CPU Usage",
            lines: {
                show: true
            },
            points: {
                show: false
            },
            data: cpudata
        };
        var loadseries = {
            label: "Load Average",
            lines: {
                show: true
            },
            points: {
                show: false
            },
            data: loaddata
        };
        var data = [ramseries, cpuseries, loadseries];

        var options = {
            yaxis: {
                label: "Percent",
                max: 100
                
            },
            xaxis: {
                label: "Time",
                mode: "time",
                show: false
            },
            legend: {
                show: true,
                position: "nw"
            },
            grid: {
                hoverable: false,
                clickable: false
            }
        };
        var ramplot = $.plot($("#mem_chart"), data, options);
    });

    $("#tabs").tabs().find(".ui-tabs-nav").sortable({
        axis: "x"
    });
});
