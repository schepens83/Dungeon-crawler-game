class Dungeon
	attr_accessor :player, :player_item

	def initialize(player_name)
		@player = Player.new(player_name)
		@rooms = []
		@player_item = []
	end
	def start(location)
		@player.location = location
		build_world
		puts "\n+++++++++++++++++++"
		puts "You've travelled far and wide on the dragonkings business. Your last assignments were succesfull, but as of late you find your thoughts drifting more and more to home. Your latest assignment should not take long however and with a quickened thread you continue on your way."
		puts "+++++++++++++++++++"
		show_current_description
	end
	def build_world
		add_room(:meadow_road, 
			"Meadow Road", 
			{false => "You find yourself on a road surrounded by peacefull looking meadows. Sheep and cows roam the grasslands and you can almost imagine the shepard whistling to his dog. There is no shepard however and with this many sheep that strikes you as unusual. \nIt is nowhere near sunset but, as you look up in the sky, a long red streak is visible across the sky. A dark omen if ever you saw one."}, 
			{:south => :small_town, :north => :enchanted_forest, :east => :canyon}, 
			[])
		add_room(:canyon,
			"Narrow Canyon",
			{false => "You're at the entrance of a long canyon. The sun sits high in the sky and shines it's unrelenting heath upon you.\nA giant eagle keeps circling above you, as if waiting for the sun to do its work. The rocks and thorny bushes make navigating the canyon hard. \nWhen looking around, you spot an ancient piramid crested near the side of the canyon. Upon climbing it you find a large magnifying glass placed solidly on the top. You try to pry it loose, but it won't budge. There are burn marks surrounding it. Head shaking as you wonder on the strange religions in the world you continue your travels."},
			{:west => :meadow_road, :south => :hilly_country},
			[Item.new("feather", "\nThis feather looks useless and you start to think maybe you shouldn't have picked it up. You've had weirder items turn usefull before however.")])
		add_room(:hilly_country,
			"Hilly Country",
			{false => "A lovely trail meanders up and down through forests and hils in front of you. As you continue to walk, you snap out of your daydreams when you notice many footprints on the trail. It appears a large group of people have recently moved through this area. As you continue to walk, you find they dropped some small items besides the road. Unfortunately most of them are useless."},
			{:north => :canyon, :west => :small_town},
			[Item.new("key", "\nA huge rusty key. It seems this could not have been used in any ordinary household. It must be a big door indeed to fit it in.")])
		add_room(:small_town, 
			"Small Town", 
			{false => "You're standing in front of the entrance of a small town. The entrance sign says 'stand united against the empire', a rallying cry that was gaining popularity lately. Pop:206, it says below, but smaller numbers have been crossed out a couple of times. Now it looks like a ghost town as - after some looking around - you find nobody there. The inhabitants apparantly all left in a hurry. There is a big square in the center of town with a beautifull fountain. Dolphin's continue to spew water for the enjoyment of an abandoned village. Shaking of a feeling of annoyment, you spot a huge mansion at the head of the square. The only one fit for you to loot, unfortunately it's locked. You find that not even you are able to break in through the big entrance door..", true => "You're standing in front of the ruins of the little village you passed shortly before. The villagers were right to abbandon it you think. As you make yourself through the ruins you find the fountain and the mansion still intact."}, 
			{:north => :meadow_road, :east => :hilly_country}, 
			[])
		add_room(:entrance_cave, 
			"Entrance to a Cave", 
			{false => "You spot a cave in the distance. After a hike up a small trail you're standing in front of it. You try to look inside but it's to dark to see. If only you had some light.", true => "\nYou spot a cave in the distance. After a hike up a small trail you'r standing in front of it. You try to look inside but it's to dark to see. Luckily your torch lights the way."}, 
			{:south => :enchanted_forest}, 
			[])
		add_room(:enchanted_forest, 
			"Enchanted Forest", 
			{false => "You arrive at a strangely circularly shaped forest and conclude it can only be the enchanted forest of the elves. Nearing the edge you spot a beautifull arch enshrined with near-real elven statues. As you venture towards the centre of the forest, you find the remains of an elven shaman's occult ritual. The victim of its bloodsacrificing - a little squirrel - lifeless on the shrine. It seems the elves as well consider the red smear across the sky a bad omen. Although you consider yourself open minded, you doubt sacrificing a squirrel will do any good. As you continue, a hideous odour penetrates your nose. It seems some elves had the same doubts and found their refuge in some hard liquor. You find them hungover and lying in their own barf.", true => "As you once again enter the enchanted forest it now feels much darker. You find no hungover elves this time, only abandoned treehouses. A massacre occured here not long ago. In the center of the forest there appears to be a mass-grave, not yet covered. You find a lonely squirrel moving about. As you turn around to leave, you feel that there is some poetic justice there."}, 
			{:south => :meadow_road, :north => :entrance_cave}, 
			[Item.new("drinking-bag", "\nVery large drinking bag made from the skin of a deer. It seems originally to be intended as sacrifice, but in their stupor the elves have used it for their drinking games. The smell of hard liquor still remains inside.")])
		add_room(:cave_tunnel, 
			"Cave Tunnel", 
			{false => "Carefully you step in the cave. You once heard a story of a little boy that ventured inside a cave and wandered for days. As it happens that story might have been the origin of your cavephobia. Repressing your feelings of impending doom, you continue on. Halfway through, you come upon a group of men holding camp. They look starved but still provide you with some meat. It's not nearly enough to fill your stomache, but you take what you can get and continue on. The rest of your travel through the cave is uneventfull."}, 
			{:west => :entrance_cave, :east => :start_desert}, 
			[])
		add_room(:start_desert, 
			"Endless Desert", 
			{false => "From the entrance of the cave stretches out an endless desert. You start feeling as if catched between a rock and a hard place. Although you think you can last quite a long while without water, you dare not venture in the desert without any liquid substances. You also don't particularly look forward to going back through the cave, though.", true => "A vast desert stretches out before you. Reassured by the drinking-bag you continue to walk up the first sand dune."}, 
			{:west => :cave_tunnel}, 
			[])
		add_room(:east_desert, 
			"Endless Desert", 
			{false => "Small heatwaves slowly radiate on the horizon. The desert stretches out endlessly to all sides. You curse yourself for not having thought to take some kind of shade with you. The sun pounces relentlessly and your head is starting to throb. With a slight headache coming up behind your ears, you continue your voyage."}, 
			{:west => :start_desert, :north => :north_east_desert, :south => :south_east_desert}, 
			[])
		add_room(:north_east_desert, 
			"Endless Desert", 
			{false => "You stand beside your liege's throne as he stands up in the middle of his tirade against one of his vassal-byrons. On occasions such as these he likes to have you around to intimidate people. The throneroom is large and wide. Long tapestries depicting the empires' battles fall down on the sides of the walls. One of them depicts a single rider on his dragon, atacking a whole regiment of some long forgotten kingdom. You're especially fond of that one as it is your grandfather immortalized. A sense of pride fulfills you as you think of the long history of service and loyalty your family has with the empire. As you turn back you see your family as the young ones run around their mothers feet. Their play boisterous but harmless as they scurry along the inner keeps yard. \nWith a snap you startle awake. A small lizard slides away in it's hole. You try to calm your nerves. The desert is nowhere near as empty as it seems during the day. Nowhere near as hot as well. You decide to travel on during the remainder of the night, although you will have to be lucky to find some shade to sleep during the day."}, 
			{:south => :east_desert, :west => :north_desert}, 
			[])
		add_room(:north_desert, 
			"Endless Desert", 
			{false => "As you stumble your way forward you find another fata-morgana shimmering to your right. Desperate enough you decide to check this one out. It's out of the way you were heading, but you won't be able to survive much longer anyway. It really is a very pragmatic decision. You laugh at the irony of this force of nature succeeding where so many others have failed. It's approaching sunset when you near the oasis. The shimmering surrounding the visage had stopped with the sun getting lower, so you no longer doubt its real. With a sigh of relief you drop down besides the small pond in the oasis. After refilling your bag you decide to stay here for a couple of days to recuperate and try to hunt for some game."}, 
			{:south => :start_desert, :east => :north_east_desert}, 
			[])
		add_room(:south_east_desert, 
			"Endless Desert", 
			{false => "Walking through this inhospitable country you see some sparse bushes far away. You might at last be nearing the end of your journey through the desert. You stumble on something. The desert is smooth as sand so you turn around to take a closer look. It's a leather cord that caught your feet. You feel its attached to something and start to dig it out. The leather was part of a big armored horse. The skeleton of the horse is clean sanded by sandstorms. The armor is still mostly intact though.", true => "Walking through this inhospitable country you see some sparse bushes far away. You might at last be nearing the end of your journey through the desert."}, 
			{:north => :east_desert, :west => :south_desert, :south => :tundra},
			[Item.new("horse-armor", "\nSlightly rusted. The horse you found it on won't have any use for it anymore. Mayhaps you find opportunity to make use of it in the future in some way.")])
		add_room(:south_desert, 
			"Endless Desert", 
			{false => "It seems now like there is no other world besides these endlessly rolling dunes. You go down one and up another. Down another again. The cycle repeats .. infinitely. As you crest another dune you spot the tail end of a small caravan in the distance. You think about following it to ask for directions, but as they move in the wrong direction you decide otherwise. Catching up would take the better part of a day at least. You don't deem it worthy enough for a detour. \nComing down one side of the dune, you continue your way up the next."}, 
			{:north => :start_desert, :east => :south_east_desert},
			[])	
		add_room(:tundra, 
			"Tundra", 
			{false => "The landscape around you shows subtle changes. The sand beneath you is replaced with rocky ground and trees are found sparingly across the horizon. You've entered the tundra on the edges of the empires borders. The horse-people that ride these lands are a proud people and have long defied the empire's rule. Their strenght though comes mostly from their speed and mobility, which would be much less usefull in the empire's land. Trapped between the desert and the empire an uneasy status quo had settled in early on in their history. Years of economic starvation and isolation had decimated their numbers. they now were no longer a serious threat for anyone but a lonely traveller. You warily keep your eyes on the horizon as you make your way through the land."}, 
			{:north => :south_east_desert, :west => :tundra_west, :south => :forest},
			[])	
		add_room(:tundra_west, 
			"Tundra", 
			{false => "An hour ago you spotted a lone horseman behind you on the horizon. Horsemen are known to travel and hunt in packs, so you're sure there must be more. You might have scared them off, but horsemen are hardly cowards and spotting you might have put ideas of revenge in their heads. Your orders did not involve the horsemen and the more prudent thing to do was avoid them. As you contemplate your next move you spot a dust cloud behind you. It seems the choice was taken from you. The land does not give much opportunity for hiding. Fortunately if you increase your tempo now, it will be nightfall when they overtake you. Calmly you fall in to an easy run. \nAs you run, you think over your options. The horsemen are stubborn and will most likely not relent. They will disperse during the night and weave a large net in which they hope to catch you. As dusk sets in you no longer see a dust cloud behind you. Either they relented or did as you predicted. After a while you find yourself in a more adventageous landscape. A labyrinth of tall rocks that reach above your head. Your ears catch the muffled sound of a horse with cloth tied around its feet. Another favorite trick of the horsemen. Luckily your ears are sharper than average men's and as you hide in a small crevace a lone rider passes you by. Silently you move up to him from behind. If the rider spots you he will whistle loudly, whereby calling the rest of the pack down on you. You cross the last couple of meters in a dash. The rider turns around in alarm, but you jump on top of the horse and take the rider out before he can call his friends. With another quick move you silence the horse. Quickly you look through the riders bags. Nothing remarkable except a set of middle-long, blunt blades. \nRethinking what to do now, you turn around and head back. The horsemens' net now has a hole and you intend to slip through it. The rest of the night you spend running back in the direction you came from. Come morning you find no trace of horsemen.", true => "You find no trace of the horsemen this time and with an infallable memory you backtrack to the place you ambushed the horsemen. No trace of him to be found anymore, so his comrades must have found him. You find the blunt blades still where you buried them."}, 
			{:east => :tundra},
			[Item.new("blunt-blades", "\nNot much use in current form. Though you think most weapons are useless. These particular ones might be reworked to your use.")])	
		add_room(:forest, 
			"Forest", 
			{false => "You enter the forest with some feeling of relief. The forest quickly becomes denser and soon blocks out most of the light. After a couple of hours you come across a small road. You quickly take your bearing and decide which route to take. The road meanders through the forest and you're now able to make good time. Not long afterwards you come upon a man hanging from a big tree. His head marked with the tatoo of a rapist, it seems his last transgression was met with a different punishment. The rope that was used looks sturdy and strong."}, 
			{:north => :tundra, :south => :riverland},
			[Item.new("rope", "\nLong and firm, this rope looks thick enough to bind a dragon. You chuckle. That's not likely to happen anytime soon.")])	
		add_room(:riverland, 
			"A wide river", 
			{false => "You come upon a wide river. With quick currents and steep riversides, you won't be able to cross it on foot. Looking both ways you aren't spotting a bridge or friendly ferryman. Unsure which way to go, you mentally toss a coin and choose a direction to follow the river.", true => "Back at the river again. Your raft still floats peacefully where you left it."}, 
			{:north => :forest, :east => :river_to_mountain, :west => :ocean},
			[])	
		add_room(:river_to_mountain, 
			"Mountainside river", 
			{false => "Following the river upstream for days you find it disappears in the side of a steep mountainside. No way around it here. Not a good place to cross the river anyway, as it's teeming with a particularly nasty looking breed of crocodiles. This way looks like a dead end."}, 
			{:west => :riverland},
			[Item.new("crocodile-teeth", "\nYou found this on the skull of dead crocodile, by the side of the river. Sharp as hell, you think it might be of some use in the future.")])
		add_room(:ocean, 
			"River to Ocean", 
			{false => "Following the river downstream made you wish for some way to travel - on - the river, instead of - besides -. Ofcourse, if you had a means to travel on the river, you wouldn't need to travel downstream. \nThe river was slowly widening out and turning itself slightly into mangrove. Which wasn't going to make it any easier. After half a day you spot the rivers end, where it flows in the ocean and an hour later you walk up to the beach. Rocks protrude a little farther out the bay. When the tide rises those will be under water. Dangerous place without a lighthouse. As if to prove your point you find a lot of driftwood from a shipwreck on the beach not half a kilometre from the river. Lost for cause, you sit down and make camp for the evening. You think on what to do next."}, 
			{:east => :riverland},
			[Item.new("driftwood", "\nThick beams from the mast and solid planks from the rutter. Sturdy stuff and certainly good enough as basematerial for anything you could think of.")])
		add_room(:farmland, 
			"Fields of Corn", 
			{false => "Travelling through fields of maize and corn you find yourself in a most furtile part of the empire. The farmers working the fields look weary as you pass them by, but your sight is familiar to them and the distance is far enough to not scare them away. Restless now you're in the empire, you continue on your way."}, 
			{:north => :riverland, :south => :mountain, :west => :smithy},
			[])
		add_room(:mountain, 
			"A Towering Mountain", 
			{false => "You feel the end of your journey approaching and you're anxious to get home. You stand at the foot of an enormous mountain. A couple of hours earlier it slowly started to snow and the ground is now blanketed white. The slow swirl of falling snowflakes will be a turmulent storm on top of the mountain. Your timing could not have been worse. You're glad that you're familiar with this terrain, since you vaguely recall that there is a pass to the east."}, 
			{:north => :farmland, :east => :start_mountain_pass, :west => :canyon_topside},
			[])
		add_room(:start_mountain_pass, 
			"Entrance to the Eastern Mountain Pass", 
			{false => "As you approach the mountain pass you spot 6 Griphons circling high in the sky. News of your assignment must have reached your mortal enemies. Going up the mountain pass now will leave you in open territory and sure to be spotted. Two or three you could have handled but fighting six would make an uncertain outcome. For the first time on this quest you feel remorse for leaving your battle-gear at home.", true => "The six griphons still circle the pass, but you feel emboldened by being armed and armored to move forward."}, 
			{:west => :mountain},
			[])
		add_room(:mountain_pass, 
			"The Eastern Mountain Pass", 
			{false => "Carefully you crouch beside one of the last trees before the large and open plain of the pass. You see six of them circling directly above you, which probably means they've spotted you. Griphons are not known for their intelligence, but they are pack animals and their instincts for hunting are excellent. Being in the air means they have the advantage of choosing the battleground, which will probably be out in the open where they can come from all sides. You prefer to have the initiative though and even though you feel confident, you decide to wait till darkness sets in. Griphons's nightsight is equal to your own, but the night is dark tonight and they will need to fly low or risk losing you. \n\nYou slowly walk out the forest and look up. The sliver of the moon is invisible behind thick dark clouds. The effect is somewhat diminished by the whiteness of the snow, brightening the night. It will have to do. Non of the beasts nearby as far as you can make out though. Carefully you set out. \n\nWhen you hear the screech hours later, you almost thought you had gotten rid of them. You crouch down and look up towards the sound. Three of them are flying low about 50 meters from your right. They fly parralel to you and are not preparing to attack. That doesn't make sense. Why alert you and give time to ... You get hit sideways by some large weigth. Instinctively you crouch and try to lower your point of gravity but your reaction was late and you find yourself falling sideways. As you do so however, you wip around your tail and are rewarded by solid contact and a pained screech. You manage to grab hold and are pulled up by the griphon trying to get away. The two others that were right behind, suddenly like their situation much less and try to change their collision course. Using the momentum gained by your tail action, you swing your body towards the closest of the two trailing and manage to make a solid connection with one of its wings. Screeching and whimpering it goes down. You whip yourself up towards the griphon you're 'riding' and finish it off by swinging your talon and seperating its head from body. Quickly you manage to turn around mid air as you fall down and land on your four feet. You look around and see the griphon who you managed to collide with, try to limp away. You're tempted to finish it off, but you don't know where the others are and in a quick movement you circle around. The three diversions had used the time to approach from the right, while the third initial attacker had joined them. They look more uncertain now and start circling around you. The wounded one on the ground screeches out to them and with more confidence in their flight, they move out to protect it. That must be the leader than. You feel a pang of regret you didn't take him out when you had the chance, but repress it. You made the sensible move as it would have left you open for attack. Slowly you start to circle around the leader and re-evaluate the situation. You realize this fight is over. Griphons without the leader of the pack have little appetite for danger. As you've shown them you can handle six they won't come back with four. Especially with their leader incapacitated and grounded. You are not the one that needs to finish this fight. Moving backwards and out of sight you hear a last angry screech as they realize the same. \n\nMoving quickly through the night you leave the mountain pass - and the griphons - behind you."}, 
			{:west => :home},
			[])
		add_room(:canyon_topside, 
			"Top of the Canyon", 
			{false => "Slowly you approach the cliff. It's a sheer drop of a couple of hundred meters down to the bottom of this canyon. A few meters below the precipice you see the nest of a big eagle. You drop down to take a look and find some unhatched eggs. It's been a while since you've eaten and hungrily you take this opportunity. As you climb back up the cliff you smile as you see a small piramid someplace far down below."}, 
			{:east => :mountain, :north => :smithy},
			[Item.new("eagle-egg", "\nSaving one for later you restrained yourself and took one egg with you. At least for some time, you won't go hungry.")])
		add_room(:smithy, 
			"Big village", 
			{false => "You approach a large village and enter through the main gate. The streets have emptied as its population hides inside their houses. You know this village and would have left it alone if you didn't need something. Walking along the main road you approach the smithy. \nThough the smith is a big man, he is unwilling to come outside at first. You have to insist. Although the stick would have been enough, you feel sorry enough for the men to use the carrot as well. You promise him he will be compensated by the empire. He seems willing to work his trade."}, 
			{:south => :canyon_topside, :east => :farmland},
			[])
		add_room(:home, 
			"Dragon's Den", 
			{false => "Cheerfully you climb the wide circling hallway up to your lair. The emperors ancestors had this especially made for your lineage. As you round the top you hear the cheers of joy and surprise as your young hatchlings see you. Calling out with joy they run and jump on top of you. Laughing, you let them and start playfully tossing them around. Later, there will be time to give report to the emperor of your destruction of the human and elven rebellion. For now you enjoy the simple play of your family.\n\n\n\n"},
			{:north => :start_mountain_pass},
			[])
	end
	def show_current_description
		puts find_room_in_dungeon(@player.location).full_description
	end
	def find_room_in_dungeon(reference)
		@rooms.detect { |room| room.reference == reference}
	end
	def add_room(reference, name, description, connections, items)
		@rooms << Room.new(reference, name, description, connections, items)
	end
	def go(direction)
		if find_room_in_dungeon(@player.location).is_adjoining_rooms?(direction) #only change location if the new direction is valid.
			#set unlocked status of some areas when they are visited.
			if find_room_in_dungeon(@player.location).reference == :small_town then find_room_in_dungeon(@player.location).unlocked = true end
			if find_room_in_dungeon(@player.location).reference == :enchanted_forest then find_room_in_dungeon(@player.location).unlocked = true end
			if find_room_in_dungeon(@player.location).reference == :south_east_desert then find_room_in_dungeon(@player.location).unlocked = true end

			#change current location to the new direction. 
			puts "\nYou go " + direction.to_s
			@player.location = find_room_in_dungeon(@player.location).connections[direction]
			show_current_description
		else
			puts "\nIt does not appear to be possible to move there. Choose another direction."
		end
	end	
	def use(item_name)
		if !@player_item.select {|i| i.name == item_name}.empty? #Player can only use items he has with him. 
			case item_name
			when "crocodile-teeth"
				puts "\nYou look at it and try to to think of a use for it in your current situation. The task is beyond you. You put it back."
			when "eagle-egg"
				puts "\nYou quickly eat your last egg. It fills your stomach and leaves you drowsy but fulfilled."
				@player_item.delete_if {|i| i.name == "Eagle-egg"}
			when "feather"
				puts "\nYou scratch yourself beneath your feet with the pointy side and enjoy a momentary relief of an incessant itch."
			when "drinking-bag"
				if find_room_in_dungeon(@player.location).reference == :small_town
					@player_item.delete_if {|i| i.name == "drinking-bag"}
					@player_item << Item.new("full-waterbag", "\nfilled to the brim with sparkling cold water. Sure to quench your thirst in times of need. Heavy to carry for any grown man, you find some sense in being able to carry it without much difficulty.")
					puts "\nYou fill the drinking-bag with water. Sure to rince it of the liquor by filling and empty-ing it a couple of times."					
				else
					puts "\nYou look around and wonder what you can do with it. Nothing comes to mind. You put it away again."
				end
			when "key"
				if find_room_in_dungeon(@player.location).reference == :small_town
					find_room_in_dungeon(@player.location).items = [Item.new("torch", "\nA long stick with some cloth at the end.\nOn closer inspection, it seems to be damp with some oil.")]
					find_room_in_dungeon(@player.location).items.flatten
					@player_item.delete_if {|i| i.name == "key"}
					s = ""
					s += "\nYou open the door to the mansion and find inside:\n"
					find_room_in_dungeon(@player.location).items.each { |i| s += i.name + ", " }
					puts s
				else
					puts "\nYou really don't know what to do with that here."
				end
			when "torch"
				if find_room_in_dungeon(@player.location).reference == :canyon
					puts "\nYou place the torch under the magnifying glass and wait for the sun to do it's work. After a while you'r rewarded with a bit of smoke and after waiting some more the torch catches fire. You'r now in possesion of a lighted torch."
					t = @player_item.select {|i| i.name == "torch"}
					t[0].name = "lighted-torch"
					t[0].description = "\nYour torch burns slowly and casts an eary light. The darkness seems much less scary now."
				else
					puts "\nYou hold the torch in your hands and wait for something to happen. Allthough nobody is watching you, after a while you feel slightly idiotic. With a small sense of shame you put it away."
				end
			when "lighted-torch"
				if find_room_in_dungeon(@player.location).reference == :entrance_cave
					unlock_room
					find_room_in_dungeon(@player.location).add_connection([:east, :cave_tunnel])
					puts "\nAs you hold up your torch you light up the cave. You feel emboldened enough to enter the cave now."
				else
					puts "\nYou burn yourself with the torch. Cursing, you put it away. It was no good here anyway."					
				end
			when "full-waterbag"
				if find_room_in_dungeon(@player.location).reference == :start_desert
					unlock_room
					find_room_in_dungeon(@player.location).add_connection([:south, :south_desert])
					find_room_in_dungeon(@player.location).add_connection([:east, :east_desert])
					find_room_in_dungeon(@player.location).add_connection([:north, :north_desert])
					puts "\nFeeling the heavy weight of the water-bag on your back, you feel assured of your ability to survive in the desert. You only need to choose which direction to set out for."
				else
					puts "\nYou spill some water by accident. Not really of any consequence, but somehow it makes you feel small again. Your parents had no patience for clumsiness."					
				end
			when "driftwood"
				if find_room_in_dungeon(@player.location).reference == :riverland
					puts "What item do you want to combine this with?"
					if gets.chomp.split(' ').any? {|i| i == "rope"} and !@player_item.select {|i| i.name == "rope"}.empty?
						find_room_in_dungeon(@player.location).add_connection([:south, :farmland])
						find_room_in_dungeon(@player.location).unlocked = true
						@player_item.delete_if {|i| i.name == "driftwood"}
						@player_item.delete_if {|i| i.name == "rope"}
						puts "\nTying off the last knot you look satisfied at your creation. The huge raft will be big enough to support your considerable girth. Confident of it's quality you push it on the river."
					else
						puts "\nYou don't know how to combine those."
					end
				else
					if find_room_in_dungeon(@player.location).reference == :ocean
					 	puts "\nThe river has turned in to a mongrove here. Not a good place to cross."
					else
						puts "\nYou stare at it for a while and wait for the quarter to drop. \nIt's not happening. Better think of something else then."
					end
				end
			when "rope"
				if find_room_in_dungeon(@player.location).reference == :riverland
					puts "What item do you want to combine this with?"
					player_answer = gets.chomp.to_s
					if player_answer.split(' ').any? {|i| i == "driftwood"} and !@player_item.select {|i| i.name == "driftwood"}.empty?
						find_room_in_dungeon(@player.location).add_connection([:south, :farmland])
						find_room_in_dungeon(@player.location).unlocked = true
						@player_item.delete_if {|i| i.name == "driftwood"}
						@player_item.delete_if {|i| i.name == "rope"}
						puts "\nTying off the last knot, you look satisfied at your creation. The huge raft will be big enough to support your considerable girth. Confident of it's quality you push it on the river."
					else
						puts "\nYou don't know how to combine those."
					end
				else
					if find_room_in_dungeon(@player.location).reference == :ocean
					 	puts "\nThe river has turned in to a mongrove here. Not a good place to cross."
					else
						puts "\nYou stare at it for a while and wait for the quarter to drop. \nIt's not happening. Better think of something else then."
					end
				end
			when "blunt-blades" 
				if find_room_in_dungeon(@player.location).reference == :smithy
					puts "\nWith your instructions the smith starts to work on your blades. A young apprentice works up the fire, as the smith lays the blades in the red coals. After a couple of hours of work, he comes back with a set of huge-talons. You inspect them with an eye for detail. After a while you sniff your satisfaction. These will do."
					t = @player_item.select {|i| i.name == "blunt-blades"}
					t[0].name = "huge-talons"
					t[0].description = "\nAs you try to fit these on, you think they will do. \nAlthough the smith was unfamiliar with its design, he did a good enough job with it. "
				else
					puts "No use for those here. In their current form they are useless."
				end
			when "horse-armor"
				if find_room_in_dungeon(@player.location).reference == :smithy
					puts "\nThe smith seems interested in this job. After firing of half a dozen questions he sets out to work. It will be a while he warns. You settle in in front of his shop. As the smith works, his childrens curiosity slowly overcomes their fear, and one by one they start to come outside. You love children of any size, so you indulge them in their youthfull play. When the smith returns with his work it's approaching noon. While he sends his children back in for lunch, you look at his work. You're impressed and promise him you will recommend his work to the emperors mastersmith when you get home. He seems pleased with himself."
					t = @player_item.select {|i| i.name == "horse-armor"}
					t[0].name = "draconian-armor"
					t[0].description = "\nThe smith did an excellent job on this! The armor shines as new and fits like a glove. Some extra metal was needed, but the joints hardly show."
				else
					puts "\nNo use for that here. In it's current form it's useless."
				end
			when "draconian-armor" 
				if find_room_in_dungeon(@player.location).reference == :start_mountain_pass
					puts "\nYou slowly and serenely put on the draconian-armor."
					@player_item.select {|i| i.name == "draconian-armor"}[0].used = true 
					if !@player_item.select {|i| i.name == "huge-talons"}.empty? #make sure player has item. before testing if its been used.
						if@player_item.select {|i| i.name == "huge-talons"}[0].used == true 
							puts "\nCombined with your talons, you are fit for combat. You're prepared to cross the pass now." #if player has item and it is used.
							find_room_in_dungeon(@player.location).add_connection([:south, :mountain_pass])
							@player_item.delete_if {|i| i.name == "huge-talons"}
							@player_item.delete_if {|i| i.name == "draconian-armor"}
							unlock_room
						else
							puts "You feel much more secure now, but doubt it will be enough against the griphons." #if player has item but has not been used.
						end
					end
				else
					puts "\nYou put it on and look bad-ass. You imagine. No use other than that however. You put it back in your sack."
				end
			when "huge-talons" 
				if find_room_in_dungeon(@player.location).reference == :start_mountain_pass
					puts "\nYou put the talons over your paws. You nod approvingly as you test the extra reach they provide you with."
					@player_item.select {|i| i.name == "huge-talons"}[0].used = true 
					if !@player_item.select {|i| i.name == "draconian-armor"}.empty? #make sure player has item. before testing if its been used.
						if@player_item.select {|i| i.name == "draconian-armor"}[0].used == true 
							puts "\nCombined with your armor, you are fit for combat. You're prepared to cross the pass now." #if player has item and it is used.
							find_room_in_dungeon(@player.location).add_connection([:south, :mountain_pass])
							@player_item.delete_if {|i| i.name == "huge-talons"}
							@player_item.delete_if {|i| i.name == "draconian-armor"}
							unlock_room	
						else
							puts "You feel much more secure now, but doubt it will be enough against the griphons." #if player has item but has not been used.
						end
					end
				else
					puts "\nYou put them on and look bad-ass. You imagine. No use other than that however. You put them back in your sack."
				end
			end
		else
			puts "\nYou do not appear to have that item with you."
		end
	end
	def take(item_name)
		if !find_room_in_dungeon(@player.location).items.select {|i| i.name == item_name}.empty? #Player can only take items in the room. 
			@player_item = @player_item + find_room_in_dungeon(@player.location).items.select {|i| i.name == item_name}
			find_room_in_dungeon(@player.location).items.delete_if {|i| i.name == item_name}
			puts "You put the " + item_name + " in you sack."
		else
			puts "That item is not in this room."
		end
	end
	
	def directions
		puts "\nFrom here you can go: \n"
		find_room_in_dungeon(@player.location).connections.keys.each {|i| puts i.to_s + "\n"}
	end
	def which_item_in_backpack
		if !@player_item.empty?
			s = ""
			s += "\nYou have in your sack:"
			@player_item.each {|i| s += "\n" + i.name.to_s}
			puts s
		else
			puts "\nYour sack is empty."
		end
	end
	def inspect_item(item_name)
		all_items = @player_item + find_room_in_dungeon(@player.location).items
		if !all_items.select {|i| i.name == item_name}.empty?
			puts all_items.select {|i| i.name == item_name}.first.description
		else
			puts "You can't find that item nor have it in your backpack."
		end
	end
	def unlock_room()
		find_room_in_dungeon(@player.location).unlocked = true
	end
	def possible_actions
		puts "\nPossible actions: \n-directions\n-go <north/south/east/west>\n-take <item>\n-inspect <item>\n-use <item>\n-sack\n-exit"
	end

	class Player
		attr_accessor :name, :location, :items

		def initialize(player_name)
			@name = player_name
			@items = []
		end
	end
	
	class Item
		attr_accessor :name, :description, :used

		def initialize(name, description)
			@name = name
			@description = description
			@used = false
		end
	end

	class Room
		attr_accessor :reference, :name, :unlocked, :description, :connections, :items

		def initialize(reference, name, description, connections, items)
			@reference = reference
			@name = name
			@unlocked = false
			@description = description
			@connections = connections
			@items = items
		end
		def full_description
			s = ""
			s += "\n\n" + name + "\n\n" + read_description
			if @items.any?
				s += "\n\nYou find: " 
				@items.each { |i| s += i.name + ", " }
			end
			return s
		end
		def read_description
			s = ""
			s = "********\n" if @unlocked == true #make it clear the text has changed from the first by adding *** before the text. 
			s += @description[@unlocked].to_s #show text based on unlocked status.
			s
		end
		def is_adjoining_rooms?(direction)
			!@connections[direction].nil?
		end
		def add_connection(conn)
			@connections[conn[0]] = conn[1]
		end
	end
end

d = Dungeon.new("Sander")
d.start(:meadow_road)

puts " "
puts "Choose an action. \nType actions, to get a hint for possible actions you can take."
puts "------------------------"
input = gets.chomp.to_s.split(' ')
while !(input[0] == "exit") #or !(d.find_room_in_dungeon(d.player.location).reference == :home)
	case input.shift #take of first element of input for input in case. input array now no longer has first word.
	when "directions"
		d.directions
	when "sack"
		d.which_item_in_backpack
	when "go"
		d.go(input.join.to_sym)
	when "take"
		d.take(input.join)
	when "use"
		d.use(input.join(' '))
	when "inspect"
		d.inspect_item(input.join)
	when "actions"
		d.possible_actions
	else
		puts "\nYou scratch behind your ears and think. \nNo you really don't know how to do that.."
	end
	
	if !(d.find_room_in_dungeon(d.player.location).reference == :home) #as long as you're not at the end of the game ask for input again.
		puts "------------------------"
		input = gets.chomp.to_s.split(' ')
	else
		input[0] = "exit"
	end
end

