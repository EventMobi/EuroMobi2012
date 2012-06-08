if Meteor.is_client
    
    Meteor.startup ->
        $('.nav').hide()
        $('.container').append Meteor.ui.render(Template.login)
        $('#sign_in').submit ->
            Meteor.call 'get_person', $('#sign_in .input-large').val(), (e, person) ->
                
                Meteor.call 'add_person', {name: $('#sign_in .input-large').val()}
                Meteor.call 'get_person', $('#sign_in .input-large').val(), (e, new_person) ->
                    currentPerson = new_person
                    populateUI(new_person)

            $('#sign_in').hide()
            $('.container').append Meteor.ui.render(Template.brackets)
        #   true

if Meteor.is_server
    Meteor.startup ->
