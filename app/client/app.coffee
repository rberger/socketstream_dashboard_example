# Client-side Code

exports.init = ->

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

  widgetModel.bind "remove", (removedObject) ->
    widgetTemplate.remove removedObject.attributes._id
    
  widgetTemplate = new SmartTemplate 'widget', bindDataToCssClasses: true
  
  SS.server.app.getWidgets (widgets) -> 
    new widgetModel(widget).save() for widget in widgets

  # Bind behaviour for creating a new widget
  $('#newWidget').click ->
        
    $('body').append("<div id='overlay'></div>")
    $('#overlay').hide().fadeIn 'slow'
    
    # $('form#Widget').fadeIn().css('z-index':'2')
    # 
    # 
    # $('form#Widget').find('input[name="title"]').keyup ->
    #   $('.demoContent').find('.title').text $('form#Widget').find('input[name="title"]').val()
    # 
    # 
    # $('.tab').click ->
    #   $('.tab').removeClass('active')
    #   $('.tabContent').removeClass('active')
    #   $(@).addClass('active')
    #   id = $(@).attr('id')
    #   $('.'+id+'Content').addClass('active')
    #   if id is 'demo'
    #     window.data = {id:'preview'}
    #     html = $('<div class="widget" id="widget_preview"><div class="title"></div><div class="content"></div></div>')
    #     html.find('.title').text $('form#Widget').find('input[name="title"]').val()
    #     html.find('.content').html $('.htmlContent textarea').val()
    #     $('.demoContent').html html
    #     $('#cssHolder').html $('.cssContent textarea').val()
    #     window.dataToMerge = eval("obj = #{$('.jsonContent textarea').val()}")
    #     data[key] = value for key,value of dataToMerge 
    #     CoffeeScript.run $('.coffeeContent textarea').val()
    # 
    # $('form#Widget').submit ->
    #   data = {title: $(@).find('input[name="title"]').val(), html: $('.htmlContent textarea').val(), css: $('.cssContent textarea').val(), coffee: $('.coffeeContent textarea').val(), json: $('.jsonContent textarea').val()}
    #   SS.server.app.createWidget data, (res) ->
    #     if res is false
    #       alert "Balls. Mongo doesn't like it :("
    #     else
    #       
    #       $('form#Widget').hide();
    #       data._id = res._id
    #       new widgetModel(data).save()
    #       
    #       string = []
    #       for key,value of eval("obj = #{data.json}")
    #         string.push "&#{key}=#{value}"
    #             
    #       urlToPing = document.location.href + "api/app/simulate?id=#{data._id}#{string.join()}"
    #       $('body').append("<div id='overlay'><div id='dialog'><p>Ping this url to send data to your widget:</p><code><a href='#{urlToPing}' target='_blank'>#{urlToPing}</a></code></div></div>")
    #   false

  # Change text color based on value
  String::calculateColor = ->
    if @ <= 0.5 
      "(#{Math.round(255*@)}, 255, 0)"  
    else
      "(255, #{Math.round(255*@)}, 0)" 

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
    id = $(@).parent().parent().attr('id').split('_')[1]
    SS.server.app.deleteWidget id, (res) ->
      if res is true then widgetModel.find(id).destroy() else alert "There was an error deleting the widget"
      
  # Shows the configure widget dialog
  $('.config').live 'click', ->
    id = $(@).parent().parent().attr('id').split('_')[1]
    $('body').append("<div id='overlay'><div id='dialog'>"+$('form#Widget').clone()+"</div></div>")
    
  
      
  