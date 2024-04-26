# frozen_string_literal: true

require 'json'

# The game class for Hangman
class GameClass
  def initialize
    @contents = File.open('google-10000-english-no-swears.txt')
    @guess = ''
    @guess_word = ''
    @guessable_word = ''
    @input = []
    @mistakes = 0
    @used_letters = []
    @word_list = []
  end

  def to_json
    JSON.dump ({
      :guess_word => @guess_word,
      :input => @input,
      :mistakes => @mistakes,
      :used_letters => @used_letters
    })
  end

  def from_json(string)
    data = JSON.load string
    self.new(data['guess_word'], data['input'], data['mistakes'], data['used_letters'])
  end

  def saving
    Dir.mkdir 'saves' if Dir.exist?('saves') == false
    Dir.chdir 'saves'
    f = File.new('latest.json', 'w')
    f << to_json
    f.close
  end

  def loading
    Dir.chdir 'saves'
    f = File.new('latest.json', 'w')
    from_json(f)
    f.close
  end

  def game_state
    if @input.include?('_') == false && @mistakes < 7
      puts "Congratulations! You have sucessfully guessed the word #{@guess_word}!"
    elsif @mistakes == 7 && @input.include?('_') == true
      hangman_state
    else
      guessing
    end
  end

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

  def generate_guessable
    @contents.each do |word|
      @word_list << word if word.length > 5 && word.length < 12
    end
  end

  def break_guessable
    @guess_word = @word_list.sample
    @guess_word.strip!
    @guessable_word = @guess_word.split(//)
    @input = Array.new(@guessable_word.size, '_')
  end

  def guessing
    puts hangman_state
    p @input
    p @used_letters
    @guess = gets.chomp.downcase
    if @guess.size == 1 && @used_letters.include?(@guess) == false
      @used_letters << @guess
      guess_check
    elsif @guess == 'save'
      puts 'Saving the current game state...'
      saving
    elsif @guess == 'load_save'
      puts 'Loading the last saved game state...'
      loading
    else
      puts 'Invalid input! The guess is either already given or too long!'
      guessing
    end
  end

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

  def hangman
    puts `clear`
    puts 'You can save your progress by typing "save", you can also load a previous save by typing "load_save"'
    generate_guessable
    break_guessable
    guessing
  end
end

# Running the game
hangman = GameClass.new
hangman.hangman
