# Client-side Code

exports.init = ->

  String::calculateColor = ->
    if @ <= 0.5
      "(#{Math.round(255*@)}, 255, 0)"  
    else
      "(255, #{Math.round(255*@)}, 0)" 

  SS.events.on 'widgetUpdate', (data) =>
    dataHolder = $("#widget_#{data.id} .content .load")
    dataHolder.text data.load
    dataHolder.css "color":"rgb#{data.load.calculateColor()}}"
  
  SS.socket.on 'disconnect', ->
    $('#message').text('SocketStream server has gone down :-(')

  SS.socket.on 'connect', ->
    $('#message').text('SocketStream server is back up :-)')