class NotificationView
  SHOW_DELAY = 750
  HIDE_DELAY = 750
  TIMEOUT    = 3000

  constructor: (@messageType, @messageTitle, @messageContent) ->

  hasValidData: =>
    @messageType != 'null' && @messageTitle != 'null' && @messageContent != 'null'
    
  showNotification: =>
    $("body").append("<div class='converter-#{@messageType} converter-message'>
                        <h3>#{@messageTitle}</h3>
                        <p>#{@messageContent}</p>
                      </div>")

    htmlElement = $('.converter-error, .converter-success, .converter-info, .converter-warning')
    htmlElement.animate({top:"0"}, SHOW_DELAY)
    
    setTimeout ( ->
      htmlElement.animate({top:"-200"}, HIDE_DELAY)
    ), TIMEOUT
    

chrome.extension.sendMessage { method: "getConverterData" }, (response) ->
  notification = new NotificationView(response.type, response.title, response.content)

  if notification.hasValidData()
    notification.showNotification()

  # clear data
  chrome.extension.sendMessage {method: "clearConverterData"}
