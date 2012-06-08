if Meteor.is_client
    Template.hello.greeting = ->
        "Welcome to eurocup."

    Template.hello.events = "click input": ->
        console.log "You pressed the button"  if typeof console isnt "undefined"

if Meteor.is_server
    Meteor.startup ->