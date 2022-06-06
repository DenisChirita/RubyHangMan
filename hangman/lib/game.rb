require_relative "display.rb"
require 'set'
require'yaml'

class Game
    include Display
    def initialize(file_name, minimum_word_length, maximum_word_length, number_of_incorrect_guesses)
        english_dictionary = read_file(file_name)
        @secret_word = select_random_word(minimum_word_length,maximum_word_length, english_dictionary)
        initialize_guessed_word()
        @number_of_incorrect_guesses_left = number_of_incorrect_guesses
        @used_letters = Set.new
        @number_of_guessed_letters=0
    end

    def overload_from_yaml(yaml_file_path)
        game_data = YAML.load_file(yaml_file_path)
        @secret_word = game_data[:secret_word]
        @number_of_incorrect_guesses_left = game_data[:number_of_incorrect_guesses_left]
        @used_letters = game_data[:used_letters]
        @number_of_guessed_letters = game_data[:number_of_guessed_letters]
        @guessed_word = game_data[:guessed_word]
    end

    def play
        while @number_of_incorrect_guesses_left>0 do 
            guess_letter()
            if isWin? then
                display_win_message
                return;
            end
        end
        if @number_of_incorrect_guesses_left==0 then
            display_lose_message(@secret_word)
        end
    end

    def guess_letter
        display_current_game_state(@number_of_incorrect_guesses_left, @used_letters, @guessed_word)
        guessed_letter = read_letter().downcase
        if guessed_letter=='save' then
            print "Please type the name of the file in which your game progress will be saved: "
            file_name = gets.chomp 
            File.write("saved_games/#{file_name}.yml",self.to_yaml)
            puts "\n"+"Your Game has been successfully saved!"
            exit(0)
        end
        good_guess=false
        @secret_word.split('').each_with_index do |letter, index|
            if guessed_letter==letter then
                @guessed_word[index]=letter
                good_guess=true
                @number_of_guessed_letters+=1
            end
        end
        @used_letters.add(guessed_letter)
        if !good_guess then
            @number_of_incorrect_guesses_left-=1
            display_bad_guess_message
        else
            display_good_guess_message
        end
    end

    def to_yaml
        YAML.dump ({
          :secret_word => @secret_word,
          :number_of_incorrect_guesses_left => @number_of_incorrect_guesses_left,
          :used_letters => @used_letters,
          :number_of_guessed_letters => @number_of_guessed_letters,
          :guessed_word => @guessed_word
        })
      end

      def self.from_yaml(string)
        data = YAML.load string
        p data
      end


    private

    def read_file(file_name)
        english_dictionary = []
        english_dictionary_file= File.open("google-10000-english-no-swears.txt","r")
        while !english_dictionary_file.eof? do
            word = english_dictionary_file.readline.chomp
            english_dictionary.push(word)
        end
        english_dictionary
    end
    
    def select_random_word(minimum_length, maximum_length, english_dictionary)
        words_with_right_size = english_dictionary.select{|word| word.length>=minimum_length && word.length<=maximum_length} 
        words_with_right_size[rand(words_with_right_size.length)] 
    end

    def initialize_guessed_word
        @guessed_word=@secret_word.split("")
        @guessed_word.map!{|letter| '_'}
    end

    def read_letter
        print "Enter a letter, or type save to save progress: "
        letter = gets.chomp.downcase
        print "\n"
        while(letter!='save'&&!(letter.length==1&& letter.match?(/[A-Za-z]/)&& !@used_letters.include?(letter))) do
            if letter.length==1&& letter.match?(/[A-Za-z]/) then
                print "You have already tried this letter. Please pick another letter: "
            else
                print "You did not type a letter. Please pick a letter: "
            end
            letter = gets.chomp.downcase
            print "\n"
        end
        letter
    end

    def isWin?
        if @number_of_guessed_letters==@secret_word.length then
            return true
        else
            return false
        end
    end
end