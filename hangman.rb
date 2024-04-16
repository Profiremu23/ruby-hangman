# frozen_string_literal: true

# The game class for Hangman
class GameClass
  def initialize
    @contents = File.open('google-10000-english-no-swears.txt')
    @guess = ''
    @guessable_word = ''
    @input = []
    @mistakes = 0
    @used_letters = []
    @word_list = []
  end

  def generate_guessable
    @contents.each do |word|
      @word_list << word if word.length > 5 && word.length < 12
    end
  end

  def break_guessable
    puts guess_word = @word_list.sample
    p @guessable_word = guess_word.strip.split(//)
    p @input = Array.new(@guessable_word.size, '_')
    @guess = gets.chomp
    @used_letters << @guess
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
    p @used_letters
    p @mistakes
  end

  def hangman
    generate_guessable
    break_guessable
    guess_check
  end
end

# Running the game
hangman = GameClass.new
hangman.hangman
