/*
 * Copyright (c) 2009-2010, John Mettraux, jmettraux@gmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * Made in Japan.
 */

var RuoteSheets = function() {

  var DEFAULT_CELL_WIDTH = 150;

  //
  // MISC FUNCTIONS

  function dwrite (msg) {
    document.body.appendChild(document.createTextNode(msg));
    document.body.appendChild(document.createElement('br'));
  }

  function findElt (i) {
    if ((typeof i) == 'string') return document.getElementById(i);
    else return i;
  }

  function createElement (parentNode, tag, klass, atts) {
    var e = document.createElement(tag);
    if (parentNode) parentNode.appendChild(e);
    if (klass) e.setAttribute('class', klass);
    if (atts) { for (k in atts) { e.setAttribute(k, atts[k]); } }
    return e;
  }

  function addClass (elt, klass) {
    elt.setAttribute('class', elt.getAttribute('class') + ' ' + klass);
  }
  function removeClass (elt, klass) {
    // warning : naive on the right border (after word)
    elt.setAttribute(
      'class', elt.getAttribute('class').replace(' ' + klass, ''));
  }

  function placeAfter (elt, newElt) {
    var p = elt.parentNode;
    var n = elt.nextSibling;
    if (n) p.insertBefore(newElt, n);
    else p.appendChild(newElt);
  }

  //
  // EVENT HANDLERS

  function cellOnFocus (evt) {
    var e = evt || window.event;
    var sheet = e.target.parentNode.parentNode;
    unfocusSheet(sheet);
    setCurrentCell(sheet, e.target);
  }

  function cellOnKeyDown (evt) {
    var e = evt || window.event;
    var cell = e.target;
    if ( ! cell.previousValue) {
      save(cell.parentNode.parentNode);
      cell.previousValue = cell.value;
    }
    return true;
  }

  function cellOnKeyUp (evt) {
    var e = evt || window.event;
    var c = e.charCode || e.keyCode;
    //alert("" + c + " / " + e.ctrlKey + " - " + e.altKey + " - " + e.shiftKey);
    if (c == 38 || c == 40) move(e, c);
    if (isCellEmpty(e.target) && (c == 37 || c == 39)) move(e, c);
    return (c != 13);
  }

  function cellOnChange (evt) {
    var e = evt || window.event;
    e.target.previousValue = null; // cleaning
  }

  function handleOnMouseDown (evt) {
    var e = evt || window.event;
    var headcell = e.target.parentNode;
    var headrow = headcell.parentNode;
    var col = determineRowCol(headcell)[1];
    headrow.down = [ e.target.parentNode, e.clientX, col ];
  }

  function rowOnMouseDown (evt) {

    var e = evt || window.event;
    var sheet = e.target.parentNode.parentNode;
    sheet.mouseDownCell = e.target;
  }

  function rowOnMouseUp (evt) {

    var e = evt || window.event;

    var sheet = e.target.parentNode.parentNode;

    var c0 = sheet.mouseDownCell;
    if ( ! c0) return;

    var c1 = findCellByCoordinates(sheet, e.clientX, e.clientY);
    if ( ! c1) c1 = c0;

    var rc0 = determineRowCol(c0);
    var rc1 = determineRowCol(c1);
    var minx = Math.min(rc0[1], rc1[1]);
    var miny = Math.min(rc0[0], rc1[0]);
    var maxx = Math.max(rc0[1], rc1[1]);
    var maxy = Math.max(rc0[0], rc1[0]);

    //dwrite('' + minx + '/' + miny + '  // ' + maxx + '/' + maxy);
    iterate(sheet, function (t, x, y, e) {
      if (t != 'cell') return false;
      if (x < minx || x > maxx) return false;
      if (y < miny || y > maxy) return false;
      addClass(e, 'focused');
    });
  }

  function getHeadRow (elt) {
    var t = getRuseType(elt);
    if (t == 'headcell') return getHeadRow(elt.parentNode);
    if (t == 'headrow') return elt;
    return null;
  }

  function handleOnMouseUp (evt) {

    var e = evt || window.event;

    var hr = getHeadRow(e.target);

    if ( ! hr.down) return;

    var d = e.clientX - hr.down[1];
    var w = hr.down[0].offsetWidth + d;
    if (w < 12) w = 12; // minimal width

    save(hr.parentNode);

    iterate(hr.parentNode, function (t, x, y, e) {
      if ((t == 'cell' || t == 'headcell') && x == hr.down[2]) {
        e.style.width = '' + w + 'px';
      }
    });
    hr.down = null;
  }

  //
  // ...

  function unfocusSheet (sheet) {
    iterate(sheet, function (t, x, y, e) {
      if (t == 'cell') removeClass(e, 'focused');
    });
  }

  function getCurrentCell (sheet) {

    sheet = findElt(sheet);

    if (( ! sheet.currentCell) ||
        ( ! sheet.currentCell.parentNode) ||
        ( ! sheet.currentCell.parentNode.parentNode)) {

      sheet.currentCell = null;
      return findCell(sheet, 0, 0);
    }
    return sheet.currentCell;
  }

  function setCurrentCell (sheet, cell) {

    findElt(sheet).currentCell = cell;
  }

  function isCellEmpty (elt) {

    return (elt.value == '');
  }

  function move (e, c) {

    var rc = determineRowCol(e.target);
    var row = rc[0]; var col = rc[1];

    if (c == 38) row--;
    else if (c == 40) row++;
    else if (c == 37) col--;
    else if (c == 39) col++;

    var cell = findCell(e.target.parentNode.parentNode, row, col);

    if (cell != null) {
      cell.focus();
      addClass(cell, 'focused'); // not using :focus
      setCurrentCell(cell.parentNode.parentNode, cell);
    }
  }

  function determineRowCol (elt) {

    var cc = elt.getAttribute('class').split(' ');
    return [ cc[1].split('_')[1], cc[2].split('_')[1] ];
  }

  function findRow (sheet, y) {
    var row = iterate(sheet, function (t, x, yy, e) {
      if (t == 'row' && yy == y) return e;
    });
    return row ? row[0] : null;
  }

  function findCell (sheet, y, x) {

    var row = findRow(sheet, y);
    if (row == null) return null;

    for (var i = 0; i < row.childNodes.length; i++) {
      var c = row.childNodes[i];
      if (getRuseType(c) != 'cell') continue;
      if (c.getAttribute('class').match(' column_' + x)) return c;
    }
    return null;
  }

  function computeColumns (data) {

    var cols = 0;

    for (var y = 0; y < data.length; y++) {
      var row = data[y];
      if (row.length > cols) cols = row.length;
    }
    return cols;
  }

  function getWidths (sheet) {
    var widths = [];
    iterate(sheet, function (t, x, y, e) {
      if (t == 'headcell') widths.push(e.offsetWidth);
    });
    return widths;
  }

  function getRuseType (elt) {
    if (elt.nodeType != 1) return false;
    var c = elt.getAttribute('class');
    if ( ! c) return false;
    var m = c.match(/^ruse_([^ ]+)/);
    return m ? m[1] : false;
  }

  function renderHeadCell (headrow, x, w) {

    var c = createElement(headrow, 'div', 'ruse_headcell row_-1 column_' + x);

    c.style.width = '' + (w || DEFAULT_CELL_WIDTH) + 'px';

    createElement(c, 'div', 'ruse_headcell_left');

    var handle = createElement(c, 'div', 'ruse_headcell_handle');
    handle.onmousedown = handleOnMouseDown;

    return c;
  }

  function renderHeadRow (sheet, widths, cols) {

    var headrow = createElement(sheet, 'div', 'ruse_headrow');
    headrow.onmouseup = handleOnMouseUp;

    for (var x = 0; x < cols; x++) { renderHeadCell(headrow, x, widths[x]); }

    createElement(headrow, 'div', null, { style: 'clear: both;' });
  }

  function createRow (sheet) {
    var row = createElement(sheet, 'div', 'ruse_row');
    row.onmousedown = rowOnMouseDown;
    row.onmouseup = rowOnMouseUp;
    return row;
  }

  function createCell (row, value, width) {

    if (value == undefined) value = '';
    if ((typeof value) != 'string') value = '' + value;

    if ( ! width) width = DEFAULT_CELL_WIDTH;

    var cell = createElement(row, 'input', 'ruse_cell');

    cell.setAttribute('type', 'text');

    cell.onkeydown = cellOnKeyDown;
    cell.onkeyup = cellOnKeyUp;
    cell.onfocus = cellOnFocus;
    cell.onchange = cellOnChange;

    cell.value = value;
    cell.style.width = width + 'px';

    return cell;
  }

  function render (sheet, data, widths) {

    sheet = findElt(sheet);

    while (sheet.firstChild) { sheet.removeChild(sheet.firstChild); }

    if ( ! widths) {
      widths = getWidths(sheet);
    }
    if ( ! widths) {
      widths = [];
      for (var x = 0; x < cols; x++) { widths.push(DEFAULT_CELL_WIDTH); }
    }

    sheet = findElt(sheet);

    var rows = data.length;
    var cols = computeColumns(data);

    renderHeadRow(sheet, widths, cols);

    for (var y = 0; y < rows; y++) {

      var rdata = data[y];
      var row = createRow(sheet);
      for (var x = 0; x < cols; x++) { createCell(row, rdata[x], widths[x]); }
    }

    reclass(sheet);
  }
  
  function renderEmpty (container, rows, cols) {

    container = findElt(container);

    var data = [];
    for (var y = 0; y < rows; y++) {
      var row = [];
      for (var x = 0; x < cols; x++) row.push('');
      data.push(row);
    }
    render(container, data);
  }

  // exit if func returns something than is considered true
  //
  function iterate (sheet, func) {

    sheet = findElt(sheet);

    var y = 0;

    for (var yy = 0; yy < sheet.childNodes.length; yy++) {

      var e = sheet.childNodes[yy];

      var rowType = getRuseType(e);
      if ( ! rowType) continue;

      var x = 0;

      var r = func.call(null, rowType, x, y, e);
      if (r) return [ r, rowType, x, y, e ];

      for (var xx = 0; xx < e.childNodes.length; xx++) {

        var ee = e.childNodes[xx];

        var cellType = getRuseType(ee);
        if ( ! cellType) continue;

        var r = func.call(null, cellType, x, y, ee);
        if (r) return [ r, cellType, x, y, ee ];

        x++;
      }
      if (rowType == 'row') y++;
    }
  }

  function findCellByCoordinates (sheet, x, y) { // mouse coordinates

    var r = iterate(sheet, function (t, xx, yy, e) {

      if (t != 'cell') return false;

      var ex = e.offsetLeft; var ey = e.offsetTop;
      var ew = ex + e.offsetWidth; var eh = ey + e.offsetHeight;
      if (x < ex || x > ew) return false;
      if (y < ey || y > eh) return false;

      return e;
    });

    return r ? r[0] : null;
  }

  function countRows (sheet) {
    return toArray(sheet).length;
  }

  function countCols (sheet) {
    return (toArray(sheet)[0] || []).length;
  }

  function reclass (sheet) {
    iterate(sheet, function (t, x, y, e) {
      if (t == 'row')
        e.setAttribute('class', 'ruse_row row_' + y);
      else if (t == 'cell')
        e.setAttribute('class', 'ruse_cell row_' + y + ' column_' + x);
      else if (t == 'headcell')
        e.setAttribute('class', 'ruse_headcell row_-1 column_' + x);
    });
  }

  function toArray (sheet) {

    var a = [];
    var row = null;

    iterate(sheet, function (t, x, y, e) {
      if (t == 'row') { row = []; a.push(row); }
      else if (t == 'cell') { row.push(e.value); }
    });

    return a;
  }

  function focusedToArray (sheet) {
    var a = [];
    var r = null;
    iterate(sheet, function (t, x, y, e) {
      if (t == 'row') { r = []; a.push(r); }
      if (t != 'cell') return false;
      if (e.getAttribute('class').match(/ focused/)) r.push(e.value);
    });
    var aa = [];
    for (var y = 0; y < a.length; y++) {
      var row = a[y];
      if (row.length > 0) aa.push(row);
    }
    return aa;
  }

  function currentCol (sheet, col) {
    if (col == undefined) {
      var cell = getCurrentCell(sheet);
      col = determineRowCol(cell)[1];
    }
    return col;
  }

  function currentRow (sheet, row) {
    if (row == undefined) {
      var cell = getCurrentCell(sheet);
      return cell.parentNode;
    }
    return findRow(sheet, row);
  }

  function addRow (sheet, row) {

    save(sheet);

    row = currentRow(sheet, row);
    var cols = countCols(sheet);
    var newRow = createRow(null);
    var widths = getWidths(sheet);
    placeAfter(row, newRow);
    for (var x = 0; x < cols; x++) { createCell(newRow, '', widths[x]); }
    reclass(sheet);
  }

  function addCol (sheet, col) {

    save(sheet);

    col = currentCol(sheet, col);

    var cells = [];
    iterate(sheet, function (t, x, y, e) {
      if ((t == 'cell' || t == 'headcell') && x == col) cells.push(e);
    });
    var headcell = cells[0];
    var newHeadCell = renderHeadCell(headcell.parentNode, col);
    placeAfter(headcell, newHeadCell);
    for (var y = 1; y < cells.length; y++) {
      var cell = cells[y];
      var newCell = createCell(cell.parentNode, '');
      placeAfter(cell, newCell);
    }
    reclass(sheet);
  }

  function deleteCol (sheet, col) {

    if (countCols(sheet) <= 1) return;

    save(sheet);

    col = currentCol(sheet, col);
    var cells = [];
    iterate(sheet, function (t, x, y, e) {
      if ((t == 'cell' || t == 'headcell') && x == col) cells.push(e);
    });
    for (var y = 0; y < cells.length; y++) {
      var cell = cells[y];
      cell.parentNode.removeChild(cell);
    }
    reclass(sheet);
  }

  function deleteRow (sheet, row) {

    if (countRows(sheet) <= 1) return;

    save(sheet);
    
    var forgetCurrent = (row == undefined);
    row = currentRow(sheet, row);
    row.parentNode.removeChild(row);
    reclass(sheet);
    if (forgetCurrent) setCurrentCell(sheet, null);
  }

  function save (sheet) {
    sheet = findElt(sheet);
    if ( ! sheet.stack) sheet.stack = [];
    sheet.stack.push([ toArray(sheet), getWidths(sheet) ]);
    while (sheet.stack.length > 100) { sheet.stack.shift(); }
  }

  function undo (sheet) {
    sheet = findElt(sheet);
    if ( ! sheet.stack || sheet.stack.length < 1) return;
    var state = sheet.stack.pop();
    render(sheet, state[0], state[1]);
  }

  return { // the 'public' stuff

    render: render,
    renderEmpty: renderEmpty,
    addRow: addRow,
    addCol: addCol,
    deleteRow: deleteRow,
    deleteCol: deleteCol,
    undo: undo,
    toArray: toArray, // returns the current table as a JS array
    getWidths: getWidths, // returns the current widths (a JS array)
    focusedToArray: focusedToArray,
  };
}();

