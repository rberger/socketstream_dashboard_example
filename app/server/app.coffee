# Server-side Code

exports.actions =
      
  transmit: (data, cb) ->
    SS.publish.broadcast 'transmission', data
    cb data
    
  createWidget: (data, cb) ->
    if disabledForDemo
      cb false
    else    
      widget = new Widget data
      widget.save (err,doc) -> 
        SS.publish.broadcast 'addWidget', doc if !err
        cb if !err then doc else false
  
  getWidgets: (cb) ->
    Widget.find {}, {}, {}, (err, docs) -> cb docs.map (d) -> d.doc
    
  updateWidget: (data, cb) ->
    if disabledForDemo
      cb false # hardcore disable for now
    else    
      Widget.findById data._id, (err, doc) ->
        if !doc
          cb false
        else 
          for key,value of data
            doc[key] = value unless key is '_id'
          doc.save (err) -> 
            SS.publish.broadcast 'updateWidget', doc if !err
            cb if !err then doc else false
          
  deleteWidget: (id, cb) ->
    if disabledForDemo
      cb false # hardcore disable for now
    else
      Widget.findById id, (err, doc) ->
        doc.remove (err) ->
          SS.publish.broadcast 'removeWidget', id if !err
          cb if !err then true else false
    
disabledForDemo = true