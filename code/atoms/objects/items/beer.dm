/obj/item/beer
	name = "beer"
	desc = "beer"
	icon_state = "beer"
	var/heal_amount = 50

/obj/item/beer/attack_self(datum/inventory/inventory, slot)
	usr.act("absorbs \the [src].")
	usr.heal_damage(heal_amount)
	playsound(usr, 'sound/belch.mp3', vol = 100, range = 7)
	destroy()
