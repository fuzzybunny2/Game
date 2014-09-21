require_relative 'intro'

class WorldState
  attr_accessor :player_state

  @@locationless_actions = ["whereami"]

  def initialize( )
    @player_state = {}
    @player_state[:location] = "startpoint"
  end

  def process_command(command)
    split_command = command.split(" ")
    action = split_command[0]
    noun = split_command[1]
    if @@locationless_actions.include?(action)
      process_locationless_action(action, noun)
    else
      process_action(action, noun)
    end
    self
  end

  def process_locationless_action(action, noun)
    if action == "whereami"
      respond "player_state #{@player_state}"
    end
  end

  def process_action(action, noun)
    case @player_state[:location]
    when "startpoint"
      startpoint(action, noun)
    when "boot"
      boot(action, noun)
    when "shack"
      shack(action, noun)
    when "garden"
      garden(action, noun)
    when "boat"
      boat(action, noun)
    when "lake"
      lake(action, noun)
    when "camp"
      camp(action, noun)
    else
      respond "You are not in shell world, but you are in the #{@player_state[:location]}"
    end
  end

  def startpoint(action, noun)
    if action == "go" && noun == "north"
      respond "You walk up to the shack. There are several wooden boards slapped on the shack. Looks like a flimsy door. It falls apart as soon as you touch it and several large boards now lie on the ground."
      @player_state[:location] = "shack"
    elsif action == "go" && noun == "south"
      respond "How cute! It's a tiny little garden! There's a sign in the middle of the garden with some words scrawled on it"
      @player_state[:location] = "garden"
    elsif action == "go" && noun == "east"
      respond "You've reached a dock. You stick your toe in the water. It's far too cold for you to swim in... you'd die."
      @player_state[:location] = "boat"
    elsif action == "go" && noun == "west"
      respond "It looks like something crashed here. There is a long skid mark on the ground that ends in a big mound of dirt"
      @player_state[:location] = "boot"
    else
      respond "Which direction would you like to go?"
    end
  end

  def boot(action, noun)
    if action == "go" && noun == "north"
      respond "The area seems to be blocked off by large faintly glowing rocks."
    elsif action == "go" && noun == "south"
      respond "The area seems to be blocked off by large faintly glowing rocks."
    elsif action == "go" && noun == "east"
      respond "You're back at where you woke up. There is an interesting looking shack in front of you"
      @player_state[:location] = "startpoint"
    elsif action == "go" && noun == "west"
      respond "The area seems to be blocked off by large faintly glowing rocks."
    elsif action == "examine" && noun == "dirt"
      respond "Looks like a shoe crashed here.. I wonder what giant fit in these shoe.. he must not have practiced personal hygiene.. oof..I don\'t feel so good. \nThere are some loose nails sticking out the shoe. of course you take them... klepto"
      @player_state[:nails] = 1
    else
      respond "What would you like to do?"
    end
  end

  def shack(action, noun)
    if action == "go" && noun == "north"
      respond "The same glowing light from outside pours in from the gaps in the wall. This is a very poorly made shack. There is a bag hanging on this wall"
    elsif action == "go" && noun == "south"
      respond "You exit the shack and look back at it. What a peculiar looking building."
      @player_state[:location] = "startpoint"
    elsif action == "examine" && (noun == "wall"||noun == "paper"||noun == "papers")
      respond "Upon closer inspection they look to be crayon drawings of gibberish. One drawing looks like someone attempted to draw something that looks like a cat.. unicorn. The last drawing has some words on it. You read it.
      \nNow I lay me down to sleep \nI pray the Lord my soul to keep \nAnd if I die before I wake, \nI pray the Lord my toys to break. \nSo none of the other kids can use 'em \nAmen"
    elsif action == "go" && noun == "east"
      respond "You walk up to the east wall of the shack. There are some papers fluttering on the wall."
    elsif action == "go" && noun == "west"
      respond "Nothing to see here... this wall seems unstable.. better move away fast!"
    elsif action == "examine" && noun == "bag"
      respond "There's a tube of glue in here. You pocket it. Why on earth would you need that?"
      @player_state[:glue] = 1
    elsif action == "examine" && (noun == "ground" || noun == "board" || noun == "boards")
      respond "You pick up the wood you find on the ground. .. this is a strange habit you have..."
      @player_state[:wood] = 1
     else
      respond "I mostly only understand commands that start with \"go\" or \"examine\". WHAT?! HOW DARE YOU SUGGEST I\'M NOT SMART!"
     end
  end

  def garden(action, noun)
    if action == "go" && noun == "north"
      respond "You're back where you woke up. There is an interesting looking shack in front of you"
      @player_state[:location] = "startpoint"
    elsif action == "go" && noun == "south"
      respond "You're blocked off by a huge mound of rocks"
    elsif action == "go" && noun == "east"
      respond "You run into water. The gentle waves lap onto the faintly glowing ground. The water is much too cold for you to be in"
    elsif action == "go" && noun == "west"
      respond "You're blocked off by a mound of faintly glowing rocks"
    elsif action == "examine" && noun == "sign"
      respond "You pick your footing around the growing plants to reach the sign. \nWe gave you a sign \nTo water the plants \nWe didn't mean that way \nNow zip up your pants."
      respond "WHAT?! Was someone watching me?!"
    elsif action == "examine" && (noun == "dirt"||noun == "ground")
      respond "What's this hammer lying here? You take it. I believe that is STEALING."
      @player_state[:hammer] = 1
    else
      respond "What would you like to do?"
    end
  end

  def boat(action, noun)
    if action == "go" && noun == "north"
      respond "You face north on the dock. Doesn't seem like there's land in this direction as far as you can see."
    elsif action == "go" && noun == "south"
      respond "You face south on the dock. All you see is darkness and the sound of waves lapping onto the dock. How creepy."
    elsif action == "go" && noun == "east"
      respond "You walk to the end of the dock. From the glow you can see off in the distance, it looks like there\'s land across the water! There is a boat sitting here."
    elsif action == "go" && noun == "west"
      respond "You\'re back where you woke up. In front of you is a peculiar looking shack"
      @player_state[:location] = "startpoint"
    #Todo - fix this, causing nil class error when user enters go east
    elsif action == "examine" && noun == "boat" && @player_state[:wood] == 1 && @player_state[:nails] == 1 && @player_state[:hammer] == 1 && @player_state[:glue] == 1 && @player_state[:response] == 1
      respond "OH! You can use the wood, nails, glue, and hammer you collected to patch up this boat! Aren't you glad I kindly told you to pick those things up now?"
      @player_state[:location] = "lake"
    elsif action == "examine" && noun == "boat"
      respond "You see a note pinned on the side"
    elsif action == "examine" && noun == "note"
      respond "You read the note. \nThe boat we built is just fine. \nDon't try to tell us it's not. \nThe sides and back are divine \nIt's the bottom I guess we forgot."
      respond "What a worthless boat..."
      @player_state[:response] = 1
    else
      respond "What would you like to do?"
    end
  end

  def lake(action, noun)
    if action == "go" && noun == "north"
      respond "The area seems to be blocked off by large faintly glowing rocks in the water."
    elsif action == "go" && noun == "south"
      respond "This area is blocked off by some large boulders in the water.. there seem to be boulders everywhere"
    elsif action == "go" && noun == "east" && @player_state[:song] == 1
      respond "Your boat rocks a bit as it gently hits land. You get off the boat. Is that coffee I smell? You see the soft red glow of a smoldering fire off to the east"
      @player_state[:location] = "camp"
    elsif action == "go" && noun == "east"
      respond "You get in the boat and push off from the dock. A warbling sound drifts across the lake. I think someone is singing."
      respond "The big fish eats the tiny fish, \nThe big fish eats the little fish-- \nSo only the biggest fish get fat. \nDo you know any folks like that?"
      respond "... so strange..."
      @player_state[:song] = 1
    elsif action == "go" && noun == "west"
      respond "You can't head back to the dock, looks like you're stuck!"
    else
      respond "Which direction would you like to go?"
    end
  end

  def camp(action, noun)
    if action == "go" && noun == "north"
      respond "You're blocked off by rocks. These stupid rocks are everywhere."
    elsif action == "go" && noun == "south"
      respond "You're blocked off by rocks."
    elsif action == "go" && noun == "east"
      respond "You reach the fire. Looks like it was only recently put out! There is a bowl of stew and a kettle with some liquid in it"
    elsif action == "examine" && noun == "stew"
      respond "Smells good. Looks like whoever made this just threw in a hodgepodge of whatever scraps of food they had. I'm not tasting that for you!"
    elsif action == "examine" && noun == "kettle"
      respond "IT'S COFFEE!! .. I'll take that..."
    elsif action == "go" && noun == "west"
      respond "You head back onto the lake"
      @player_state[:location] = "lake"
    elsif (action == "eat" || action == "taste") && noun == "stew"
      @player_state[:dysentery] = true
    elsif action == "examine" && noun == "ground"
      respond "That's weird, did this feather just fall from the sky?"
    elsif action == "examine" && noun == "sky"
      @player_state[:finish] = true
    else
      respond "What would you like to do?"
    end
  end


  def respond(response)
  #for debugging purposes
  #puts "player_state #{@player_state}"
    puts "#{response}\n\n"
  end
end

puts "What's your name traveler? \n"
player_name = gets.chomp

puts "Good morning #{player_name}. So nice of you to wake up. \nYou look confused. Where are you you ask? Hm, not very bright are we?\nWell I have no idea where you are, I got a little sleepy last night too you know. \nIt seems to be dark but the area is lit up by a glow coming off the ground. \nThere is an interesting looking shack in front of you."

puts "What would you like to do? \n"

world_state = WorldState.new()

while command = gets.chomp
world_state = world_state.process_command(command)
 if world_state.player_state[:dysentery] == true
   puts "You die of dysentery. Game Over. Thank you for playing"
   break
 elsif world_state.player_state[:finish] == true
   puts "You hear some quickly approaching sounds. A large object flies by over your head. It's shortly followed by some happy screaming and three voices pipe up"
   puts "\"HOORAY!\" \n\"WHAT FUN!\" \n\"IT'S TIME WE FLEW!\""
   puts "cried Ickle me, Pickle me, Tickle me too"
   puts "What a bunch of weirdos. Let's eat this stew."
   break
 end
end
