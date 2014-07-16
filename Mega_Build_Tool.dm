//-----------------------------------------------------------------------------//-----------------------------------------------------------------------------
/turf/simulated/floor/plating/winturf
	name = "plating"
	icon_state = "plating"
	floor_tile = null
	intact = 0

/turf/simulated/floor/plating/winturf/New(turf/location as turf)
	new/obj/structure/grille(locate(location.x, location.y, location.z))
	var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(locate(location.x, location.y, location.z))
	WIN.dir = NORTHWEST

/turf/simulated/floor/plating/door
	name = "plating"
	icon_state = "plating"
	floor_tile = null
	intact = 0

/turf/simulated/floor/door/New(turf/location as turf)
	new/obj/machinery/door/airlock(locate(location.x, location.y, location.z))
//-----------------------------------------------------------------------------//-----------------------------------------------------------------------------

/obj/item/weapon/Mega_Build_Tool
	icon = 'icons/obj/autopsy_scanner.dmi'
	icon_state = ""
	name = "Tool of God"
	var/COD

	var/error

	var/list/grid = new/list(10,10)
	var/DrX = 10
	var/DrY = 10

	var/list/A ()
	var/list/B ()

	var/LG = "1 /turf/simulated/wall\n2 /turf/floor 'floor.dmi'\n3 /turf/simulated/floor/plating/winturf\n4 /turf/simulated/floor/door"
	var/list/LeG ()
	LeG = list ("1", "2", "3")

	verb/Pos()
		usr << "[usr.x] : [usr.y]"

	New()
		COD = "3 1 1 1 1 1 1 1 1 3\n3 2 2 2 2 2 2 2 2 3\n3 2 2 2 2 2 2 2 2 3\n3 2 2 1 1 2 1 2 2 3\n3 2 2 1 2 2 1 2 2 3\n3 2 2 1 2 2 1 2 2 3\n3 2 2 1 1 1 1 2 2 3\n3 2 2 2 2 2 2 2 2 3\n3 2 2 2 2 2 2 2 2 3\n3 1 1 1 2 2 1 1 1 3"
//-

	attack_self()

		var/t = "<TT><B>Tool of God</B><HR>"
		t += "<B><span class='danger'>[error]</span></B><HR>"
		t += "<BR><A href='?src=\ref[src];action=See Drawning'>See Drawning</A><BR>"
		t += "<BR><A href='?src=\ref[src];action=Change drawning Razmer'>Change drawning Razmer</A><BR>"
		t += "<BR><A href='?src=\ref[src];action=Change drawning'>Change drawning</A><BR>"
		t += "<BR><A href='?src=\ref[src];action=Enter LG'>Enter LG</A><BR>"
		t += "<BR><A href='?src=\ref[src];action=Use God POWER'>Use God POWER</A><BR>"
		t += "<BR></table></FONT></PRE></TT>"

		usr << browse(t, "window=traffic_control;size=575x400")

	Topic(href, list/href_list)
		error = ""
		switch(href_list["action"])

			if("return")
				attack_self()
				return

			if("See Drawning")

				var/dat = "<TITLE>Drawning</TITLE><center> <A href='?src=\ref[src];action=return'>Return</A> <IMG CLASS=icon SRC=\ref['icons/turf/areas.dmi']><IMG CLASS=icon SRC=\ref['icons/turf/areas.dmi']><IMG CLASS=icon SRC=\ref['icons/turf/areas.dmi']><IMG CLASS=icon SRC=\ref['icons/turf/areas.dmi']><IMG CLASS=icon SRC=\ref['icons/turf/areas.dmi']> <A href='?src=\ref[src];action=Use God POWER'>Use God POWER</A> </center><br><center>"

				for(var/u = DrY, u >= 1, u--)
					for(var/i = 1,i <= DrX, i++)

						if (LeG.Find(grid [i][u],1,0))
							var/o = LeG [LeG.Find(grid [i][u],1,0) + 2]

							dat += "<IMG CLASS=icon SRC=\ref[o]>"
							// ICONSTATE='[usr.icon_state]'>"
						else
							dat += "<IMG CLASS=icon SRC=\ref['icons/turf/areas.dmi']>"

					dat += "<br>"
					del(B)

				usr << browse(dat, "window=traffic_control;size=575x400")
				del(A)

				return

			if("Enter LG")

				LG = input("Enter LG:", "LG", "[LG]", null)  as message
				LeG = list (  )
				var/n = 1
				var/pz = 1

				A = text2list(LG, "\n") // A -> cod1|cod2|cod3
				for(var/u = 1, u <= length(A), u++)

					B = text2list(A [u], " ") // B -> n11 n12 n13|n21 n22 n23|...
					for(var/i = 1, i <= length(B), i++)

						switch(n)
							if(1)
								pz = B [i]
								LeG.Add(pz)
								n++
							if(2)
								pz = text2path(B [i])

								LeG.Add(pz)

								var/ob = B [i]
								var/obj/ico = new ob (locate(2,2,2))
								pz = ico.icon
								n = 1
								del(ico)

								LeG.Add(pz)

								n=1

					del(B)
				del(A)

				for(var/u = 1, u <= length(LeG), u++)
					error += "Test:[u] - [LeG [u]]<br>"

				attack_self()
				return
			if("Change drawning")

				COD = input("Enter what you want to build:", "Drawning", "[COD]", null)  as message
				A = text2list(COD, "\n") // A -> cod1|cod2|cod3
				var/ul = 1

				if (length(A)>DrY)
					error += "Number of string > Drawning Y!"
					return

				for(var/u = length(A), u >= 1, u--)
					B = text2list(A [u], " ") // B -> n11 n12 n13|n21 n22 n23|...

					if (length(B)>DrX)
						error += "length of string � [u] > Drawning X!"
						return

					for(var/i = 1,i <= length(B), i++)
						grid [i][ul] = B [i]

					del(B)
					ul++
				del(A)

				attack_self()
				return
			if("Change drawning Razmer")

				DrX = text2num(input("Enter X:", "Drawning X", "[DrX]", null))
				DrY = text2num(input("Enter Y:", "Drawning Y", "[DrY]", null))
				grid = new/list(DrX,DrY)
				error += "Drawning [DrX]:[DrY] - this is [DrX*DrY] turfs!"

				attack_self()
				return
			if("Use God POWER")

				for(var/u = 1, u <= DrY, u++)
					for(var/i = 1, i <= DrX, i++)
						if (LeG.Find(grid [i][u],1,0) != 0)
							var/o = LeG [LeG.Find(grid [i][u],1,0) + 1]
							var/obj/A = new o (locate(usr.x+i-1,usr.y+u-1,usr.z))
							A.dir = NORTHWEST

				attack_self()
				return