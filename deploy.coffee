control = require 'control'
task    = control.task

task 'myserver', 'config got my server', ->
  config = user: 'root'
  addresses = ['ssdashboard.com']
  return control.hosts(config, addresses)
  
task 'deploy', 'deploy the latest version of the app', (host) ->
  host.ssh 'cd socketstream_dashboard_example/ && git pull origin master', ->
    host.ssh 'sudo sh /etc/init.d/dashboard restart'

task 'update_dependencies', 'upgrade socketstream', (host) ->
  host.ssh 'cd socketstream/ && git pull origin master && sudo npm link', ->

control.begin()