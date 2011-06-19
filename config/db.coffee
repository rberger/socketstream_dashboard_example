# Place your Database config here

global.mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/dashboard'

global.Schema   = mongoose.Schema
global.ObjectId = Schema.ObjectId

global.Widgets = new Schema
  title  : String
  html   : String
  css    : String
  coffee : String
  json   : String
  
global.Widget = mongoose.model 'Widget', Widgets  