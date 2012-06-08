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
            A : null
            B : null
            C : null
            D : null
        semis : 
            A : null 
            B : null
        finals : 
            winner: null
        tiebreaker : null

Meteor.methods(
    add_person : (person) ->
        # if already exists, do nothing
        existent = People.findOne(name : person.name)
        if existent?
            Meteor.Error(403, "Person already exists", "Sorry, but you only get one chance")
        else
            People.insert(person)

    get_person : (name) ->
        People.findOne(name : name)

    get_all_people : () ->
        Person.find()
)

if Meteor.is_server
    Meteor.startup ->
        if People.find().count() == 0
            admin = People.default_data
            admin.name = "admin"
            People.insert(admin)
