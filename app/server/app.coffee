# Server-side Code

exports.actions =
      
  transmit: (data, cb) ->
    SS.publish.broadcast 'widgetUpdate', data
    cb data
    
  createWidget: (data, cb) ->
    widget = new Widget data
    widget.save (err,doc) -> cb if !err then doc else false
  
  getWidgets: (cb) ->
    Widget.find {}, {}, {}, (err, docs) -> cb docs.map (d) -> d.doc
    
  updateWidget: (data, cb) ->
    Widget.findById data._id, (err, doc) ->
      if !doc
        cb false
      else 
        for key,value of data
          doc[key] = value unless key is '_id'
        doc.save (err) -> cb if !err then doc else false
          
  deleteWidget: (id, cb) ->
    Widget.findById id, (err, doc) ->
      doc.remove (err) ->
        cb if !err then true else false