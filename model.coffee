# Shared code - server and client

currentPerson = null

populateUI = (person) ->
    $('#save').show();
    $('#welcome_message').show();
    $('#welcome_message').html('Hey ' + window.currentPerson.name + '!')

    $.each person.picks, (pick, team)->
        $('#' + pick).val(team)
        $('#' + pick).change()
    

People = new Meteor.Collection("people")
People.default_data =
    name : null
    picks :
        A1 : null
        A2 : null
        B1 : null
        B2 : null
        C1 : null
        C2 : null
        D1 : null
        D2 : null
        Q1 : null
        Q2 : null
        Q3 : null
        Q4 : null
        S1 : null
        S2 : null
        winner: null
        tiebreaker : null

Meteor.methods(
    add_person : (person) ->
        # if already exists, do nothing
        existent = People.findOne(name : person.name)
        if existent? and existent.picks?
            return new Meteor.Error(403, "Person already exists", "Sorry, but you only get one chance")
        else
            if existent?
                id = People.update({name: existent.name}, person)
            else
                id = People.insert(person)
        return id

    get_person : (name) ->
        result = People.findOne(name : name)
        if result?
            return result
        else
            return false

    get_all_people : ->
        People.find({}).fetch()

    admin_update : (new_data) ->
        People.update({name : "admin"}, new_data)
)

if Meteor.is_server

    # Publish all the people
    Meteor.publish 'people', () -> People.find({}).fetch()

    Meteor.startup ->
        if People.findOne({name:"admin"}) == undefined
            admin = People.default_data
            admin.name = "admin"
            People.insert(admin)

if Meteor.is_client

    Meteor.startup ->
        # Subscribe to dataset
        Meteor.subscribe('people')