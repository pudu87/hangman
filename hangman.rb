require_relative 'graphics.rb'

class Game
  include Graphics
  attr_accessor :counter, :guesses, :word
  
  def initialize
    @counter = 0
    @guesses = []
  end

  def game
    intro
    # load
    select_word
    show_gallow(counter)
    show_word
    until finished?
      # save
      insert_letter
      show_gallow(counter)
      show_word
      show_misses
    end
    outro
  end

  private

  def intro
    puts "\n---WELCOME TO HANGMAN---\n"
  end

  def select_word
    dictionary = File.open('5desk.txt', 'r').readlines
    dictionary.map! { |w| w.strip! }.select! { |w| (5..12).include?(w.size) }
    @word = dictionary.sample.upcase.split('')
  end

  def finished?
    counter == 6 || (word - guesses).empty?
  end

  def insert_letter
    puts "\nChoose a letter:"
    letter = gets.chomp.upcase
    until valid?(letter)
      puts "Invalid input. Try again."
      letter = gets.chomp.upcase
    end
    guesses << letter
    @counter +=1 unless word.include?(letter)
  end

  def valid?(letter)
    letter.match?(/[a-zA-Z]/) && !guesses.include?(letter)
  end

  def show_word
    counter == 6 ?
      word.each { |l| print "#{l} " } :
      word.each { |l| print guesses.include?(l) ? "#{l} " : "_ " }
    puts
  end

  def show_misses
    unless (guesses - word).empty?
      print "Misses: "
      (guesses - word).each { |l| print "#{l} "}
    end
    puts
  end

  def outro
    puts counter == 6 ? "\n---YOU LOSE---\n\n" : "\n---YOU WIN---\n\n"
  end
end

test = Game.new
test.game