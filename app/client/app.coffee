# Client-side Code

exports.init = ->

  $('#overlay').live 'click', ->
    $('.dialogue').remove()
    $(@).remove()    

  window.widgetModel = new Model 'Widget', ->
    @unique_key = "_id"
    @include
      bindWidgetHtmlAndCss: ->
        $("#widget_#{@attributes._id}").find('.content').html @attributes.html
        cssContainer = $('<style type="text/css"></style>')
        cssContainer.text scopeCSS @attributes.css, @attributes._id
        $('head').append cssContainer
      executeCoffee: (data) ->
        window.data = data
        CoffeeScript.run @attributes.coffee
        
  widgetModel.bind "add", (newObject) ->
    widgetTemplate.add newObject.attributes
    newObject.bindWidgetHtmlAndCss()

  widgetModel.bind "remove", (removedObject) -> widgetTemplate.remove removedObject.attributes._id    
    
  window.widgetTemplate   = new SmartTemplate 'widget', bindDataToCssClasses: true
  window.dialogueTemplate = new SmartTemplate 'dialogue', templateHtml: $($("#dialogs-dialog").html()),  bindDataToCssClasses: true, appendTo: $('body'), afterAdd: (object) ->
    object.hide().fadeIn('slow')
    object.draggable {handle:'.dialogue-heading'}
    object.find('.dialogue-close').click ->
      window.dialogueTemplate.remove object.attr('id')
      $('#overlay').remove()
  
  SS.server.app.getWidgets (widgets) -> 
    new widgetModel(widget).save() for widget in widgets

  # Bind behaviour for creating a new widget
  $('#newWidget').click ->
        
    $('body').append("<div id='overlay'></div>")
    $('#overlay').hide().fadeIn()
    
    dialogueTemplate.add {id: 'new', 'dialogue-title': 'Create a new Widget'}
    dialogue = dialogueTemplate.findInstance('new')
    dialogue.find('.dialogue-content').html $($('#dialogs-widgetForm').html())
    dialogue.css top: "#{(document.height-dialogue.height())/2}px", left: "#{(document.width - dialogue.width())/2}px"
    
    $('.htmlContent textarea').val '<div class="value">⌛</div>'
    $('.cssContent textarea').val '.value {\n\tpadding-top: 1em;\n\tfont-size: 8em;\n\tfont-weight: bold;\n\ttext-shadow: 1px 1px 1px black;\n\ttext-align: center;\n\tpadding-top: 0.5em;\n\tcolor: white;\n}'
    $('.coffeeContent textarea').val '# All of your html is scoped to $("#widget_"+data.id)\n$("#widget_"+data.id).find(".value").text(data.value)'
    $('.jsonContent textarea').val '{value: 0.24}'
    
    renderLivePreview()
    
    $('form#widget input[name="title"]').live 'keyup', ->
        $('.demoContent').find('.title').text $('form#widget').find('input[name="title"]').val()    

    $('.tab').click ->
      $('.tab').removeClass('active')
      $('.tabContent').removeClass('active')
      $(@).addClass('active')
      id = $(@).attr('id')
      $('.'+id+'Content').addClass('active')
      renderLivePreview() if id is 'demo'
    
    $('form#widget').submit ->
      data = {title: $(@).find('input[name="title"]').val(), html: $('.htmlContent textarea').val(), css: $('.cssContent textarea').val(), coffee: $('.coffeeContent textarea').val(), json: $('.jsonContent textarea').val()}
      SS.server.app.createWidget data, (res) ->
        if res is false
          alert "Balls. Mongo doesn't like it :("
        else
          data._id = res._id
          new widgetModel(data).save()
          dialogueTemplate.remove 'new'
          dialogueTemplate.add {id: 'new', 'dialogue-title': 'Test your new Widget'}
          dialogue = dialogueTemplate.findInstance('new')          
          dialogue.find('.dialogue-content').html "<p>Ping this url to send data to your widget:</p><code><a href='#{buildApiUrl(data)}' target='_blank'>#{buildApiUrl(data)}</a></code>"
          dialogue.css top: "#{(document.height-dialogue.height())/2}px", left: "#{(document.width - dialogue.width())/2}px"
                    
      false

  # Change text color based on value
  # String::calculateColor = ->
  #   if @ <= 0.5 
  #     "(#{Math.round(255*@)}, 255, 0)"  
  #   else
  #     "(255, #{Math.round(255*@)}, 0)" 
  # 
  $('#widgets').sortable(handle: '.title')
  
  SS.events.on 'widgetUpdate', (data) ->
    widgetModel.find(data.id).executeCoffee data
  
  SS.socket.on 'disconnect', ->
    $('#message').text('SocketStream server has gone down :-(')

  SS.socket.on 'connect', ->
    $('#message').text('SocketStream server is back up :-)')
    
  scopeCSS = (text,id) ->
    lines = text.split("\n")
    for line in lines
      text = text.replace(line, "#widget_#{id} #{line}") if line.match(/{/) isnt null
    text
      
  # Deletes the widget
  $('.delete').live 'click', ->
    stopOwen = confirm("Do you want to delete this widget?")
    if stopOwen is true
      id = $(@).parent().parent().attr('id').split('_')[1]
      SS.server.app.deleteWidget id, (res) ->
        if res is true then widgetModel.find(id).destroy() else alert "There was an error deleting the widget"
      
  # Shows the configure widget dialog
  $('.config').live 'click', ->
  
    $('body').append("<div id='overlay'></div>")
    $('#overlay').hide().fadeIn()
  
    id = $(@).parent().parent().attr('id').split('_')[1]
    widget = widgetModel.find(id)
    dialogueTemplate.add {id: id, 'dialogue-title': "Edit Widget: #{widget.attributes.title}"}
    dialogue = dialogueTemplate.findInstance(id)
    dialogue.find('.dialogue-content').html $($('#dialogs-widgetForm').html())
    dialogue.find('.dialogue-content #theBoringBit').prepend "<div class='apiUrl'><b>API URL:</b> <a href='#{buildApiUrl(widget.attributes)}' target='_blank'>#{buildApiUrl(widget.attributes)}</a></div>"
    dialogue.css top: "#{(document.height-dialogue.height())/2}px", left: "#{(document.width - dialogue.width())/2}px"
    
    $('form#widget input[type="submit"]').val 'Save'
    
    $('.htmlContent textarea').val widget.attributes.html
    $('.cssContent textarea').val widget.attributes.css
    $('.coffeeContent textarea').val widget.attributes.coffee
    $('.jsonContent textarea').val widget.attributes.json
    $('form#widget').find('input[name="title"]').val widget.attributes.title   
    
    renderLivePreview()

    $('form#widget input[name="title"]').live 'keyup', ->
        $('.demoContent').find('.title').text $('form#widget').find('input[name="title"]').val()    

    $('.tab').click ->
      $('.tab').removeClass('active')
      $('.tabContent').removeClass('active')
      $(@).addClass('active')
      id = $(@).attr('id')
      $('.'+id+'Content').addClass('active')
      renderLivePreview() if id is 'demo'

    # form submit
    $('form#widget').submit ->
      data = {_id: widget.id(), title: $(@).find('input[name="title"]').val(), html: $('.htmlContent textarea').val(), css: $('.cssContent textarea').val(), coffee: $('.coffeeContent textarea').val(), json: $('.jsonContent textarea').val()}
      SS.server.app.updateWidget data, (res) ->        
        if res is false
          alert "Balls. Mongo doesn't like it :("
        else
          dialogueTemplate.remove widget.id()          
          $('#overlay').remove()
          widget.attr(key,value) for key,value of res
          widget.save()
          widgetTemplate.update widgetModel.find(widget.id()).attributes
          widget.bindWidgetHtmlAndCss()
      false

  renderLivePreview = ->
    window.data = {id:'preview'}
    html = $('.widget.template').clone().removeClass('template').attr('id','widget_preview').show()
    html.find('.title').text $('form#widget').find('input[name="title"]').val()
    html.find('.content').html $('.htmlContent textarea').val()
    $('.demoContent').html html
    $('#cssHolder').html $('.cssContent textarea').val()
    window.dataToMerge = eval("obj = #{$('.jsonContent textarea').val()}")
    data[key] = value for key,value of dataToMerge 
    CoffeeScript.run $('.coffeeContent textarea').val()
    
  buildApiUrl = (data) ->
    string = []
    string.push "&#{key}=#{value}" for key,value of eval("obj = #{data.json}")
    "#{document.location.href}api/app/transmit?id=#{data._id}#{string.join()}"