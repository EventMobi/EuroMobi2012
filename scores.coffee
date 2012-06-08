calculate_persons_score = (person) ->

	admin = People.findOne({name: "admin"})

	total_score = calculate_group_stage_score person.picks.groups, admin.picks.groups
	total_score = total_score + calculate_quarters_score person.picks.quarters, admin.picks.quarters
	total_score = total_score + calculate_semis_score person.picks.semis, admin.picks.semis
	total_score = total_score + calculate_finals_score person.picks.finals.winner, admin.picks.finals.winner
	total_score = total_score + calculate_tiebreaker_score person.picks.tiebreaker, admin.picks.tiebreaker

	total_score

calculate_group_stage_score = (group_picks, admin_picks) ->

	# If no entries made yet, return 0 as the score
	0 if _.isEmpty(group_picks)

	# If you guessed right, you get two points
	score = score + 2 if group_picks.A1 = admin_picks.A1
	score = score + 2 if group_picks.B1 = admin_picks.B1
	score = score + 2 if group_picks.C1 = admin_picks.C1
	score = score + 2 if group_picks.D1 = admin_picks.D1
	score = score + 2 if group_picks.A2 = admin_picks.A2
	score = score + 2 if group_picks.B2 = admin_picks.B2
	score = score + 2 if group_picks.C2 = admin_picks.C2
	score = score + 2 if group_picks.D2 = admin_picks.D2

	#If you were one off you only get one point
	score = score + 1 if group_picks.A1 = admin_picks.A2
	score = score + 1 if group_picks.A2 = admin_picks.A1

	score = score + 1 if group_picks.B1 = admin_picks.B2
	score = score + 1 if group_picks.B2 = admin_picks.B1

	score = score + 1 if group_picks.C1 = admin_picks.C2
	score = score + 1 if group_picks.C2 = admin_picks.C1

	score = score + 1 if group_picks.D1 = admin_picks.D2
	score = score + 1 if group_picks.D2 = admin_picks.D1

	score

calculate_quarters_score = (quarters_picks, admin_picks) ->

	# If no entries made yet, return 0 as the score
	0 if _.isEmpty(quarters_picks)

	score = score + 4 if quarters_picks.Q1 = admin_picks.Q1
	score = score + 4 if quarters_picks.Q2 = admin_picks.Q2
	score = score + 4 if quarters_picks.Q3 = admin_picks.Q3
	score = score + 4 if quarters_picks.Q4 = admin_picks.Q4

	score

calculate_semis_score = (semis_picks, admin_picks) ->

	# If no entries made yet, return 0 as the score
	0 if _.isEmpty(semis_picks)

	score = score + 8 if semi_picks.S1 = admin_picks.S1
	score = score + 8 if semi_picks.S2 = admin_picks.S2

	score

calculate_finals_score = (finals_picks, admin_picks) ->

	# If no entries made yet, return 0 as the score
	0 if _.isEmpty(finals_picks)

	if finals_picks is admin_picks
		16
	else
		0

calculate_tiebreaker_score = (tiebreaker, admin_picks) ->

	# If no entries made yet, return 0 as the score
	0 if _.isNull(tiebreaker)

	if tiebreaker is admin_picks
		10
	else
		0

populate_leaderboard = (collection) ->
	_.each collection (person) ->
		if person.name is not "admin"
			leaderboard.push(name: person.name, score: calculate_persons_score person)
			console.log leaderboard