/obj/mark/Del
	New()
		if (contents.len)
			for(var/obj/I in src.contents)
				del(I)
		new /turf/space (src.loc)
		spawn(1)
			del(src)

/obj/mark/P_Del
	New()
		if (contents.len)
			for(var/obj/I in src.contents)
				del(I)
		new /turf/simulated/floor/plating (src.loc)
		spawn(1)
			del(src)

/obj/mark/Window

	icon = 'icons/obj/structures.dmi'
	icon_state = "rwindow0"

	New()
		new /obj/structure/grille (src.loc)

		var/obj/W = new /obj/structure/window/reinforced (src.loc)
		W.dir = 9

		new /turf/simulated/floor/plating (src.loc)

		spawn(1)
			del(src)

/obj/mark/Door

	icon = 'icons/obj/doors/Doorint.dmi'
	icon_state = "door_closed"

	New()
		new /obj/machinery/door/airlock (src.loc)

		new /turf/simulated/floor/plating (src.loc)

		spawn(1)
			del(src)

/obj/Mega_Build_Tool
	icon = 'musician.dmi'
	icon_state = "violin"
	name = "Tool of God"
	var/COD

	var/error
	
	var/build_delay = 1

	var/list/grid = new/list(10,10)
	var/DrX = 10
	var/DrY = 10

	var/list/A ()
	var/list/B ()

	var/LG = "1 /turf/simulated/wall\n2 /turf/simulated/floor/plating\n3 /obj/mark/Window\n4 /obj/mark/Door"
	var/list/LeG ()
	LeG = list ("1", /turf/wall, 'wall.dmi', "2", /turf/floor, 'floor.dmi', "3", /turf/glass, 'glass.dmi')
/*
	verb/Pos()
		usr << "[usr.x] : [usr.y]"
*/
	New()
		COD = "3 1 1 1 1 1 1 1 1 3\n3 2 2 2 2 2 2 2 2 3\n3 2 2 2 2 2 2 2 2 3\n3 2 2 1 1 4 1 2 2 3\n3 2 2 1 2 2 1 2 2 3\n3 2 2 1 2 2 1 2 2 3\n3 2 2 1 1 1 1 2 2 3\n3 2 2 2 2 2 2 2 2 3\n3 2 2 2 2 2 2 2 2 3\n3 1 1 1 4 4 1 1 1 3"
//-

	Click()
		test_Viev()

	verb/GUI_test()
		set category = "Mega Build Tool"
		set src in view(0)

		var/obj/Mega_Build_Tool/B = src
		B.loc = usr
		B.screen_loc = "NORTH+1,WEST"
		usr.client.screen += B

	verb/GUI_Exit()
		set category = "Mega Build Tool"
		usr.client.screen -= src

	verb/MBT_Del()
		set category = "Mega Build Tool"
		del(src)
		
	verb/Set_build_delay(mob/user)
		set category = "Mega Build Tool"
		
		build_delay = text2num(input("Enter build_delay:", "build_delay", "[build_delay]", null))

	verb/test_Viev(mob/user)
		set category = "Mega Build Tool"

		var/t = "<TT><B>Tool of God</B><HR>"
		t += "<B><span class='danger'>[error]</span></B><HR>"
		t += "<BR>Current position: [usr.x] : [usr.y]<BR>"
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
				test_Viev()
				return

			if("See Drawning")

				var/dat = "<TITLE>Drawning</TITLE><center> <A href='?src=\ref[src];action=return'>Return</A> <IMG CLASS=icon SRC=\ref['areas.dmi']><IMG CLASS=icon SRC=\ref['areas.dmi']><IMG CLASS=icon SRC=\ref['areas.dmi']><IMG CLASS=icon SRC=\ref['areas.dmi']><IMG CLASS=icon SRC=\ref['areas.dmi']> <A href='?src=\ref[src];action=Use God POWER'>Use God POWER</A> </center><br><center>"

				for(var/u = DrY, u >= 1, u--)
					for(var/i = 1,i <= DrX, i++)

						if (LeG.Find(grid [i][u],1,0))

							var/icon/sprite = new /icon("[LeG [LeG.Find(grid [i][u],1,0) + 2]]", "[LeG [LeG.Find(grid [i][u],1,0) + 3]]")
							usr << browse_rsc(sprite, "[LeG [LeG.Find(grid [i][u],1,0)]].png")

							dat += "<img src='[LeG [LeG.Find(grid [i][u],1,0)]].png'>"

						else
							dat += "<IMG CLASS=icon SRC=\ref['areas.dmi']>"

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
				var/zp

				A = text2list(LG, "\n") // A -> cod1|cod2|cod3
				for(var/u = 1, u <= length(A), u++)

					B = text2list(A [u], " ") // B -> n11 n12 n13|n21 n22 n23|...
					for(var/i = 1, i <= length(B), i++)
			//			sleep(1)

						switch(n)
							if(1)
								pz = B [i]
								LeG.Add(pz)
								n++
							if(2)
								pz = text2path(B [i])

								LeG.Add(pz)

								var/ob = B [i]
								var/obj/ico = new ob (locate(2,2,1))
								pz = ico.icon
								zp = ico.icon_state
								n = 1
								del(ico)

								LeG.Add(pz)

								LeG.Add(zp)

								n=1

					del(B)
				del(A)

				for(var/u = 1, u <= length(LeG), u++)
					error += "Test:[u] - [LeG [u]]<br>"

				test_Viev()
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
						error += "length of string ¹ [u] > Drawning X!"
						return

					for(var/i = 1,i <= length(B), i++)
						grid [i][ul] = B [i]

					del(B)
					ul++
				del(A)

				test_Viev()
				return
			if("Change drawning Razmer")

				DrX = text2num(input("Enter X:", "Drawning X", "[DrX]", null))
				DrY = text2num(input("Enter Y:", "Drawning Y", "[DrY]", null))
				grid = new/list(DrX,DrY)
				error += "Drawning [DrX]:[DrY] - this is [DrX*DrY] turfs!"

				test_Viev()
				return
			if("Use God POWER")
				var/BX = usr.x
				var/BY = usr.y
				var/BZ = usr.z

				for(var/u = 1, u <= DrY, u++)
					for(var/i = 1, i <= DrX, i++)
						if (LeG.Find(grid [i][u],1,0) != 0)
							var/o = LeG [LeG.Find(grid [i][u],1,0) + 1]
							sleep(build_delay)
						//	var/obj/A =
							new o (locate(BX+i-1,BY+u-1,BZ))
						//	A.dir = NORTHWEST

				test_Viev()
				return
