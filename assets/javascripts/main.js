function copyTextToClipboard(text) {
    var copyFrom = $('<textarea/>');
    copyFrom.text(text);
    $('body').append(copyFrom);
    copyFrom.select();
    document.execCommand('copy');
    copyFrom.remove();
};

function html2haml(selectedText) {
  htmlSample = "{page: {html: '" + selectedText + "'}}";

  $.ajax({
    "url": "http://html2haml.heroku.com/api.json",
    "type": "POST",
    "data": htmlSample,
    "dataType": "json",
    "success": function(data) {
      alert(data.page.haml);
      copyTextToClipboard(data.page.haml);
    },
    "error": function(data) {
      alert('error');
    }
  });  
};

function css2sass(selectedText, sassType) {
  $.ajax({
    "url": "http://css2sass.heroku.com/json",
    "type": "POST",
    "data": {
      "page": {
        "css" : selectedText
      },
      "commit": "Convert 2" + " " + sassType
    },
    "dataType": "json",
    "success": function(data) {
      alert(data.page.sass);
      copyTextToClipboard(data.page.sass);
    },
    "error": function(data) {
      console.log(data)
      alert('error');
    }
  });  
};

function js2coffee(selectedText) { };


var hamlMenu = chrome.contextMenus.create({
  "title": "Copy as Haml",
  "contexts": ["selection"],
  "onclick": function(info, tab) {
    html2haml(info.selectionText);
  }
});

var sassMenu = chrome.contextMenus.create({
  "title": "Copy as SASS",
  "contexts": ["selection"],
  "onclick": function(info, tab) {
    css2sass(info.selectionText, "SASS");
  }
});

var scssMenu = chrome.contextMenus.create({
  "title": "Copy as SCSS",
  "contexts": ["selection"],
  "onclick": function(info, tab) {
    css2sass(info.selectionText, "SCSS");
  }
});

var sassMenu = chrome.contextMenus.create({
  "title": "Copy as Coffescript",
  "contexts": ["selection"],
  "onclick": function(info, tab) {
    js2coffee(info.selectionText);
  }
});
