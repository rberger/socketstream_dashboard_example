# Server-side Code

exports.actions =
      
  # Simulates hitting the API to influence a particular widget
  simulate: (data, cb) ->
    SS.publish.broadcast 'widgetUpdate', data
    cb data
    
  # insert widget into the mongo widgets collection
  # callback with the id referring to the widget
  createWidget: (data, cb) ->
    widget = new Widget data
    widget.save (err,doc) -> cb if !err then doc._id else false
  
  getWidgets: (cb) ->
    Widget.find {}, {}, {}, (err, docs) -> 
      cb docs.map (d) -> d.doc
