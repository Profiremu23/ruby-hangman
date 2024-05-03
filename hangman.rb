# frozen_string_literal: true

## Making sure that JSON is working for our game
require 'json'

### The game class for Hangman
class GameClass
  attr_accessor :guess, :guess_word, :guessable_word, :input, :mistakes, :used_letters

  ## Initializing variables for the game
  def initialize(guess = '', guess_word = '', guessable_word = [], input = [], mistakes = 0, used_letters = [])
    @guess = guess
    @guess_word = guess_word
    @guessable_word = guessable_word
    @input = input
    @mistakes = mistakes
    @used_letters = used_letters
  end

  ## Methods to save and load a Hangman game
  def to_json
    JSON.generate({ guess: @guess, guess_word: @guess_word, guessable_word: @guessable_word, input: @input, mistakes: @mistakes, used_letters: @used_letters })
  end

  def self.from_json(string)
    data = JSON.load(string)
    self.new(data['guess'], data['guess_word'], data['guessable_word'], data['input'], data['mistakes'], data['used_letters'])
  end

  # Generating a save game file
  def save_game
    Dir.mkdir 'saves' if Dir.exist?('saves') == false
    IO.write('saves/latest.json', to_json)
  end

  # Loading a saved game and replacing the old variables with the saved variables from saves/latest.json
  def load_save
    data = GameClass.from_json(File.read('saves/latest.json'))
    @guess = data.guess
    @guess_word = data.guess_word
    @guessable_word = data.guessable_word
    @input = data.input
    @mistakes = data.mistakes
    @used_letters = data.used_letters
    guessing
  end

  ## Hangman game mechanics
  # Determinating the current game state
  def game_state
    if @input.include?('_') == false && @mistakes < 7
      puts "Congratulations! You have sucessfully guessed the word #{@guess_word}!"
    elsif @mistakes == 7 && @input.include?('_') == true
      hangman_state
    else
      guessing
    end
  end

  # Hangman stickman status for displaying the number of mistakes
  def hangman_state
    if @mistakes.zero?
      print "   _____      \n   |/         \n   |          \n   |            \n   |            \n___|___________\n"
    elsif @mistakes == 1
      print "   _____      \n   |/  |      \n   |          \n   |            \n   |            \n___|___________\n"
    elsif @mistakes == 2
      print "   _____      \n   |/  |      \n   |   O      \n   |            \n   |            \n___|___________\n"
    elsif @mistakes == 3
      print "   _____      \n   |/  |      \n   |   O      \n   |   |        \n   |   ^        \n___|___________\n"
    elsif @mistakes == 4
      print "   _____      \n   |/  |      \n   |   O      \n   |  /|        \n   |   ^        \n___|___________\n"
    elsif @mistakes == 5
      print "   _____      \n   |/  |      \n   |   O      \n   |  /|\\      \n   |   ^        \n___|___________\n"
    elsif @mistakes == 6
      print "   _____      \n   |/  |      \n   |   O      \n   |  /|\\      \n   |  /^        \n___|___________\n"
    elsif @mistakes == 7
      print "   _____      \n   |/  |      \n   |   O      \n   |  /|\\      \n   |  /^\\      \n___|___________\n"
      puts "Sorry, you have run out of lives! The solution was: #{@guess_word}"
    else
      puts 'Error! Something must went wrong!'
    end
  end

  # First step for initializing a new Hangman game is to generate a random word to guess
  def generate_guessable
    contents = File.open('google-10000-english-no-swears.txt')
    word_list = []
    contents.each do |word|
      word_list << word if word.length > 5 && word.length < 12
    end
    @guess_word = word_list.sample
  end

  # Second step is to get a playable form of the selected word for Hangman by breaking it up by letters
  def break_guessable
    @guess_word.strip!
    @guessable_word = @guess_word.split(//)
    @input = Array.new(@guessable_word.size, '_')
  end

  # Third step is to start typing letters to fill-in the blank letters!
  def guessing
    puts hangman_state
    p @input
    p @used_letters
    @guess = gets.chomp.downcase
    if @guess.size == 1 && @used_letters.include?(@guess) == false
      @used_letters << @guess
      guess_check
    elsif @guess == 'save'
      puts `clear`
      puts 'Saving the current game state...'
      save_game
    elsif @guess == 'load_save'
      puts `clear`
      puts 'Loading the last saved game state...'
      load_save
    else
      puts `clear`
      puts 'Invalid input! The guess is either has more than one letter or is already entered!'
      guessing
    end
  end

  # Fourth step is to check if the typed letter is included within the word to guess
  def guess_check
    if @guessable_word.include?(@guess)
      replace = @guessable_word.map.with_index { |x, i| i if x == @guess }
      replace.compact!
      replace.each do |i|
        @input[i] = @guess
      end
    else
      @mistakes += 1
    end
    p @input
    puts `clear`
    game_state
  end

  ## Executing the game flow
  def hangman
    puts `clear`
    puts 'You can save your progress by typing "save", you can also load a previous save by typing "load_save"'
    generate_guessable
    break_guessable
    guessing
  end
end

## Running a singular Hangman game
hangman = GameClass.new
hangman.hangman
