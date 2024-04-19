# frozen_string_literal: true

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

  def game_state
    if @input.include?('_') == false
      puts "Congratulations! You have sucessfully guessed the word #{@guess_word}!"
    elsif @mistakes == 7
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
    @guessable_word = @guess_word.strip.split(//)
    @input = Array.new(@guessable_word.size, '_')
  end

  def guessing
    puts hangman_state
    p @input
    p @used_letters
    @guess = gets.chomp.downcase
    @used_letters << @guess
    guess_check
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
    game_state
  end

  def hangman
    generate_guessable
    break_guessable
    guessing
    guess_check
  end
end

# Running the game
hangman = GameClass.new
hangman.hangman
