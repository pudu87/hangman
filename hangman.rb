require 'yaml'
require_relative 'graphics.rb'

class Game
  include Graphics
  attr_accessor :counter, :guesses, :word, :saves, :status
  
  def initialize
    @counter = 0
    @guesses = []
  end

  def game
    intro
    select_word
    load
    show_gallow(counter)
    show_word
    show_misses
    until finished?
      insert_letter
      show_gallow(counter)
      show_word
      show_misses
    end
    outro
  end

  private

  def intro
    puts "\n---WELCOME TO HANGMAN---\n\n"
  end

  def select_word
    dictionary = File.open('5desk.txt', 'r').readlines
    dictionary.map!(&:strip!).select! { |w| (5..12).include?(w.size) }
    @word = dictionary.sample.upcase.split('')
  end

  def load
    show_saves
    puts "---Insert file# to LOAD---Or any other key to CONTINUE---"
    file_nr = gets.chomp.to_i
    execute_load(file_nr) if saves.include?(file_nr)
  end

  def show_saves
    print 'File list: '
    get_saves
    saves.empty? ? (print "No files available.") : saves.each { |s| print "#{s}   " }
    puts
  end

  def get_saves
    @saves = []
    saved_files = Dir.entries('saves').select { |f| !File.directory? f }
    saved_files.each { |s| saves << s.split('.')[0].to_i }
    saves.sort!
  end

  def execute_load(file_nr)
    @status = YAML::load(File.read("saves/#{file_nr}.txt"))
    @counter, @guesses, @word = status[:counter], status[:guesses], status[:word]
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

  def finished?
    counter == 6 || (word - guesses).empty?
  end

  def insert_letter
    letter = ''
    puts "\nChoose a letter or type 'save':"
    until valid_letter?(letter)
      letter = gets.chomp.upcase
      if letter == 'SAVE'
        save
      elsif !valid_letter?(letter)
        puts "Invalid input. Try again."
      end
    end
    guesses << letter
    @counter +=1 unless word.include?(letter)
  end

  def valid_letter?(letter)
    letter.match?(/^[a-zA-Z]{1}$/) && !guesses.include?(letter)
  end

  def save
    get_saves
    file_nr = get_file_nr
    @status = { counter: counter, guesses: guesses, word: word }
    File.open("saves/#{file_nr}.txt", 'w') { |f| f.write(YAML::dump(status)) }
    puts "Game saved as '#{file_nr}.txt'---Choose a letter:"
  end

  def get_file_nr
    file_nr = 1
    while saves.include?(file_nr)
      file_nr += 1
    end
    return file_nr
  end

  def outro
    puts counter == 6 ? "\n---YOU LOSE---\n\n" : "\n---YOU WIN---\n\n"
  end
end

test = Game.new
test.game