require_relative "game.rb"
require_relative "display.rb"

include Display

game = Game.new("google-10000-english-no-swears.txt", 5, 12, 8)
print "Type 1 to start a new game. Type 2 to load an existing game: "
game_mode = gets.chomp
print "\n"
while game_mode.to_s!='1' && game_mode.to_s!='2' do
    display_red_text("Invalid option!")
    print "Type 1 to start a new game. Type 2 to load an existing game: "
    game_mode = gets.chomp
    print "\n"
end
if game_mode == '2' then
current_game_names = Dir["saved_games/*.yml"]
current_game_names.map! do |name|
    name[12,name.length]
end
if current_game_names.length == 0 then
    display_red_text("There are no saved games. You are now playing a new game.")
else
puts "Please select the game you wish to continue:"
puts current_game_names
print "\n"+"Type the name of the game you wish to play:"
file_to_load_name = gets.chomp
while !current_game_names.include?(file_to_load_name) do
    display_red_text("The file you selected doesn't exist")
    print "\n"+"Type the name of the game you wish to play:"
file_to_load_name = gets.chomp
end
game.overload_from_yaml("saved_games/#{file_to_load_name}")
end
end
game.play()