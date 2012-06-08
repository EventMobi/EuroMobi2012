# Shared code - server and client

People = new Meteor.Collection("people")
People.default_data = 
    name : null
    picks : 
        groups :
            A1 : null
            A2 : null
            B1 : null
            B2 : null
            C1 : null
            C2 : null
            D1 : null
            D2 : null
        quarters :
            Q1 : null
            Q2 : null
            Q3 : null
            Q4 : null
        semis : 
            S1 : null 
            S2 : null
        finals : 
            winner: null
        tiebreaker : null

Meteor.methods(
    add_person : (person) ->
        # if already exists, do nothing
        existent = People.findOne(name : person.name)
        if existent?
            return new Meteor.Error(403, "Person already exists", "Sorry, but you only get one chance")
        else
            id = People.insert(person)
        return id

    get_person : (name) ->
        result = People.findOne(name : name)
        if result?
            return result
        else
            Meteor.Error(404, 'No result', 'Sign up first!')

    get_all_people : ->
        People.find({}).fetch()

    admin_update : (new_data) ->
        People.update({name : "admin"}, {$set : new_data})
)

if Meteor.is_server
    
    # Publish all the people
    Meteor.publish 'people', () -> People.find({}).fetch()

    Meteor.startup ->
        if People.find().count() == 0
            admin = People.default_data
            admin.name = "admin"
            People.insert(admin)

if Meteor.is_client

    Meteor.startup ->
        # Subscribe to dataset
        Meteor.subscribe('people')