Meteor.call("add_person", {
    name : "Bijan6"
    picks :
        A1 : "Greence"
        A2 : "Polance"
        B1 : "Pontugal"
        B2 : "Jermaney"
        C1 : "Espoon"
        C2 : "Eyetaly"
        D1 : "Fancie"
        D2 : "Sveeden"
        Q1 : "Greence"
        Q2 : "Jermaney"
        Q3 : "Espoon"
        Q4 : "Fancie"
        S1 : "Jermaney"
        S2 : "Espoon"
        winner: "Espoon"
        tiebreaker : 12
    },
    (error, result) ->
        console.log result
)

calculate_persons_score = (person) ->

    total_score = 0

    admin = People.findOne({name: "admin"})

    total_score = calculate_group_stage_score person.picks, admin.picks
    total_score = total_score + calculate_quarters_score person.picks, admin.picks
    total_score = total_score + calculate_semis_score person.picks, admin.picks
    total_score = total_score + calculate_finals_score person.picks.winner, admin.picks.winner
    total_score = total_score + calculate_tiebreaker_score person.picks.tiebreaker, admin.picks.tiebreaker

    total_score

calculate_group_stage_score = (group_picks, admin_picks) ->

    score = 0

    # If no entries made yet, return 0 as the score
    0 if _.isEmpty(group_picks)

    # If you guessed right, you get two points
    score = score + 2 if group_picks.A1 is admin_picks.A1
    score = score + 2 if group_picks.B1 is admin_picks.B1
    score = score + 2 if group_picks.C1 is admin_picks.C1
    score = score + 2 if group_picks.D1 is admin_picks.D1
    score = score + 2 if group_picks.A2 is admin_picks.A2
    score = score + 2 if group_picks.B2 is admin_picks.B2
    score = score + 2 if group_picks.C2 is admin_picks.C2
    score = score + 2 if group_picks.D2 is admin_picks.D2

    #If you were one off you only get one point
    score = score + 1 if group_picks.A1 is admin_picks.A2
    score = score + 1 if group_picks.A2 is admin_picks.A1

    score = score + 1 if group_picks.B1 is admin_picks.B2
    score = score + 1 if group_picks.B2 is admin_picks.B1

    score = score + 1 if group_picks.C1 is admin_picks.C2
    score = score + 1 if group_picks.C2 is admin_picks.C1

    score = score + 1 if group_picks.D1 is admin_picks.D2
    score = score + 1 if group_picks.D2 is admin_picks.D1

    score

calculate_quarters_score = (quarters_picks, admin_picks) ->

    score = 0

    # If no entries made yet, return 0 as the score
    0 if _.isEmpty(quarters_picks)

    score = score + 4 if quarters_picks.Q1 is admin_picks.Q1
    score = score + 4 if quarters_picks.Q2 is admin_picks.Q2
    score = score + 4 if quarters_picks.Q3 is admin_picks.Q3
    score = score + 4 if quarters_picks.Q4 is admin_picks.Q4

    score

calculate_semis_score = (semis_picks, admin_picks) =>

    score = 0

    # If no entries made yet, return 0 as the score
    0 if _.isEmpty(semis_picks)

    score = score + 8 if semis_picks.S1 is admin_picks.S1
    console.log score
    score = score + 8 if semis_picks.S2 is admin_picks.S2
    console.log score
    score

calculate_finals_score = (finals_picks, admin_picks) ->

    score = 0

    # If no entries made yet, return 0 as the score
    0 if _.isEmpty(finals_picks)

    if finals_picks is admin_picks
        16
    else
        0

calculate_tiebreaker_score = (tiebreaker, admin_picks) ->

    score = 0

    # If no entries made yet, return 0 as the score
    0 if _.isNull(tiebreaker)

    if tiebreaker is admin_picks
        10
    else
        0

populate_leaderboard = (collection) ->
    leaderboard = []
    Meteor.call "get_all_people", (error, results) ->
        _.each results, (person) ->
            if person.name != "admin"
                leaderboard.push(name: person.name, score: calculate_persons_score person)

            console.log leaderboard