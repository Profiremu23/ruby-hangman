contents = File.open('google-10000-english-no-swears.txt')
word_list = []

contents.each do |word|
  if word.length > 4 && word.length < 13
    word_list << word
  end
end
puts guess_word = word_list.sample
puts guessable_word = guess_word.strip.split(//)
puts guessable_word.class