
# Pikadroid
###########
#
# Pikadroid is a simple game based on the
# old Digivice toy :)
# Run it and walk moving the device, it'll
# detect your steps and pikachu will walk
# with you. Sometimes you can find a wild
# pokemon and fight with it.
#
# This program was made to test some
# calls to the Android API in SL4A
# (Scripting Layer for Android).
# http://code.google.com/p/android-scripting/
#
# License: GNU/GPLv3 2011
# Author: a0rtega

$wild_prob = 25    # Probabiliy to find other pokemon for each step.

$moving = false    # Is the user walking?
$steps = 0         # Total steps
$move_step = 0     # Used to print walking ascii
$poke_level = 0    # Pikachu level

## Print functions ##

def clear()
	print "\n"*25
end

def print_pika()
	if $moving == false
		puts "    _______________________________"
		puts "     I've walked #{$steps.to_s} steps "
		puts "     and my level is #{$poke_level.to_s}"
		puts "    -------------------------------"
		puts "              \\/"
		puts "     /\\       __"
		puts "     | \\_____/ /"
		puts "     /         |"
		puts "    / o.   o   |"
		puts "    \\0 _   0   |     _"
		puts "    _\\   _   __|    | |"
		puts "    \\/   \\  <__|  _/ /"
		puts "     |       __|_/ _/"
		puts "     |      <__|__/"
		puts "      \\______/"
		puts "      /__||__\\"
	else
		if $move_step == 0
			puts "     /\\       __"
			puts "     | \\_____/ /"
			puts "     /         |"
			puts "    / ^.   ^   |"
			puts "    \\0 _   0   |   __"
			puts "    _\\   _   __|   \\ \\"
			puts "    \\/   \\  <__|  _/ /"
			puts "     |       __|_/ _/"
			puts "     |      <__|__/"
			puts "      \\______/"
			puts "       \\_|\\__\\"
			$move_step = 1
		else
			puts "     /\\      __"
			puts "     | \\_____\\ \\"
			puts "     /         |"
			puts "    / ^.   ^   |"
			puts "    \\0 _   0   |     __"
			puts "    _\\   _   __|    / /"
			puts "    \\/   \\  <__|  _/ /"
			puts "     |       __|_/ _/"
			puts "     |      <__|__/"
			puts "      \\______/"
			puts "       /_//__/"
			$move_step = 0
		end
	end
end

def start_pika()
	th = Thread.new do
		loop do
			print_pika()
			sleep(1)
			clear()
		end
	end
	return th
end

## Wild pokemon found ##

def wild_pokemon(pikathread)
	if $moving == true && rand($wild_prob) == 0
		pikathread.kill
		some_pokemons = ["Bulbasaur", "Ivysaur", "Charmander",
				"Charmelieon", "Squirtle", "Wartortle",
				"Caterpie", "Butterfree", "Weedle",
				"Kakuna", "Bedrill", "Pidgey",
				"Pidgeotto", "Pidgeot", "Rattata",
				"Raticate", "Spearow", "Jigglypuff",
				"Zubat", "Meowth", "Abra",
				"Machop", "Tentacool", "Koffing",
				"Mewtwo"] # Gotta Catch'em All!
		wild_poke = some_pokemons[rand(some_pokemons.count)]
		an = Android.new
		5.times do
			sleep(0.5)
			an.vibrate # Vibrating
		end
		clear()
		puts "    _______________________________"
		puts "     A wild #{wild_poke} appears"
		puts "    -------------------------------"
		puts "               \\/"
		puts "     /\\       __"
		puts "     | \\_____/ /"
		puts "     /         |"
		puts "    / o.   o   |"
		puts "    \\0 _   0   |     _"
		puts "    _\\   _   __|    | |"
		puts "    \\/   \\  <__|  _/ /"
		puts "     |       __|_/ _/"
		puts "     |      <__|__/"
		puts "      \\______/"
		puts "      /__||__\\"
		print "                 Attack? (Y/N): "
		if gets.chomp.downcase == "y"
			if rand(4) == 0
				if $poke_level != 0
					$poke_level -= 1
				end
				puts "     Pikachu lost, level down #{$poke_level.to_s}."
			else
				$poke_level += 1
				puts "      Pikachu won! Level up #{$poke_level.to_s}."
			end
			sleep(4)
			return true
		else
			return true
		end
	end
	return false
end

## Accelerometer functions ##

def start_check_walking()
	$moving = false
	droid = Android.new
	droid.startSensingTimed(2, 200)
	new_data = droid.sensorsReadAccelerometer()["result"]
	Thread.new do
		loop do
			last_data = new_data
			sleep(1)
			new_data = droid.sensorsReadAccelerometer()["result"]
			if new_data[0].to_i > last_data[0].to_i || new_data[0].to_i < last_data[0].to_i # X
				$moving = true
				$steps += 1
			elsif new_data[1].to_i > last_data[1].to_i || new_data[1].to_i < last_data[1].to_i # Y
				$moving = true
				$steps += 1
			elsif new_data[2].to_i > last_data[2].to_i || new_data[2].to_i < last_data[2].to_i # Z
				$moving = true
				$steps += 1
			else
				$moving = false
			end
		end
	end
end

## Starting the program ##

srand(Time.now.to_i)

start_check_walking()

pikathread = start_pika()

loop do
	sleep(1)
	battle = wild_pokemon(pikathread)
	if battle == true # Restart pika
		pikathread = start_pika()
	end
end

