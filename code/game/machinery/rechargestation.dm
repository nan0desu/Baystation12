/obj/machinery/recharge_station
	name = "cyborg recharging station"
	icon = 'icons/obj/objects.dmi'
	icon_state = "borgcharger0"
//	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 1000
	var/mob/occupant = null

	density = 0

	var/open = 1
	var/construct_op = 0
	var/circuitboard = "/obj/item/weapon/circuitboard/cyborgrecharger"
	var/locked = 1
	req_access = list(access_robotics)
	var/recharge_speed
	var/repairs



	New()
		..()
	//---------------------------------------------------
		component_parts = list()
		component_parts += new /obj/item/weapon/circuitboard/cyborgrecharger(null)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(null)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(null)
		component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
		component_parts += new /obj/item/weapon/cell/high(null)
		RefreshParts()
	//---------------------------------------------------
		build_icon()
	//---------------------------------------------------
	RefreshParts()
		recharge_speed = 0
		repairs = 0
		for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
			recharge_speed += C.rating * 100
		for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
			repairs += M.rating - 1
		for(var/obj/item/weapon/cell/C in component_parts)
			recharge_speed *= C.maxcharge / 10000
	//---------------------------------------------------
	process()
		if(!(NOPOWER|BROKEN))
			return

		if(src.occupant)
			process_occupant()
		return 1


	allow_drop()
		return 0


	relaymove(mob/user as mob)
		if(user.stat)
			return
		src.go_out()
		return

	emp_act(severity)
		if(stat & (BROKEN|NOPOWER))
			..(severity)
			return
		if(occupant)
			occupant.emp_act(severity)
			go_out()
		..(severity)

	proc
		build_icon()
			if(NOPOWER|BROKEN)
				if(open)
					icon_state = "borgcharger0"
				else
					if(occupant)
						icon_state = "borgcharger1"
					else
						icon_state = "borgcharger2"
			else
				icon_state = "borgcharger0"

		process_occupant()
			if(src.occupant)
				if (istype(occupant, /mob/living/silicon/robot))
					var/mob/living/silicon/robot/R = occupant
					if(R.module)
						R.module.respawn_consumable(R)
					if(!R.cell)
						return
					else if(R.cell.charge >= R.cell.maxcharge)
						R.cell.charge = R.cell.maxcharge
						return
					else
						R.cell.charge = min(R.cell.charge + 200, R.cell.maxcharge)
						return

		go_out()
			if(!( src.occupant ))
				return
			//for(var/obj/O in src)
			//	O.loc = src.loc
			if (src.occupant.client)
				src.occupant.client.eye = src.occupant.client.mob
				src.occupant.client.perspective = MOB_PERSPECTIVE
			src.occupant.loc = src.loc
			src.occupant = null
			build_icon()
			src.use_power = 1
			return


	verb
		move_eject()
			set category = "Object"
			set src in oview(1)
			if (usr.stat != 0)
				return
			src.go_out()
			add_fingerprint(usr)
			return

		move_inside()
			set category = "Object"
			set src in oview(1)
			if (usr.stat == 2)
				//Whoever had it so that a borg with a dead cell can't enter this thing should be shot. --NEO
				return
			if (!(istype(usr, /mob/living/silicon/)))
				usr << "\blue <B>Only non-organics may enter the recharger!</B>"
				return
			if (src.occupant)
				usr << "\blue <B>The cell is already occupied!</B>"
				return
			if (!usr:cell)
				usr<<"\blue Without a powercell, you can't be recharged."
				//Make sure they actually HAVE a cell, now that they can get in while powerless. --NEO
				return
			usr.stop_pulling()
			if(usr && usr.client)
				usr.client.perspective = EYE_PERSPECTIVE
				usr.client.eye = src
			usr.loc = src
			src.occupant = usr
			/*for(var/obj/O in src)
				O.loc = src.loc*/
			src.add_fingerprint(usr)
			build_icon()
			src.use_power = 2
			return


	attack_paw(user as mob)
		return attack_hand(user)

	attack_ai(user as mob)
		return attack_hand(user)

	attackby(obj/item/P as obj, mob/user as mob)
		if(open)
			if(default_deconstruction_screwdriver(user, "borgdecon2", "borgcharger0", P))
				return

		if(exchange_parts(user, P))
			return

		default_deconstruction_crowbar(P)

	attack_hand(user as mob)
		if(..())	return
		if(construct_op == 0)
			toggle_open()
		else
			user << "The recharger can't be closed in this state."
		add_fingerprint(user)

	proc
		toggle_open()
			if(open)
				close_machine()
			else
				open_machine()

	open_machine()
		if(occupant)
			if (occupant.client)
				occupant.client.eye = occupant
				occupant.client.perspective = MOB_PERSPECTIVE
			occupant.loc = loc
			occupant = null
			use_power = 1
		open = 1
		density = 0
		build_icon()

	close_machine()
		if(!panel_open)
			for(var/mob/living/silicon/robot/R in loc)
				R.stop_pulling()
				if(R.client)
					R.client.eye = src
					R.client.perspective = EYE_PERSPECTIVE
				R.loc = src
				occupant = R
				use_power = 2
				add_fingerprint(R)
				break
			open = 0
			density = 1
			build_icon()