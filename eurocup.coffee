if Meteor.is_client

    Meteor.startup ->

        $('.container').append Meteor.ui.render(Template.login)

        $('#sign_in').submit (e) ->

            e.preventDefault()

            Meteor.call 'get_person', $('#sign_in .input-large').val(), (e, person) ->

                Meteor.call 'add_person', {name: $('#sign_in .input-large').val()}
                Meteor.call 'get_person', $('#sign_in .input-large').val(), (e, new_person) ->
                    window.currentPerson = new_person

                    if not window.currentPerson.picks
                            window.currentPerson.picks = {}

                    console.log window.currentPerson.name

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

            $('#A1').change()
            $('#A2').change()
            $('#B1').change()
            $('#B2').change()
            $('#C1').change()
            $('#C2').change()
            $('#D1').change()
            $('#D2').change()

        $('#save').click ->
            $('.container select').each ->
                window.currentPerson.picks[$(this).attr('id')] = $(this).val()

            console.log window.currentPerson
            Meteor.call 'add_person', window.currentPerson

        $('#leaderboard').click ->

            Meteor.call "get_all_people", (error, results) ->
                leaderboard = []

                $.each results, (index, person) ->

                    if person.name != "admin"
                        leaderboard.push(name: person.name, score: calculate_persons_score person)



                $('.row').hide()
                $('.container').append Meteor.ui.render(Template.leaderboards)

                console.log leaderboard

                _.each leaderboard, (person) ->
                    $('#leaderboard_list').append '<li>Name: '+person.name+' Score: '+person.score+'</li>'
