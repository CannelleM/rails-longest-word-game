require "json"
require "open-uri"

class GamesController < ApplicationController

  def new
    @letters = []
    10.times do
      @letters << (('a'..'z').to_a.sample.capitalize)
    end
  end

  def score
    @score = cookies[:score].to_i || 0
    @game_number = cookies[:game_number].to_i || 0
    @game_number += 1
    word_display = params[:word].upcase
    word_array = params[:word].upcase.split('')
    letters = params[:letters].split(" ")
    if !(word_array - letters).empty?
      @answer = "Your word #{word_display} can't be built out of the original grid! Your score is still #{@score}/#{@game_number}"
    elsif (word_array - letters).empty? && check_word(params[:word]) && word_array.size >= 2
      @score += 1
      @answer = "Congratulations! #{word_display} is a valid english word! Your score is #{@score}/#{@game_number}"
    else
      @answer = "Sorry, #{word_display} is not a valid english word! Your score is still #{@score}/#{@game_number}"
    end
    cookies[:score] = @score
    cookies[:game_number] = @game_number
  end

  def check_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end


end

# We want to handle three scenarios:
# The word can’t be built out of the original grid
# The word is valid according to the grid, but is not a valid English word
# The word is valid according to the grid and is an English word
