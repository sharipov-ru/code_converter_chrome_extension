class Application
  constructor: ->
    @setupContextMenus()
    @converter = new Converter()

  setupContextMenus: =>
    hamlMenu = chrome.contextMenus.create
      title: "Copy as Haml",
      contexts: ["selection"],
      onclick: (info, tab) =>
        @converter.html2haml(info.selectionText)

    sassMenu = chrome.contextMenus.create
      title: "Copy as SASS",
      contexts: ["selection"],
      onclick: (info, tab) =>
        @converter.css2sass(info.selectionText, "SASS")

    scssMenu = chrome.contextMenus.create
      title: "Copy as SCSS",
      contexts: ["selection"],
      onclick: (info, tab) =>
        @converter.css2sass(info.selectionText, "SCSS")

    sassMenu = chrome.contextMenus.create
      title: "Copy as Coffescript",
      contexts: ["selection"],
      onclick: (info, tab) =>
        @converter.js2coffee(info.selectionText)

class Converter
  html2haml: (selectedText) =>
    htmlSample = "{page: {html: '#{selectedText}'}}"
    notification = new Notification()
    notification.show("info", "Converting html to haml...", "Results will be copied to your system buffer")

    $.ajax
      url: "http://html2haml.heroku.com/api.json",
      type: "POST",
      data: htmlSample,
      dataType: "json",
      success: (data) ->
        clipboard = new Clipboard()
        clipboard.copy(data.page.haml)
        notification.show("success", "Converted!", "Results copied to your system buffer")
      error: (data) ->
        alert 'haml converting error'

  css2sass: (selectedText, sassType) =>
    $.ajax
      url: "http://css2sass.heroku.com/json",
      type: "POST",
      data:
        page:
          css : selectedText
        commit: "Convert 2" + " " + sassType
      dataType: "json",
      success: (data) ->
        clipboard = new Clipboard()
        clipboard.copy(data.page.sass)
        
        notification = new Notification()
        notification.show("success", "Converting css to #{sassType}...", "Results will be copied to your system buffer")
      error: (data) ->
        alert 'saas converting error'

  js2coffee: (selectedText) =>
    $.ajax
      url: "http://git.rordev.ru:8080/convert",
      type: "POST",
      data:
        js: selectedText,
      dataType: "json",
      success: (data) ->
        clipboard = new Clipboard()
        clipboard.copy(data.coffee)
        
        notification = new Notification()
        notification.show("success", "Converting js to coffeescript...", "Results will be copied to your system buffer")
      error: (data) ->
        alert 'coffescript converting error'

class Clipboard
  constructor: ->
    @document = document
    @from = $('<textarea/>')
    @body = $('body')

  copy: (text) =>
    @from.text(text)
    @body.append(@from)
    @from.select()
    @document.execCommand('copy')
    @from.remove()

# show notifications
class Notification
  SCRIPT_URL = "build/popup.js"

  show: (type, title, content) ->
    localStorage.setItem('converter-message-type', type)
    localStorage.setItem('converter-message-title', title)
    localStorage.setItem('converter-message-content', content)
    chrome.tabs.executeScript null, { file: SCRIPT_URL }

applcation = new Application()
chrome.extension.onMessage.addListener (request, sender, sendResponse) ->
  if (request.method == "getConverterData")
    response =
      type:    localStorage.getItem('converter-message-type')
      title:   localStorage.getItem('converter-message-title')
      content: localStorage.getItem('converter-message-content')
    sendResponse(response)
  else if (request.method == "clearConverterData")
    localStorage.setItem('converter-message-type', null)
    localStorage.setItem('converter-message-title', null)
    localStorage.setItem('converter-message-content', null)
    sendResponse({})
  else
    sendResponse({})
