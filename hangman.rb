# frozen_string_literal: true

contents = File.open('google-10000-english-no-swears.txt')
word_list = []

contents.each do |word|
  if word.length > 5 && word.length < 12
    word_list << word
  end
end

puts guess_word = word_list.sample
p guessable_word = guess_word.strip.split(//)
p input = Array.new(guessable_word.size, '_')
guess = gets.chomp

if guessable_word.include?(guess)
  replace = guessable_word.map.with_index { |x, i| i if x == guess }
  replace.compact!
  replace.each do |i|
    p replace
    input[i] = guess
  end
end

p input
