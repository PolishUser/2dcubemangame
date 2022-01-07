

/mob
	var/next_move = 0
	var/movement_delay = 1

/client/Move(loc, dir)
	if (mob.next_move > world.time)
		return
	var/diag = 1 + (0.41421 * ((dir - 1) & dir == 0))
	mob.next_move = world.time + mob.movement_delay * diag
	mob.glide_size = DELAY2GLIDESIZE(mob.movement_delay) * diag
	step(mob, dir)

// From /vg/station13 - https://github.com/vgstation-coders/vgstation13
/client
	var/tmp
		mloop = 0
		move_dir = 0
		true_dir = 0
		keypresses = 0

var/static/list/opposite_dirs = list(SOUTH,NORTH,NORTH|SOUTH,WEST,SOUTHWEST,NORTHWEST,NORTH|SOUTH|WEST,EAST,SOUTHEAST,NORTHEAST,NORTH|SOUTH|EAST,WEST|EAST,WEST|EAST|NORTH,WEST|EAST|SOUTH,WEST|EAST|NORTH|SOUTH)

/client/verb/MoveKey(Dir as num, State as num)
	set hidden = 1
	set instant = 1
	if(!move_dir)
		. = 1
	var/opposite = opposite_dirs[Dir]
	if (State)
		move_dir |= Dir
		keypresses |= Dir
		if (opposite & keypresses)
			move_dir &= ~opposite

	else
		move_dir &= ~Dir
		keypresses &= ~Dir
		if (opposite & keypresses)
			move_dir |= opposite

		else
			move_dir |= keypresses

	true_dir = move_dir
	if(. && true_dir)
		move_loop()

/client/North()
/client/South()
/client/East()
/client/West()

/client/proc/move_loop()
	set waitfor = 0
	if (src.mloop) return
	mloop = 1
	src.Move(mob.loc, true_dir)
	while (src.true_dir)
		sleep (world.tick_lag)
		if (src.true_dir)
			src.Move(mob.loc, true_dir)
	mloop = 0