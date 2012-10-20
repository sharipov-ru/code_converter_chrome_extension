function html2haml() {
  htmlSample = "{page: {html: '<h1>Hello World</h1>'}}";

  $.ajax({
    "url": "http://html2haml.heroku.com/api.json",
    "type": "POST",
    "data": htmlSample,
    "dataType": "json",
    "success": function(data) {
      alert(data.page.haml);
    },
    "error": function(data) {
      alert('error');
    }
  });  
};

var selectionParentMenu = chrome.contextMenus.create({
  "title": "Copy selected text as Haml",
  "contexts": ["selection"],
  "onclick": html2haml
});

// Create a parent item and two children.
// var parent = chrome.contextMenus.create({
//   "title": "Test parent item"
// });
// var child1 = chrome.contextMenus.create({
//   "title": "Child 1",
//   "parentId": parent,
//   "onclick": genericOnClick
// });
// var child2 = chrome.contextMenus.create({
//   "title": "Child 2",
//   "parentId": parent,
//   "onclick": genericOnClick
// });
// console.log("parent:" + parent + " child1:" + child1 + " child2:" + child2);
