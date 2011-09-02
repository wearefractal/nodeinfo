$(function () {
  var socket = io.connect('http://localhost');
  socket.on('Start', function (data) {
        var node = data.node;
        var npm = data.npm;
        var system = data.system;
        
        $("#sysinfo").html("<p>Platform: " + system.platform + "</p>");
        
        $("#nodeinfo").html("<p>Version: " + node.version + "</p>");
        $("#nodeinfo").append("<p>Location: " + node.location + "</p>");
        $("#nodeinfo").append("<p>Environment: " + node.environment + "</p>");
        
        $("#npminfo").html("<p>Version: " + npm.version + "</p>");
        $("#npminfo").append("<p>Packages: " + JSON.stringify(npm.packages) + "</p>");
  });
  socket.on('Heartbeat', function (data) {
    
    
  });
  
  
  $( "#tabs" ).tabs().find( ".ui-tabs-nav" ).sortable({ axis: "x" });
});
