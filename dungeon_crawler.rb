require 'yaml'
require 'json'

STORY = JSON.parse(File.read(File.join(__dir__, 'story.json')))

class Dungeon
	attr_accessor :player

	def initialize(player_name)
		@player = Player.new(player_name, self)
		@player.items = []
		@rooms = []
	end
	def start(location)
		@player.location = location
		build_world
		puts STORY["intro"]
		show_current_description
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

	def unlock_room()
		find_room_in_dungeon(@player.location).unlocked = true
	end

	private

	def build_world
		STORY["rooms"].each do |ref, data|
			descriptions = {}
			descriptions[false] = data["descriptions"]["locked"] if data["descriptions"]["locked"]
			descriptions[true] = data["descriptions"]["unlocked"] if data["descriptions"]["unlocked"]

			connections = {}
			data["connections"].each do |dir, dest|
				connections[dir.to_sym] = dest.to_sym
			end

			items = data["items"].map do |item_data|
				Item.new(item_data["name"], item_data["description"])
			end

			add_room(ref.to_sym, data["name"], descriptions, connections, items)
		end
	end
end

class Player
	attr_accessor :name, :location, :items, :dungeon

	def initialize(player_name, dungeon)
		@name = player_name
		@items = []
		@dungeon = dungeon
	end
	def directions
		puts STORY["messages"]["directions_header"]
		@dungeon.find_room_in_dungeon(location).connections.keys.each {|i| puts i.to_s + "\n"}
	end
	def go(direction)
		if @dungeon.find_room_in_dungeon(@location).is_adjoining_rooms?(direction) #only change @location if the new direction is valid.
			#set unlocked status of some areas when they are visited.
			if @dungeon.find_room_in_dungeon(@location).reference == :small_town then @dungeon.find_room_in_dungeon(@location).unlocked = true end
			if @dungeon.find_room_in_dungeon(@location).reference == :enchanted_forest then @dungeon.find_room_in_dungeon(@location).unlocked = true end
			if @dungeon.find_room_in_dungeon(@location).reference == :south_east_desert then @dungeon.find_room_in_dungeon(@location).unlocked = true end

			#change current @location to the new direction.
			new_location_ref = @dungeon.find_room_in_dungeon(@location).connections[direction]
			if @dungeon.find_room_in_dungeon(new_location_ref)
				puts STORY["messages"]["go_prefix"] + direction.to_s
				@location = new_location_ref
				@dungeon.show_current_description
			else
				puts STORY["messages"]["room_not_found"]
			end
		else
			puts STORY["messages"]["cant_go"]
		end
	end
	def take(item_name)
		if !@dungeon.find_room_in_dungeon(@location).items.select {|i| i.name == item_name}.empty? #Player can only take items in the room.
			@items = @items + @dungeon.find_room_in_dungeon(@location).items.select {|i| i.name == item_name}
			@dungeon.find_room_in_dungeon(@location).items.delete_if {|i| i.name == item_name}
			puts STORY["messages"]["item_taken"] % { item: item_name }
		else
			puts STORY["messages"]["item_not_found"]
		end
	end
	def inspect_item(item_name)
		all_items = @items + @dungeon.find_room_in_dungeon(@location).items
		if !all_items.select {|i| i.name == item_name}.empty?
			puts all_items.select {|i| i.name == item_name}.first.description
		else
			puts STORY["messages"]["item_not_in_backpack"]
		end
	end
	def use(item_name)
		if !items.select {|i| i.name == item_name}.empty? #Player can only use items he has with him.
			uses = STORY["item_uses"][item_name] || {}
			location_ref = @dungeon.find_room_in_dungeon(@location).reference.to_s
			case item_name
			when "crocodile-teeth"
				puts uses["default"]
			when "eagle-egg"
				puts uses["default"]
				items.delete_if {|i| i.name == "eagle-egg"}
			when "feather"
				puts uses["default"]
			when "drinking-bag"
				if @dungeon.find_room_in_dungeon(@location).reference == :small_town
					items.delete_if {|i| i.name == "drinking-bag"}
					transforms = uses["transforms_to"]
					items << Item.new(transforms["name"], transforms["description"])
					puts uses["small_town"]
				else
					puts uses["default"]
				end
			when "key"
				if @dungeon.find_room_in_dungeon(@location).reference == :small_town
					reveals = uses["reveals_items"]
					@dungeon.find_room_in_dungeon(@location).items = reveals.map {|i| Item.new(i["name"], i["description"])}
					@dungeon.find_room_in_dungeon(@location).items.flatten
					items.delete_if {|i| i.name == "key"}
					s = uses["small_town"]
					@dungeon.find_room_in_dungeon(@location).items.each { |i| s += i.name + ", " }
					puts s
				else
					puts uses["default"]
				end
			when "torch"
				if @dungeon.find_room_in_dungeon(@location).reference == :canyon
					puts uses["canyon"]
					transforms = uses["transforms_to"]
					t = items.select {|i| i.name == "torch"}
					t[0].name = transforms["name"]
					t[0].description = transforms["description"]
				else
					puts uses["default"]
				end
			when "lighted-torch"
				if @dungeon.find_room_in_dungeon(@location).reference == :entrance_cave
					@dungeon.unlock_room
					@dungeon.find_room_in_dungeon(@location).add_connection([:east, :cave_tunnel])
					puts uses["entrance_cave"]
				else
					puts uses["default"]
				end
			when "full-waterbag"
				if @dungeon.find_room_in_dungeon(@location).reference == :start_desert
					@dungeon.unlock_room
					@dungeon.find_room_in_dungeon(@location).add_connection([:south, :south_desert])
					@dungeon.find_room_in_dungeon(@location).add_connection([:east, :east_desert])
					@dungeon.find_room_in_dungeon(@location).add_connection([:north, :north_desert])
					puts uses["start_desert"]
				else
					puts uses["default"]
				end
			when "driftwood"
				if @dungeon.find_room_in_dungeon(@location).reference == :riverland
					puts uses["riverland"]
					if $stdin.gets.chomp.split(' ').any? {|i| i == "rope"} and !items.select {|i| i.name == "rope"}.empty?
						@dungeon.find_room_in_dungeon(@location).add_connection([:south, :farmland])
						@dungeon.find_room_in_dungeon(@location).unlocked = true
						items.delete_if {|i| i.name == "driftwood"}
						items.delete_if {|i| i.name == "rope"}
						puts uses["riverland_success"]
					else
						puts uses["riverland_fail"]
					end
				else
					if @dungeon.find_room_in_dungeon(@location).reference == :ocean
					 	puts uses["ocean"]
					else
						puts uses["default"]
					end
				end
			when "rope"
				if @dungeon.find_room_in_dungeon(@location).reference == :riverland
					puts uses["riverland"]
					player_answer = $stdin.gets.chomp
					if player_answer.split(' ').any? {|i| i == "driftwood"} and !items.select {|i| i.name == "driftwood"}.empty?
						@dungeon.find_room_in_dungeon(@location).add_connection([:south, :farmland])
						@dungeon.find_room_in_dungeon(@location).unlocked = true
						items.delete_if {|i| i.name == "driftwood"}
						items.delete_if {|i| i.name == "rope"}
						puts uses["riverland_success"]
					else
						puts uses["riverland_fail"]
					end
				else
					if @dungeon.find_room_in_dungeon(@location).reference == :ocean
					 	puts uses["ocean"]
					else
						puts uses["default"]
					end
				end
			when "blunt-blades"
				if @dungeon.find_room_in_dungeon(@location).reference == :smithy
					puts uses["smithy"]
					transforms = uses["transforms_to"]
					t = items.select {|i| i.name == "blunt-blades"}
					t[0].name = transforms["name"]
					t[0].description = transforms["description"]
				else
					puts uses["default"]
				end
			when "horse-armor"
				if @dungeon.find_room_in_dungeon(@location).reference == :smithy
					puts uses["smithy"]
					transforms = uses["transforms_to"]
					t = items.select {|i| i.name == "horse-armor"}
					t[0].name = transforms["name"]
					t[0].description = transforms["description"]
				else
					puts uses["default"]
				end
			when "draconian-armor"
				if @dungeon.find_room_in_dungeon(@location).reference == :start_mountain_pass
					puts uses["start_mountain_pass"]
					items.select {|i| i.name == "draconian-armor"}[0].used = true
					if !items.select {|i| i.name == "huge-talons"}.empty? #make sure player has item. before testing if its been used.
						if items.select {|i| i.name == "huge-talons"}[0].used == true
							puts uses["start_mountain_pass_combined"] #if player has item and it is used.
							@dungeon.find_room_in_dungeon(@location).add_connection([:south, :mountain_pass])
							items.delete_if {|i| i.name == "huge-talons"}
							items.delete_if {|i| i.name == "draconian-armor"}
							@dungeon.unlock_room
						else
							puts uses["start_mountain_pass_not_combined"] #if player has item but has not been used.
						end
					end
				else
					puts uses["default"]
				end
			when "huge-talons"
				if @dungeon.find_room_in_dungeon(@location).reference == :start_mountain_pass
					puts uses["start_mountain_pass"]
					items.select {|i| i.name == "huge-talons"}[0].used = true
					if !items.select {|i| i.name == "draconian-armor"}.empty? #make sure player has item. before testing if its been used.
						if items.select {|i| i.name == "draconian-armor"}[0].used == true
							puts uses["start_mountain_pass_combined"] #if player has item and it is used.
							@dungeon.find_room_in_dungeon(@location).add_connection([:south, :mountain_pass])
							items.delete_if {|i| i.name == "huge-talons"}
							items.delete_if {|i| i.name == "draconian-armor"}
							@dungeon.unlock_room
						else
							puts uses["start_mountain_pass_not_combined"] #if player has item but has not been used.
						end
					end
				else
					puts uses["default"]
				end
			end
		else
			puts STORY["messages"]["item_not_owned"]
		end
	end
	def which_item_in_backpack
		if !@items.empty?
			s = STORY["messages"]["sack_header"]
			@items.each {|i| s += "\n-" + i.name.to_s}
			puts s
		else
			puts STORY["messages"]["sack_empty"]
		end
	end
	def possible_actions
		puts STORY["messages"]["possible_actions"]
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

class Gamestorage

	def initialize(player_name)
		Dir.mkdir "savegames" unless Dir.exist? "savegames"
		plyrname = player_name.chomp.gsub(/^.*(\\|\/)/, '').gsub(/[^0-9A-Za-z.\-]/, '_').downcase #sanitize for saving.
		@path = "savegames/#{plyrname}"
	end

	def save_game(dungeon_object)
		save_yaml = YAML::dump(dungeon_object)
		f = File.open(@path, 'w') do |f|
			f.write save_yaml
		end
	end

	def load_game
		f = File.read(@path)
		if YAML.respond_to?(:unsafe_load)
			YAML.unsafe_load(f)
		else
			YAML.load(f)
		end
	end

	def save_exist?
		File.exist? @path
	end
end

puts STORY["messages"]["auto_resume"]
puts STORY["messages"]["name_prompt"]
player = $stdin.gets.chomp
storage = Gamestorage.new(player)

if storage.save_exist?
	#load from previous game
	d = storage.load_game
	d.show_current_description
else
	#create a new game
	d = Dungeon.new(player)
	d.start(:meadow_road)
end

puts " "
puts STORY["messages"]["choose_action"]
puts STORY["messages"]["separator"]
input = $stdin.gets.chomp.split(' ')
while !(input[0] == "exit") #or !(d.find_room_in_dungeon(d.player.location).reference == :home)
	command = input.shift
	next if command.nil? || command.empty?

	case command #take of first element of input for input in case. input array now no longer has first word.
	when "directions"
		d.player.directions
	when "sack"
		d.player.which_item_in_backpack
	when "go"
		d.player.go(input.join(' ').to_sym)
	when "take"
		d.player.take(input.join(' '))
	when "use"
		d.player.use(input.join(' '))
	when "inspect"
		d.player.inspect_item(input.join(' '))
	when "actions"
		d.player.possible_actions
	else
		puts STORY["messages"]["unknown_command"]
	end

	if !(d.find_room_in_dungeon(d.player.location).reference == :home) #as long as you're not at the end of the game ask for input again.
		puts STORY["messages"]["separator"]
		input = $stdin.gets.chomp.split(' ')
	else
		input[0] = "exit"
	end
end

#save game for user.
storage.save_game(d)
