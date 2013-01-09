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

    $.ajax
      url: "http://html2haml.heroku.com/api.json",
      type: "POST",
      data: htmlSample,
      dataType: "json",
      success: (data) ->
        alert data.page.haml
        clipboard = new Clipboard()
        clipboard.copy(data.page.haml)
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
        alert data.page.sass
        clipboard = new Clipboard()
        clipboard.copy(data.page.sass)
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
        alert data.coffee
        clipboard = new Clipboard()
        clipboard.copy(data.coffee)
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

applcation = new Application()
