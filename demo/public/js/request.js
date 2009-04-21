function createHttpRequest () {
  var fs = [
    function () { return new XMLHttpRequest(); },
    function () { return new ActiveXObject('Msxml2.XMLHTTP'); },
    function () { return new ActiveXObject('Microsoft.XMLHTTP'); },
  ];
  for (var i = 0; i < fs.length; i++) {
    try { var r = fs[i](); if (r) return r; } catch (e) { continue; }
  }
}
function httpGet (uri) {
  var req = createHttpRequest();
  req.open('GET', uri, false); // asynchronous ? false
  req.send(null); // no body
  return req.responseText;
}
function httpPost(uri, data) {
  var req = createHttpRequest();
  req.open('POST', uri, false); // asynchronous ? false
  //req.setRequestHeader('Content-Length', data.length); // utf ???
  req.send(data);
  return req.responseText;
}
