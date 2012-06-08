if Meteor.is_client
    Template.hello.greeting = ->
        "Welcome to eurocup."

    Template.hello.events = "click #leaderboard": ->
        console.log "You clicked on the leaderboard tab"  if typeof console isnt "undefined"

if Meteor.is_server
    Meteor.startup ->
