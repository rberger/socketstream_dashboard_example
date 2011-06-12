# Server-side Code

exports.actions =
      
  # Simulates hitting the API to influence a particular widget
  simulate: (data, cb) ->
    SS.publish.broadcast 'widgetUpdate', data
    cb data