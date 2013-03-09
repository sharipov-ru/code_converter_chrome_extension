class Application
  constructor: ->
    @setupContextMenus()
    @setupMessageListener()
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

  setupMessageListener: ->
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

class Converter
  constructor: ->
    @notification = new Notification()
  
  html2haml: (selectedText) =>
    htmlSample = "{page: {html: '#{selectedText}'}}"
    @notification.showInfo("Converting html to haml...")

    $.ajax
      url: "http://html2haml.heroku.com/api.json",
      type: "POST",
      data: htmlSample,
      dataType: "json",
      success: (data) =>
        clipboard = new Clipboard()
        clipboard.copy(data.page.haml)
        @notification.showSuccess()
      error: (data) =>
        @notification.showError()

  css2sass: (selectedText, sassType) =>
    @notification.showInfo("Converting css to #{sassType}...")
    
    $.ajax
      url: "http://css2sass.heroku.com/json",
      type: "POST",
      data:
        page:
          css : selectedText
        commit: "Convert 2" + " " + sassType
      dataType: "json",
      success: (data) =>
        clipboard = new Clipboard()
        clipboard.copy(data.page.sass)
        @notification.showSuccess()
      error: (data) =>
        @notification.showError()

  js2coffee: (selectedText) =>
    @notification.showInfo("Converting js to coffeescript...")

    $.ajax
      url: "http://git.rordev.ru:8080/convert",
      type: "POST",
      data:
        js: selectedText,
      dataType: "json",
      success: (data) =>
        clipboard = new Clipboard()
        clipboard.copy(data.coffee)
        @notification.showSuccess()
      error: (data) =>
        @notification.showError()

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

  INFO_MESSAGE    = 'Results will be copied to your system buffer'
  ERROR_MESSAGE   = 'Please, make sure that snippet syntax is OK'
  SUCCESS_MESSAGE = 'Results copied to your system buffer'
  
  show: (type, title, content) ->
    localStorage.setItem('converter-message-type', type)
    localStorage.setItem('converter-message-title', title)
    localStorage.setItem('converter-message-content', content)
    chrome.tabs.executeScript null, { file: SCRIPT_URL }

  showInfo: (title) ->
    @show('info', title, INFO_MESSAGE)

  showError: () ->
    @show('error', 'API Error', ERROR_MESSAGE)

  showSuccess: () ->
    @show("success", "Converted!", SUCCESS_MESSAGE)

applcation = new Application()
