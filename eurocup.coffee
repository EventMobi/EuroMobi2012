if Meteor.is_client

    Meteor.startup ->

        $('.container').append Meteor.ui.render(Template.login)

        $('#sign_in').submit (e) ->

            e.preventDefault()

            if $('#sign_in .input-large').val() is 'admin'
                Meteor.call 'get_person', 'admin', (e, person) ->
                    window.currentPerson = person
                    populateUI(person)

            else

                Meteor.call 'get_person', $('#sign_in .input-large').val(), (e, person) ->

                    Meteor.call 'add_person', {name: $('#sign_in .input-large').val()}
                    Meteor.call 'get_person', $('#sign_in .input-large').val(), (e, new_person) ->
                        window.currentPerson = new_person

                        if not window.currentPerson.picks
                                window.currentPerson.picks = {}

                        populateUI(new_person)

            $('#sign_in').hide()

            $('.container').append Meteor.ui.render(Template.brackets)

            $('#A1').change ->
                $('#Q1').html('<option>' + $('#A1').val() + '</option><option>' + $('#B2').val() + '</option>')
                $('#Q1').change()

            $('#B2').change ->
                $('#Q1').html('<option>' + $('#A1').val() + '</option><option>' + $('#B2').val() + '</option>')
                $('#Q1').change()

            $('#C1').change ->
                $('#Q2').html('<option>' + $('#C1').val() + '</option><option>' + $('#D2').val() + '</option>')
                $('#Q2').change()

            $('#D2').change ->
                $('#Q2').html('<option>' + $('#C1').val() + '</option><option>' + $('#D2').val() + '</option>')
                $('#Q2').change()

            $('#A2').change ->
                $('#Q3').html('<option>' + $('#A2').val() + '</option><option>' + $('#B1').val() + '</option>')
                $('#Q3').change()

            $('#B1').change ->
                $('#Q3').html('<option>' + $('#A2').val() + '</option><option>' + $('#B1').val() + '</option>')
                $('#Q3').change()

            $('#C2').change ->
                $('#Q4').html('<option>' + $('#C2').val() + '</option><option>' + $('#D1').val() + '</option>')
                $('#Q4').change()

            $('#D1').change ->
                $('#Q4').html('<option>' + $('#C2').val() + '</option><option>' + $('#D1').val() + '</option>')
                $('#Q4').change()

            $('#Q1').change ->
                $('#S1').html('<option>' + $('#Q1').val() + '</option><option>' + $('#Q2').val() + '</option>')
                $('#S1').change()

            $('#Q2').change ->
                $('#S1').html('<option>' + $('#Q1').val() + '</option><option>' + $('#Q2').val() + '</option>')
                $('#S1').change()

            $('#Q3').change ->
                $('#S2').html('<option>' + $('#Q3').val() + '</option><option>' + $('#Q4').val() + '</option>')
                $('#S2').change()

            $('#Q4').change ->
                $('#S2').html('<option>' + $('#Q3').val() + '</option><option>' + $('#Q4').val() + '</option>')
                $('#S2').change()

            $('#S1').change ->
                $('#winner').html('<option>' + $('#S1').val() + '</option><option>' + $('#S2').val() + '</option>')

            $('#S2').change ->
                $('#winner').html('<option>' + $('#S1').val() + '</option><option>' + $('#S2').val() + '</option>')

        $('#save').click ->

            $('.container select').each ->
                window.currentPerson.picks[$(this).attr('id')] = $(this).val()

            if window.currentPerson.name is 'admin'
                Meteor.call 'admin_update', window.currentPerson
            else
                Meteor.call 'add_person', window.currentPerson

            $('#success_message').show();

            setTimeout ->
                $('#success_message').fadeOut()
            , 1000


        $('#leaderboard').click ->

            Meteor.call "get_all_people", (error, results) ->
                leaderboard = []

                $.each results, (index, person) ->

                    if person.name != "admin" and person.picks?
                        leaderboard.push(name: person.name, score: calculate_persons_score person)

                _.sortBy leaderboard, (person) ->
                    person.score


                $('.row').hide()
                $('#leaderboard_list').remove()
                $('.container').append Meteor.ui.render(Template.leaderboards)

                place = 0
                $('#leaderboard_list tbody').empty()
                _.each leaderboard, (person) ->
                    place++
                    $('#leaderboard_list tbody').append '<tr id="'+person.name+'"><td>'+place+'</td><td>'+person.name+'</td><td>'+person.score+'</td></tr>'

        # Reset view
        $('#brackets').click ->
            $('#sign_in').show()
            $('#leaderboard_list').remove()
            $('.row').remove()

        $('body').on 'click', 'tr', () ->

            $('#sign_in').hide()

            person_name = $(this).attr('id')

            Meteor.call 'get_person', person_name, (e, person) ->

                window.currentPerson = person

                $('.row').remove()
                $('.container').append Meteor.ui.render(Template.brackets)

                populatePrefilledUI(person)


populateUI = (person) ->
    $('#save').show()
    $('#welcome_message').show()
    $('#welcome_message').html('Hey ' + window.currentPerson.name + '!')

    $.each person.picks, (pick, team)->
        $('#' + pick).val(team)
        $('#' + pick).change()

populatePrefilledUI = (person) ->
    $.each person.picks, (pick, team)->
        if $('#' + pick).find('option').length is 0
            $('#' + pick).html('<option>'+team+'</option>')

        $('#' + pick).val(team)
        $('#' + pick).change()
