require 'yaml'

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
		puts "
+++++++++++++++++++"
		puts "Je hebt wijd en zijd gereisd in dienst van de drakenkoning. Je laatste opdrachten waren succesvol, maar de laatste tijd dwalen je gedachten steeds vaker af naar huis. Je nieuwste opdracht zou echter niet lang moeten duren en met versnelde pas vervolg je je weg."
		puts "+++++++++++++++++++"
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
		add_room(:meadow_road, 
			"Weideweg", 
			{false => "Je bevindt je op een weg omringd door vredig uitziende weiden. Schapen en koeien grazen in het grasland en je kunt je bijna voorstellen dat de herder naar zijn hond fluit. Er is echter geen herder en met zoveel schapen komt dat vreemd op je over. 
Het is nog lang geen zonsondergang, maar als je naar de lucht kijkt, is er een lange rode streep zichtbaar aan de hemel. Een duister voorteken als je er ooit een hebt gezien."}, 
			{:zuid => :small_town, :noord => :enchanted_forest, :oost => :canyon}, 
			[])
		add_room(:canyon,
			"Smalle Kloof",
			{false => "Je staat bij de ingang van een lange kloof. De zon staat hoog aan de hemel en schijnt haar onverbiddelijke hitte op je neer.
Een reusachtige arend blijft boven je cirkelen, alsof hij wacht tot de zon zijn werk doet. De rotsen en doornige struiken maken het navigeren door de kloof lastig. 
Als je om je heen kijkt, zie je een oude piramide die tegen de zijkant van de kloof is gebouwd. Na het beklimmen ervan vind je een groot vergrootglas dat stevig bovenop is geplaatst. Je probeert het los te wrikken, maar het geeft geen krimp. Er zitten brandplekken omheen. Terwijl je je hoofd schudt over de vreemde religies in de wereld, vervolg je je reis."},
			{:west => :meadow_road, :zuid => :hilly_country},
			[Item.new("veer", "
Deze veer ziet er nutteloos uit en je begint te denken dat je hem misschien niet had moeten oppakken. Je hebt echter vaker meegemaakt dat vreemdere voorwerpen toch nuttig bleken.")])
		add_room(:hilly_country,
			"Heuvelachtig Land",
			{false => "Een lieflijk pad slingert voor je uit door bossen en over heuvels. Terwijl je verder loopt, schrik je wakker uit je dagdromen wanneer je veel voetsporen op het pad opmerkt. Het lijkt erop dat een grote groep mensen onlangs door dit gebied is getrokken. Terwijl je verder loopt, zie je dat ze enkele kleine voorwerpen langs de weg hebben laten vallen. Helaas zijn de meeste daarvan nutteloos."},
			{:noord => :canyon, :west => :small_town},
			[Item.new("sleutel", "
Een enorme roestige sleutel. Het lijkt erop dat deze niet in een gewoon huishouden gebruikt kon worden. Het moet wel een heel grote deur zijn waar deze in past.")])
		add_room(:small_town, 
			"Klein Stadje", 
			{false => "Je staat voor de ingang van een klein stadje. Het bord bij de ingang zegt 'sta verenigd tegen het rijk', een strijdkreet die de laatste tijd aan populariteit won. Inw: 206, staat eronder, maar kleinere getallen zijn een paar keer doorgestreept. Nu ziet het eruit als een spookstad, want - na enig rondkijken - vind je er niemand. De inwoners zijn blijkbaar allemaal in allerijl vertrokken. Er is een groot plein in het centrum van de stad met een prachtige fontein. Dolfijnen blijven water spuiten voor het vermaak van een verlaten dorp. Terwijl je een gevoel van ergernis van je afschudt, zie je een enorm landhuis aan het hoofd van het plein. De enige die geschikt is om te plunderen, helaas zit deze op slot. Je merkt dat zelfs jij niet in staat bent om via de grote toegangsdeur in te breken..", true => "Je staat voor de ruïnes van het dorpje waar je kort daarvoor langs kwam. De dorpelingen hadden gelijk om het te verlaten, denk je. Terwijl je je een weg baant door de ruïnes, vind je de fontein en het landhuis nog intact."}, 
			{:noord => :meadow_road, :oost => :hilly_country}, 
			[])
		add_room(:entrance_cave, 
			"Ingang van een Grot", 
			{false => "Je ziet een grot in de verte. Na een wandeling over een klein pad sta je ervoor. Je probeert naar binnen te kijken, maar het is te donker om iets te zien. Had je maar wat licht.", true => "
Je ziet een grot in de verte. Na een wandeling over een klein pad sta je ervoor. Je probeert naar binnen te kijken, maar het is te donker om iets te zien. Gelukkig verlicht je fakkel de weg."}, 
			{:zuid => :enchanted_forest}, 
			[])
		add_room(:enchanted_forest, 
			"Betoverd Bos", 
			{false => "Je komt aan bij een vreemd cirkelvormig bos en concludeert dat het alleen het betoverde bos van de elfen kan zijn. Bij de rand zie je een prachtige boog versierd met bijna levensechte elfenbeelden. Terwijl je je naar het midden van het bos begeeft, vind je de overblijfselen van een occult ritueel van een elfensjamaan. Het slachtoffer van het bloedoffer - een kleine eekhoorn - ligt levenloos op het altaar. Het lijkt erop dat ook de elfen de rode veeg aan de hemel als een slecht voorteken beschouwen. Hoewel je jezelf als ruimdenkend beschouwt, betwijfel je of het offeren van een eekhoorn enig nut zal hebben. Terwijl je verder loopt, dringt een afschuwelijke geur je neus binnen. Het lijkt erop dat sommige elfen dezelfde twijfels hadden en hun toevlucht hebben gezocht in sterke drank. Je vindt ze met een kater liggend in hun eigen braaksel.", true => "Als je opnieuw het betoverde bos binnengaat, voelt het nu veel donkerder aan. Je vindt dit keer geen elfen met een kater, alleen verlaten boomhutten. Een bloedbad heeft hier onlangs plaatsgevonden. In het midden van het bos lijkt er een massagraf te zijn, nog niet toegedekt. Je ziet een eenzame eekhoorn rondlopen. Terwijl je je omdraait om te vertrekken, voel je dat daar enige poëtische gerechtigheid in zit."}, 
			{:zuid => :meadow_road, :noord => :entrance_cave}, 
			[Item.new("drinkzak", "
Zeer grote drinkzak gemaakt van de huid van een hert. Het lijkt oorspronkelijk bedoeld te zijn als offer, maar in hun roes hebben de elfen hem gebruikt voor hun drankspelletjes. De geur van sterke drank hangt er nog steeds in.")])
		add_room(:cave_tunnel, 
			"Grottunnel", 
			{false => "Voorzichtig stap je de grot binnen. Je hebt ooit een verhaal gehoord over een jongetje dat een grot binnenstapte en dagenlang ronddwaalde. Het zou best eens kunnen dat dat verhaal de oorsprong is van je grotfobie. Terwijl je je gevoelens van naderend onheil onderdrukt, loop je verder. Halverwege kom je een groep mannen tegen die daar kamperen. Ze zien er uitgehongerd uit, maar geven je toch wat vlees. Het is lang niet genoeg om je maag te vullen, maar je neemt wat je krijgen kunt en vervolgt je weg. De rest van je reis door de grot verloopt zonder incidenten."}, 
			{:west => :entrance_cave, :oost => :start_desert}, 
			[])
		add_room(:start_desert, 
			"Eindeloze Woestijn", 
			{false => "Vanaf de ingang van de grot strekt zich een eindeloze woestijn uit. Je begint je te voelen alsof je tussen de hamer en het aambeeld zit. Hoewel je denkt dat je het best een tijdje zonder water kunt uithouden, durf je je niet in de woestijn te wagen zonder vloeistof. Je kijkt er echter ook niet bepaald naar uit om weer terug door de grot te gaan.", true => "Een enorme woestijn strekt zich voor je uit. Gerustgesteld door de drinkzak begin je de eerste zandduin te beklimmen."}, 
			{:west => :cave_tunnel}, 
			[])
		add_room(:east_desert, 
			"Eindeloze Woestijn", 
			{false => "Kleine hittegolven stralen langzaam aan de horizon. De woestijn strekt zich naar alle kanten eindeloos uit. Je vervloekt jezelf dat je er niet aan hebt gedacht om een of andere vorm van schaduw mee te nemen. De zon beukt onverbiddelijk en je hoofd begint te bonzen. Met een lichte hoofdpijn die opkomt achter je oren, vervolg je je reis."}, 
			{:west => :start_desert, :noord => :north_east_desert, :zuid => :south_east_desert}, 
			[])
		add_room(:north_east_desert, 
			"Eindeloze Woestijn", 
			{false => "Je staat naast de troon van je leenheer terwijl hij opstaat midden in zijn tirade tegen een van zijn vazal-baronnen. Bij gelegenheden als deze heeft hij je graag in de buurt om mensen te intimideren. De troonzaal is groot en breed. Lange wandtapijten die de veldslagen van het rijk uitbeelden, hangen aan de wanden. Een ervan toont een eenzame ruiter op zijn draak, die een heel regiment van een lang vergeten koninkrijk aanvalt. Je bent vooral gesteld op die ene, omdat het je grootvader is die is vereeuwigd. Een gevoel van trots vervult je als je denkt aan de lange geschiedenis van dienstbaarheid en loyaliteit die je familie heeft met het rijk. Terwijl je je omdraait, zie je je familie terwijl de jongen rond de voeten van hun moeders rennen. Hun spel is luidruchtig maar onschadelijk terwijl ze over de binnenplaats van de burcht hollen. 
Met een schok word je wakker. Een kleine hagedis glijdt weg in zijn holletje. Je probeert je zenuwen te kalmeren. De woestijn is lang niet zo leeg als hij overdag lijkt. En lang niet zo heet bovendien. Je besluit de rest van de nacht verder te reizen, hoewel je geluk zult moeten hebben om overdag wat schaduw te vinden om te slapen."}, 
			{:zuid => :east_desert, :west => :north_desert}, 
			[])
		add_room(:north_desert, 
			"Eindeloze Woestijn", 
			{false => "Terwijl je vooruit struikelt, zie je rechts van je weer een fata morgana glinsteren. Wanhopig genoeg besluit je deze te gaan bekijken. Het ligt niet op de route die je volgde, maar je zult het toch niet veel langer overleven. Het is echt een heel pragmatische beslissing. Je lacht om de ironie dat deze natuurkracht slaagt waar zoveel anderen hebben gefaald. Het loopt tegen zonsondergang als je de oase nadert. Het glinsteren rond het beeld was gestopt doordat de zon lager kwam te staan, dus je twijfelt er niet meer aan dat het echt is. Met een zucht van verlichting plof je neer naast de kleine vijver in de oase. Nadat je je zak hebt bijgevuld, besluit je hier een paar dagen te blijven om te herstellen en te proberen op wat wild te jagen."}, 
			{:zuid => :start_desert, :oost => :north_east_desert}, 
			[])
		add_room(:south_east_desert, 
			"Eindeloze Woestijn", 
			{false => "Terwijl je door dit onherbergzame land loopt, zie je in de verte wat schaarse struiken. Misschien nader je eindelijk het einde van je reis door de woestijn. Je struikelt ergens over. De woestijn is zo glad als zand, dus je draait je om om het eens goed te bekijken. Het is een leren koord dat je voeten greep. Je voelt dat het ergens aan vastzit en begint het uit te graven. Het leer maakte deel uit van een groot gepantserd paard. Het skelet van het paard is schoongeschuurd door zandstormen. Het pantser is echter nog grotendeels intact.", true => "Terwijl je door dit onherbergzame land loopt, zie je in de verte wat schaarse struiken. Misschien nader je eindelijk het einde van je reis door de woestijn."}, 
			{:noord => :east_desert, :west => :south_desert, :zuid => :tundra},
			[Item.new("paardenharnas", "
Licht verroest. Het paard waarop je het vond, zal er geen nut meer voor hebben. Wellicht vind je in de toekomst een gelegenheid om er op de een of andere manier gebruik van te maken.")])
		add_room(:south_desert, 
			"Eindeloze Woestijn", 
			{false => "Het lijkt nu wel of er geen andere wereld is dan deze eindeloos glooiende duinen. Je gaat de ene af en de andere op. En weer een andere af. De cyclus herhaalt zich .. oneindig. Terwijl je de top van weer een duin bereikt, zie je in de verte de achterhoede van een kleine karavaan. Je overweegt ze te volgen om de weg te vragen, maar omdat ze de verkeerde kant op gaan, besluit je anders. Hen inhalen zou minstens een groot deel van de dag kosten. Je vindt het een omweg niet waard. 
Terwijl je aan de ene kant van de duin naar beneden komt, vervolg je je weg omhoog naar de volgende."}, 
			{:noord => :start_desert, :oost => :south_east_desert},
			[])	
		add_room(:tundra, 
			"Toendra", 
			{false => "Het landschap om je heen vertoont subtiele veranderingen. Het zand onder je wordt vervangen door rotsachtige grond en bomen zijn hier en daar aan de horizon te zien. Je bent de toendra aan de rand van de grenzen van het rijk binnengegaan. Het paardenvolk dat deze landen berijdt, is een trots volk en heeft de heerschappij van het rijk lang getrotseerd. Hun kracht komt echter vooral voort uit hun snelheid en mobiliteit, wat veel minder nuttig zou zijn in het land van het rijk. Gevangen tussen de woestijn en het rijk was er al vroeg in hun geschiedenis een ongemakkelijke status quo ontstaan. Jaren van economische uithongering en isolatie hadden hun aantal gedecimeerd. Ze vormden nu geen serieuze bedreiging meer voor iemand behalve een eenzame reiziger. Je houdt argwanend de horizon in de gaten terwijl je je een weg door het land baant."}, 
			{:noord => :south_east_desert, :west => :tundra_west, :zuid => :forest},
			[])	
		add_room(:tundra_west, 
			"Toendra", 
			{false => "Een uur geleden zag je een eenzame ruiter achter je aan de horizon. Van ruiters is bekend dat ze in groepen reizen en jagen, dus je weet zeker dat er meer moeten zijn. Je hebt ze misschien afgeschrikt, maar ruiters zijn nauwelijks lafaards en het zien van jou kan hen op ideeën voor wraak hebben gebracht. Je orders hadden niets te maken met het paardenvolk en het verstandigste was om hen te ontwijken. Terwijl je nadenkt over je volgende zet, zie je een stofwolk achter je. Het lijkt erop dat de keuze voor je is gemaakt. Het land biedt niet veel gelegenheid om je te verstoppen. Gelukkig zal het, als je nu je tempo verhoogt, vallen van de avond zijn wanneer ze je inhalen. Rustig begin je aan een gemakkelijke draf. 
Terwijl je rent, denk je na over je opties. Het paardenvolk is koppig en zal waarschijnlijk niet opgeven. Ze zullen zich gedurende de nacht verspreiden en een groot net weven waarin ze hopen je te vangen. Terwijl de schemering invalt, zie je geen stofwolk meer achter je. Ofwel ze gaven op, ofwel ze deden what je voorspelde. Na een tijdje bevind je je in een gunstiger landschap. Een labyrint van hoge rotsen die boven je hoofd uitsteken. Je oren vangen het gedempte geluid op van een paard met doeken om zijn hoeven gebonden. Nog een favoriete truc van de ruiters. Gelukkig zijn je oren scherper dan die van de gemiddelde mens en terwijl je je verstopt in een kleine spleet, passeert een eenzame ruiter je. Geruisloos besluip je hem van achteren. Als de ruiter je ziet, zal hij luid fluiten, waardoor de rest van de troep op je afkomt. Je overbrugt de laatste paar meter in een sprint. De ruiter draait zich verschrikt om, maar je springt bovenop het paard en schakelt de ruiter uit voordat hij zijn vrienden kan roepen. Met een andere snelle beweging breng je het paard tot zwijgen. Snel kijk je door de tassen van de ruiter. Niets bijzonders, behalve een set middellange, botte messen. 
Terwijl je opnieuw nadenkt over wat je nu moet doen, draai je je om en ga je terug. Het net van de ruiters heeft nu een gat en je bent van plan erdoorheen te glippen. De rest van de nacht breng je rennend door in de richting waar je vandaan kwam. Tegen de ochtend vind je ..."}, 
			{:oost => :tundra},
			[Item.new("botte-messen", "
Niet veel nut in de huidige vorm. Hoewel je denkt dat de meeste wapens nutteloos zijn. Deze specifieke messen kunnen misschien worden aangepast voor jouw gebruik.")])	
		add_room(:forest, 
			"Bos", 
			{false => "Je gaat het bos binnen met een gevoel van opluchting. Het bos wordt snel dichter en houdt al gauw het meeste licht tegen. Na een paar uur stuit je op een kleine weg. Je bepaalt snel je positie en beslist welke route je neemt. De weg slingert door het bos en je kunt nu flink doorlopen. Niet lang daarna tref je een man aan die aan een grote boom hangt. Zijn hoofd is gemarkeerd met de tatoeage van een verkrachter; het lijkt erop dat zijn laatste overtreding met een andere straf werd beantwoord. Het touw dat werd gebruikt, ziet er stevig en sterk uit."}, 
			{:noord => :tundra, :zuid => :riverland},
			[Item.new("touw", "
Lang en stevig, dit touw ziet er dik genoeg uit om een draak vast te binden. Je grinnikt. Dat zal waarschijnlijk niet snel gebeuren.")])	
		add_room(:riverland, 
			"Een brede rivier", 
			{false => "Je komt bij een brede rivier. Met snelle stroming en steile oevers zul je deze te voet niet kunnen oversteken. Terwijl je beide kanten op kijkt, zie je geen brug of vriendelijke veerman. Onzeker over welke kant je op moet gaan, gooi je in gedachten een muntje op en kies je een richting om de rivier te volgen.", true => "Weer terug bij de rivier. Je vlot drijft nog vredig waar je het hebt achtergelaten."}, 
			{:noord => :forest, :oost => :river_to_mountain, :west => :ocean},
			[])	
		add_room(:river_to_mountain, 
			"Rivier aan de bergkant", 
			{false => "Dagenlang de rivier stroomopwaarts volgend, zie je dat deze verdwijnt in de wand van een steile berghelling. Hier kun je er niet omheen. Sowieso geen goede plek om de rivier over te steken, want het krioelt er van een bijzonder gemeen uitziende soort krokodillen. Deze weg lijkt een doodlopend spoor."}, 
			{:west => :riverland},
			[Item.new("krokodillentanden", "
Je vond dit op de schedel van een dode krokodil, aan de kant van de rivier. Zo scherp als wat; je denkt dat het in de toekomst nog wel eens van pas kan komen.")])
		add_room(:ocean, 
			"Rivier naar Zee", 
			{false => "Terwijl je de rivier stroomafwaarts volgde, wenste je dat je een manier had om - op - de rivier te reizen, in plaats van - ernaast -. Natuurlijk, als je een middel had om op de rivier te reizen, had je niet stroomafwaarts hoeven gaan. 
De river werd langzaam breder en veranderde langzaam in mangrove. Wat het er niet makkelijker op zou maken. Na een halve dag zie je het einde van de rivier, waar deze in de oceaan stroomt, en een uur later loop je het strand op. Rotsen steken een stukje verder in de baai uit. Bij vloed zullen die onder water staan. Een gevaarlijke plek zonder vuurtoren. Alsof je gelijk bewezen wordt, vind je veel drijfhout van een schipbreuk op het strand, nog geen halve kilometer van de rivier. Zonder plan ga je zitten en sla je je kamp op voor de avond. Je denkt na over wat je nu gaat doen."}, 
			{:oost => :riverland},
			[Item.new("drijfhout", "
Dikke balken van de mast en stevige planken van het roer. Stevig materiaal en zeker goed genoeg als basismateriaal voor alles wat je kon bedenken.")])
		add_room(:farmland, 
			"Maïsvelden", 
			{false => "Reizend door velden met maïs en koren bevinden je je in een zeer vruchtbaar deel van het rijk. De boeren die op het land werken, zien er vermoeid uit terwijl je hen passeert, maar je verschijning is hen vertrouwd en de afstand is groot genoeg om hen niet af te schrikken. Rusteloos nu je in het rijk bent, vervolg je je weg."}, 
			{:noord => :riverland, :zuid => :mountain, :west => :smithy},
			[])
		add_room(:mountain, 
			"Een Torenhoge Berg", 
			{false => "Je voelt het einde van je reis naderen en je verlangt ernaar om naar huis te gaan. Je staat aan de voet van een enorme berg. Een paar uur eerder begon het zachtjes te sneeuwen en de grond is nu wit bedekt. De langzame dwarreling van vallende sneeuwvlokken zal een turbulente storm zijn op de top van de berg. Je timing had niet slechter kunnen zijn. Je bent blij dat je bekend bent met dit terrein, aangezien je je vaag herinnert dat er in het oosten een pas is."}, 
			{:noord => :farmland, :oost => :start_mountain_pass, :west => :canyon_topside},
			[])
		add_room(:start_mountain_pass, 
			"Ingang naar de Oostelijke Bergpas", 
			{false => "Terwijl je de bergpas nadert, zie je 6 griffioenen hoog in de lucht cirkelen. Het nieuws over je opdracht moet je aartsvijanden hebben bereikt. Nu de bergpas opgaan zou je in open terrein laten en je zou zeker worden opgemerkt. Twee of drie had je wel aangekund, maar vechten tegen zes zou een onzekere uitloop hebben. Voor het eerst tijdens deze zoektocht voel je spijt dat je je gevechtsuitrusting thuis hebt gelaten.", true => "De zes griffioenen cirkelen nog steeds boven de pas, maar je voelt je gesterkt door het feit dat je gewapend en gepantserd bent om verder te gaan."}, 
			{:west => :mountain},
			[])
		add_room(:mountain_pass, 
			"De Oostelijke Bergpas", 
			{false => "Voorzichtig hurk je neer bij een van de laatste bomen voor de grote en open vlakte van de pas. Je ziet er zes direct boven je cirkelen, wat waarschijnlijk betekent dat ze je hebben gezien. Griffioenen staan niet bekend om hun intelligentie, maar het zijn roedeldieren en hun jachtinstinct is uitstekend. Doordat ze in de lucht zijn, hebben ze het voordeel de strijdplek te kunnen kiezen, wat waarschijnlijk in de open lucht zal zijn waar ze van alle kanten kunnen komen. Je hebt echter liever het initiatief en ook al voel je je zelfverzekerd, je besluit te wachten tot het donker wordt. Het nachtzicht van griffioenen is gelijk aan dat van jezelf, maar de nacht is donker vannacht en ze zullen laag moeten vliegen of riskeren je kwijt te raken. 

Langzaam loop je het bos uit en kijk je omhoog. De splinter van de maan is onzichtbaar achter dikke donkere wolken. Het effect wordt enigszins verminderd door de witheid van de sneeuw, die de nacht oplicht. Het zal ermee door moeten kunnen. Geen van de beesten in de buurt, zover je kunt nagaan. Voorzichtig ga je op pad. 

Wanneer je uren later de kreet hoort, dacht je bijna dat je van ze af was. Je hurkt neer en kijkt omhoog in de richting van het geluid. Drie van hen vliegen laag op ongeveer 50 meter aan je rechterkant. Ze vliegen parallel aan je en bereiden zich niet voor om aan te vallen. Dat is niet logisch. Waarom je waarschuwen en tijd geven om ... Je wordt van opzij geraakt door een groot gewicht. Instinctief hurk je en probeer je je zwaartepunt te verlagen, maar je reactie was te laat en je merkt dat je opzij valt. Terwijl je dat doet, zwaai je echter met je staart en word je beloond door een stevig contact en een pijnlijke kreet. Je slaagt erin je vast te grijpen en wordt omhoog getrokken door de griffioen die probeert weg te komen. De twee anderen die er vlak achter zaten, vinden hun situatie plotseling veel minder prettig en proberen hun ramkoers te wijzigen. Met het momentum dat je hebt gekregen door je staartactie, zwaai je je lichaam naar de dichtstbijzijnde van de twee achtervolgers en slaag je erin een stevig contact te maken met een van zijn vleugels. Krijsend en kermend..."}, 
			{:west => :home},
			[])
		add_room(:canyon_topside, 
			"Bovenkant van de Kloof", 
			{false => "Langzaam nader je de afgrond. Het is een loodrechte val van een paar honderd meter naar de bodem van deze kloof. Een paar meter onder de afgrond zie je het nest van een grote arend. Je laat je zakken om een kijkje te nemen en vindt wat onuitgebroede eieren. Het is een tijdje geleden dat je hebt gegeten en hongerig grijp je deze kans aan. Terwijl je weer tegen de klif omhoog klimt, glimlach je als je ergens ver beneden een kleine piramide ziet."}, 
			{:oost => :mountain, :noord => :smithy},
			[Item.new("arendsei", "
Je hebt er één bewaard voor later, je hebt jezelf ingehouden en één ei meegenomen. Tenminste voor een tijdje zul je geen honger lijden.")])
		add_room(:smithy, 
			"Groot dorp", 
			{false => "Je nadert een groot dorp en gaat door de hoofdpoort naar binnen. De straten zijn leeggestroomd terwijl de bevolking zich in hun huizen verschuilt. Je kent dit dorp en zou het met rust hebben gelaten als je niet iets nodig had gehad. Terwijl je langs de hoofdweg loopt, nader je de smederij. 
Hoewel de smid een grote man is, is hij in eerste instantie niet bereid om naar buiten te komen. Je moet aandringen. Hoewel de stok genoeg zou zijn geweest, heb je medelijden genoeg met de man om ook de wortel te gebruiken. Je belooft hem dat hij door het rijk zal worden gecompenseerd. Hij lijkt bereid zijn ambacht uit te oefenen."}, 
			{:zuid => :canyon_topside, :oost => :farmland},
			[])
		add_room(:home, 
			"Drakenhol", 
			{false => "Vrolijk beklim je de brede cirkelvormige gang naar je hol. De voorouders van de keizer hebben dit speciaal laten maken voor jouw nageslacht. Als je de top bereikt, hoor je het gejuich van vreugde en verbazing als je jonge borelingen je zien. Met vreugdekreten rennen ze op je af en springen bovenop je. Lachend laat je ze begaan en begin je ze speels rond te werpen. Later zal er tijd zijn om verslag uit te brengen aan de keizer over je vernietiging van de menselijke en elfenopstand. Voor nu geniet je van het eenvoudige spel van je gezin.



"},
			{:noord => :start_mountain_pass},
			[])
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
		puts "
Vanaf hier kun je gaan naar: 
"
		@dungeon.find_room_in_dungeon(location).connections.keys.each {|i| puts i.to_s + "
"}
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
				puts "
Je gaat naar het " + direction.to_s
				@location = new_location_ref
				@dungeon.show_current_description
			else
				puts "
Oeps, die kamer lijkt niet te bestaan in de wereld-structuur!"
			end
		else
			puts "
Het lijkt niet mogelijk om daarheen te gaan. Kies een andere richting."
		end
	end
	def take(item_name)
		if !@dungeon.find_room_in_dungeon(@location).items.select {|i| i.name == item_name}.empty? #Player can only take items in the room. 
			@items = @items + @dungeon.find_room_in_dungeon(@location).items.select {|i| i.name == item_name}
			@dungeon.find_room_in_dungeon(@location).items.delete_if {|i| i.name == item_name}
			puts "Je stopt de " + item_name + " in je zak."
		else
			puts "Dat voorwerp is niet in deze kamer."
		end
	end
	def inspect_item(item_name)
		all_items = @items + @dungeon.find_room_in_dungeon(@location).items
		if !all_items.select {|i| i.name == item_name}.empty?
			puts all_items.select {|i| i.name == item_name}.first.description
		else
			puts "Je kunt dat voorwerp niet vinden en hebt het ook niet in je rugzak."
		end
	end
	def use(item_name)
		if !items.select {|i| i.name == item_name}.empty? #Player can only use items he has with him. 
			case item_name
			when "krokodillentanden"
				puts "
Je kijkt ernaar en probeert een toepassing te bedenken voor je huidige situatie. De taak gaat je te boven. Je legt het terug."
			when "arendsei"
				puts "
Je eet snel je laatste ei op. Het vult je maag en laat je slaperig maar voldaan achter."
				items.delete_if {|i| i.name == "arendsei"}
			when "veer"
				puts "
Je krabt jezelf onder je voeten met de puntige kant en geniet van een moment van verlichting van een aanhoudende jeuk."
			when "drinkzak"
				if @dungeon.find_room_in_dungeon(@location).reference == :small_town
					items.delete_if {|i| i.name == "drinkzak"}
					items << Item.new("volle-waterzak", "
tot de rand gevuld met sprankelend koud water. Zeker om je dorst te lessen in tijden van nood. Zwaar om te dragen voor een volwassen man, maar jij vindt het logisch dat je het zonder veel moeite kunt dragen.")
					puts "
Je vult de drinkzak met water. Je spoelt de drank eruit door hem een paar keer te vullen en te legen."					
				else
					puts "
Je kijkt om je heen en vraagt je af wat je ermee kunt doen. Er schiet je niets te binnen. Je bergt het weer op."
				end
			when "sleutel"
				if @dungeon.find_room_in_dungeon(@location).reference == :small_town
					@dungeon.find_room_in_dungeon(@location).items = [Item.new("fakkel", "
Een lange stok met wat doek aan het uiteinde.
Bij nadere inspectie lijkt het vochtig te zijn van wat olie.")]
					@dungeon.find_room_in_dungeon(@location).items.flatten
					items.delete_if {|i| i.name == "sleutel"}
					s = ""
					s += "
Je opent de deur van het landhuis en vindt binnen:
"
					@dungeon.find_room_in_dungeon(@location).items.each { |i| s += i.name + ", " }
					puts s
				else
					puts "
Je weet echt niet wat je hier ermee moet doen."
				end
			when "fakkel"
				if @dungeon.find_room_in_dungeon(@location).reference == :canyon
					puts "
Je plaatst de fakkel onder het vergrootglas en wacht tot de zon zijn werk doet. Na een tijdje word je beloond met een beetje rook en na nog wat wachten vat de fakkel vlam. Je bent nu in het bezit van een brandende fakkel."
					t = items.select {|i| i.name == "fakkel"}
					t[0].name = "brandende-fakkel"
					t[0].description = "
Je fakkel brandt langzaam en werpt een griezelig licht. De duisternis lijkt nu veel minder eng."
				else
					puts "
Je houdt de fakkel in je handen en wacht tot er iets gebeurt. Hoewel er niemand kijkt, voel je na een tijdje een beetje idioot. Met een gevoel van schaamte berg je hem weer op."
				end
			when "brandende-fakkel"
				if @dungeon.find_room_in_dungeon(@location).reference == :entrance_cave
					@dungeon.unlock_room
					@dungeon.find_room_in_dungeon(@location).add_connection([:oost, :cave_tunnel])
					puts "
Terwijl je de fakkel omhoog houdt, verlicht je de grot. Je voelt je nu dapper genoeg om de grot binnen te gaan."
				else
					puts "
Je brandt jezelf aan de fakkel. Terwijl je vloekt, berg je hem op. Hij was hier toch niet nuttig."					
				end
			when "volle-waterzak"
				if @dungeon.find_room_in_dungeon(@location).reference == :start_desert
					@dungeon.unlock_room
					@dungeon.find_room_in_dungeon(@location).add_connection([:zuid, :south_desert])
					@dungeon.find_room_in_dungeon(@location).add_connection([:oost, :east_desert])
					@dungeon.find_room_in_dungeon(@location).add_connection([:noord, :north_desert])
					puts "
Terwijl je het zware gewicht van de waterzak op je rug voelt, ben je verzekerd van je vermogen om in de woestijn te overleven. Je hoeft alleen nog maar te kiezen in welke richting je vertrekt."
				else
					puts "
Je morst per ongeluk wat water. Niet echt van belang, maar op de een of andere manier voel je je weer klein. Je ouders hadden geen geduld voor onhandigheid."					
				end
			when "drijfhout"
				if @dungeon.find_room_in_dungeon(@location).reference == :riverland
					puts "Met welk voorwerp wil je dit combineren?"
					if $stdin.gets.chomp.split(' ').any? {|i| i == "touw"} and !items.select {|i| i.name == "touw"}.empty?
						@dungeon.find_room_in_dungeon(@location).add_connection([:zuid, :farmland])
						@dungeon.find_room_in_dungeon(@location).unlocked = true
						items.delete_if {|i| i.name == "drijfhout"}
						items.delete_if {|i| i.name == "touw"}
						puts "
Terwijl je de laatste knoop legt, kijk je tevreden naar je creatie. Het enorme vlot zal groot genoeg zijn om je aanzienlijke omvang te ondersteunen. Vertrouwend op de kwaliteit duw je het de rivier op."
					else
						puts "
Je weet niet hoe je die moet combineren."
					end
				else
					if @dungeon.find_room_in_dungeon(@location).reference == :ocean
					 	puts "
De rivier is hier veranderd in een mangrove. Geen goede plek om over te steken."
					else
						puts "
Je staart er een tijdje naar en wacht tot het kwartje valt. 
Het gebeurt niet. Beter iets anders bedenken dan."
					end
				end
			when "touw"
				if @dungeon.find_room_in_dungeon(@location).reference == :riverland
					puts "Met welk voorwerp wil je dit combineren?"
					player_answer = $stdin.gets.chomp
					if player_answer.split(' ').any? {|i| i == "drijfhout"} and !items.select {|i| i.name == "drijfhout"}.empty?
						@dungeon.find_room_in_dungeon(@location).add_connection([:zuid, :farmland])
						@dungeon.find_room_in_dungeon(@location).unlocked = true
						items.delete_if {|i| i.name == "drijfhout"}
						items.delete_if {|i| i.name == "touw"}
						puts "
Terwijl je de laatste knoop legt, kijk je tevreden naar je creatie. Het enorme vlot zal groot genoeg zijn om je aanzienlijke omvang te ondersteunen. Vertrouwend op de kwaliteit duw je het de rivier op."
					else
						puts "
Je weet niet hoe je die moet combineren."
					end
				else
					if @dungeon.find_room_in_dungeon(@location).reference == :ocean
					 	puts "
De rivier is hier veranderd in een mangrove. Geen goede plek om over te steken."
					else
						puts "
Je staart er een tijdje naar en wacht tot het kwartje valt. 
Het gebeurt niet. Beter iets anders bedenken dan."
					end
				end
			when "botte-messen" 
				if @dungeon.find_room_in_dungeon(@location).reference == :smithy
					puts "
Op jouw aanwijzingen begint de smid aan je messen te werken. Een jonge leerling stookt het vuur op, terwijl de smid de messen in de rode kolen legt. Na een paar uur werk komt hij terug met een set reusachtige klauwen. Je inspecteers ze met oog voor detail. Na een tijdje snuif je tevreden. Deze voldoen."
					t = items.select {|i| i.name == "botte-messen"}
					t[0].name = "reusachtige-klauwen"
					t[0].description = "
Terwijl je probeert deze aan te trekken, denk je dat ze wel zullen voldoen. 
Hoewel de smid niet bekend was met het ontwerp, heeft hij er goed werk van geleverd."
				else
					puts "Geen nut voor die dingen hier. In hun huidige vorm zijn ze nutteloos."
				end
			when "paardenharnas"
				if @dungeon.find_room_in_dungeon(@location).reference == :smithy
					puts "
De smid lijkt geïnteresseerd in deze klus. Na een half dozijn vragen te hebben afgevuurd, gaat hij aan het werk. Het zal even duren, waarschuwt hij. Je nestelt je voor zijn winkel. Terwijl de smid werkt, overwint de nieuwsgierigheid van zijn kinderen langzaam hun angst, en een voor een komen ze naar buiten. Je houdt van kinderen van elke soort, dus je laat je meeslepen in hun jeugdige spel. Wanneer de smid terugkeert met zijn werk, loopt het tegen de middag. Terwijl hij zijn kinderen naar binnen stuurt voor de lunch, bekijk je zijn werk. Je bent onder de indruk en belooft hem dat je zijn werk zult aanbevelen bij de meestersmid van de keizer wanneer je thuiskomt. Hij lijkt tevreden met zichzelf."
					t = items.select {|i| i.name == "paardenharnas"}
					t[0].name = "draconisch-harnas"
					t[0].description = "
De smid heeft hier uitstekend werk geleverd! Het harnas glanst als nieuw en zit als gegoten. Er was wat extra metaal nodig, maar de verbindingen vallen nauwelijks op."
				else
					puts "
Geen nut daarvoor hier. In de huidige vorm is het nutteloos."
				end
			when "draconisch-harnas" 
				if @dungeon.find_room_in_dungeon(@location).reference == :start_mountain_pass
					puts "
Langzaam en sereen trek je het draconische harnas aan."
					items.select {|i| i.name == "draconisch-harnas"}[0].used = true 
					if !items.select {|i| i.name == "reusachtige-klauwen"}.empty? #make sure player has item. before testing if its been used.
						if items.select {|i| i.name == "reusachtige-klauwen"}[0].used == true 
							puts "
Gecombineerd met je harnas ben je klaar voor de strijd. Je bent nu bereid om de pas over te steken." #if player has item and it is used.
							@dungeon.find_room_in_dungeon(@location).add_connection([:zuid, :mountain_pass])
							items.delete_if {|i| i.name == "reusachtige-klauwen"}
							items.delete_if {|i| i.name == "draconisch-harnas"}
							@dungeon.unlock_room
						else
							puts "Je voelt je nu veel veiliger, maar betwijfelt of het genoeg zal zijn tegen de griffioenen." #if player has item but has not been used.
						end
					end
				else
					puts "
Je trekt het aan en ziet er stoer uit. Stel je voor. Geen ander nut echter. Je stopt het terug in je zak."
				end
			when "reusachtige-klauwen" 
				if @dungeon.find_room_in_dungeon(@location).reference == :start_mountain_pass
					puts "
Je schuift de klauwen over je poten. Je knikt goedkeurend terwijl je het extra bereik test dat ze je bieden."
					items.select {|i| i.name == "reusachtige-klauwen"}[0].used = true 
					if !items.select {|i| i.name == "draconisch-harnas"}.empty? #make sure player has item. before testing if its been used.
						if items.select {|i| i.name == "draconisch-harnas"}[0].used == true 
							puts "
Gecombineerd met je armor, ben je klaar voor de strijd. Je bent nu bereid om de pas over te steken." #if player has item and it is used.
							@dungeon.find_room_in_dungeon(@location).add_connection([:zuid, :mountain_pass])
							items.delete_if {|i| i.name == "reusachtige-klauwen"}
							items.delete_if {|i| i.name == "draconisch-harnas"}
							@dungeon.unlock_room	
						else
							puts "Je voelt je nu veel veiliger, maar betwijfelt of het genoeg zal zijn tegen de griffioenen." #if player has item but has not been used.
						end
					end
				else
					puts "
Je schuift ze over je poten en ziet er stoer uit. Stel je voor. Geen ander nut echter. Je stopt ze terug in je zak."
				end
			end
		else
			puts "
Je lijkt dat voorwerp niet bij je te hebben."
		end
	end
	def which_item_in_backpack
		if !@items.empty?
			s = ""
			s += "
In je zak heb je:"
			@items.each {|i| s += "
-" + i.name.to_s}
			puts s
		else
			puts "
Je zak is leeg."
		end
	end
	def possible_actions
		puts "
Mogelijke acties: 
-richtingen
-ga <noord/zuid/oost/west>
-pak <voorwerp>
-inspecteer <voorwerp>
-gebruik <voorwerp>
-zak
-stop"
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
		s += "

" + name + "

" + read_description
		if @items.any?
			s += "

Je vindt hier: " 
			@items.each { |i| s += i.name + ", " }
		end
		return s
	end
	def read_description
		s = ""
		s = "********
" if @unlocked == true #make it clear the text has changed from the first by adding *** before the text. 
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
		Dir.mkdir "savegames_nl" unless Dir.exist? "savegames_nl"
		plyrname = player_name.chomp.gsub(/^.*(\|\/)/, '').gsub(/[^0-9A-Za-z.\-]/, '_').downcase #sanitize for saving.
		@path = "savegames_nl/#{plyrname}"
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

puts "Het spel wordt automatisch hervat als je al eerder hebt gespeeld (gebaseerd op je naam)."
puts "Wat is je naam?"
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
puts "Kies een actie. 
Type 'acties' voor een overzicht van mogelijke acties."
puts "------------------------"
input = $stdin.gets.chomp.split(' ')
while !(input[0] == "stop") #or !(d.find_room_in_dungeon(d.player.location).reference == :home)
	command = input.shift
	next if command.nil? || command.empty?

	case command
	when "richtingen"
		d.player.directions
	when "zak"
		d.player.which_item_in_backpack
	when "ga"
		d.player.go(input.join(' ').to_sym)
	when "pak"
		d.player.take(input.join(' '))
	when "gebruik"
		d.player.use(input.join(' '))
	when "inspecteer"
		d.player.inspect_item(input.join(' '))
	when "acties"
		d.player.possible_actions
	else
		puts "
Je krabt achter je oren en denkt na. 
Nee, je weet echt niet hoe je dat moet doen.."
	end
	
	if !(d.find_room_in_dungeon(d.player.location).reference == :home) #as long as you're not at the end of the game ask for input again.
		puts "------------------------"
		input = $stdin.gets.chomp.split(' ')
	else
		input[0] = "stop"
	end
end

#save game for user.
storage.save_game(d)
