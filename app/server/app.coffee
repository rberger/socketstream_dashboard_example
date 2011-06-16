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
    widget.save (err,doc) -> cb if !err then doc else false
  
  # Get all of the widgets in the DB
  getWidgets: (cb) ->
    Widget.find {}, {}, {}, (err, docs) -> cb docs.map (d) -> d.doc
    
  # Update a widget  
  updateWidget: (data, cb) ->
    Widget.update {_id: data._id}, data, {}, (err, doc) ->
      cb if !err then doc else false
    
  # Remove a widget
  deleteWidget: (id, cb) ->
    Widget.findById id, (err, doc) ->
      doc.remove (err) ->
        cb if !err then true else false