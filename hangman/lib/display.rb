require 'set'
module Display


def display_green_text(text)
    puts "\e[#{32}m#{text}\e[0m"
end

def display_red_text(text)
    puts "\e[#{31}m#{text}\e[0m"
end

def display_yellow_text(text)
    puts "\e[#{33}m#{text}\e[0m"
end

def get_bold_text(text)
    "\e[1m#{text}\e[22m"
end

def display_win_message
    print "\n"
    display_green_text("Congratulations! You guessed the word!")
    print "\n"
end

def display_lose_message(secret_word)
    print "\n"
    display_red_text("Oh, no! You didn't guess the word. "+ get_bold_text("Guess I will have to hang you now!"))
    display_yellow_text("The correct word was "+ get_bold_text("#{secret_word}."))
    print "\n"
end

def display_guessed_word(guessed_word)
    guessed_word.each { |letter| print letter+" " }
    print "\n"
end

def display_guessed_letters(set_of_letters)
    print "Letters guessed: "
    set_of_letters.each { |letter| print letter+" " }
    print "\n"
end

def display_number_of_guesses_left(number_of_guesses)
    puts "You have #{number_of_guesses} incorrect guesses remaining."
end

def display_current_game_state(number_of_incorrect_guesses_left, used_letters, guessed_word)
    display_number_of_guesses_left(number_of_incorrect_guesses_left)
    display_guessed_letters(used_letters)
    display_guessed_word(guessed_word)
end

def display_good_guess_message
    display_green_text("Your guess is correct!")
end

def display_bad_guess_message
    display_red_text("Your guess is wrong!")
end

end