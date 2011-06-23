# TODO - get batches of attractions into one array
exports.collections = [
  widgets: [
    {
      title:   "Random chart data"
      html:    '<div class="dynamicsparkline"></div>\n<div class="value">\n\t<label>Random Value:</label><span></span>\n</div>'
      css:     '.value {\n\tmargin-top: 10px;\n\tfont-size: 10pt;\n\tcolor: white;\n\ttext-shadow: 1px 1px 1px black;\n}\n\n.value label {\n\tfont-weight: bold;\n\tpadding-right: 10px;\n}\n\n.value span {\n\tcolor: #43EE00;\n}'
      coffee:  '$("#widget_"+data.id).find(\'.dynamicsparkline\').sparkline([data.amount, data.total-data.amount], type:\'pie\', width: \'100px\', height: \'100px\', sliceColors: ["#43EE00","rgba(255,255,255,0.05)"])\n$("#widget_"+data.id).find(\'.value span\').html "#{data.amount}/#{data.total}"'
      json:    "{amount: 15, total: 100}"
    },
    {
      title:   "socketracer.com CPU"
      html:    '<div class="value">⌛</div>'
      css:     '.value {\n\tpadding-top: 1em;\n\tfont-size: 8em;\n\tfont-weight: bold;\n\ttext-shadow: 1px 1px 1px black;\n\ttext-align: center;\n\tpadding-top: 0.5em;\n\tcolor: white;\n}'
      coffee:  '# All of your html is scoped to $("#widget_"+data.id)\n$("#widget_"+data.id).find(".value").text(data.value)'
      json:    "{value: 0.24}"
    },
    {
      title:   "socketracer.co CPU"
      html:    '<div class="value">⌛</div>'
      css:     '.value {\n\tpadding-top: 1em;\n\tfont-size: 8em;\n\tfont-weight: bold;\n\ttext-shadow: 1px 1px 1px black;\n\ttext-align: center;\n\tpadding-top: 0.5em;\n\tcolor: white;\n}'
      coffee:  '# All of your html is scoped to $("#widget_"+data.id)\n$("#widget_"+data.id).find(".value").text(data.value)'
      json:    "{value: 0.24}"
    },
    {
      title:   "SSDashboard.com CPU"
      html:    '<div class="value">⌛</div>'
      css:     '.value {\n\tpadding-top: 1em;\n\tfont-size: 8em;\n\tfont-weight: bold;\n\ttext-shadow: 1px 1px 1px black;\n\ttext-align: center;\n\tpadding-top: 0.5em;\n\tcolor: white;\n}'
      coffee:  '# All of your html is scoped to $("#widget_"+data.id)\n$("#widget_"+data.id).find(".value").text(data.value)'
      json:    "{value: 0.24}"
    }
  ]
]