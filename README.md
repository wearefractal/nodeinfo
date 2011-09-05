**Library for accessing or displaying NodeJS/NPM/System information - kind of like phpinfo() but not a piece of shit**


## Installation
    
To install nodeinfo, use [npm](http://github.com/isaacs/npm):

        $ npm install nodeinfo

## Web UI Usage

```
info = require('nodeinfo');
info.broadcast(port);
```

## Library Usage

```
info = require('nodeinfo');

info.node.getVersion(callback);
info.node.getEnvironment(callback);
info.node.getPrefix(callback);

info.npm.getVersion(callback);
info.npm.getPackages(callback);

info.process.getUptime(callback);
info.process.getUser(callback);
info.process.getMemoryUsage(callback);
info.process.getPid(callback);
info.process.getTitle(callback);
info.process.getPermissions(callback);

info.system.getMemoryUsage(callback);
info.system.getDiskUsage(callback);
info.system.getCPUUsage(callback);
info.system.getCPUs(callback);
info.system.getRAM(callback);
info.system.getProcesses(grep, callback);
info.system.getPlatform(callback);

//All callbacks should look like this
callback = function (result){
  console.log('yey 4 internetz - ' + result);
};
```

## Examples

You can view further examples in the [example folder.](https://github.com/wearefractal/nodeinfo/tree/master/examples)

## Contributors

- [Contra](https://github.com/Contra)

## LICENSE

(MIT License)

Copyright (c) 2011 Fractal <contact@wearefractal.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
