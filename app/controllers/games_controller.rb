require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10).join(' ')
  end

  def score
    @word = params[:word]
    @letters = params[:grid].split(' ')
    if !valid_word?
      return "Sorry but #{@word} does not seem to be a valid English word..."
    elsif !in_grid?
      return "Sorry but #{@word} can't be built out of #{@letters}"
    else
      @score = generate_score
    end
  end

  def in_grid?
    @word.chars.all? { |letter| @word.count(letter) <= @letters.count(letter) }
  end

  def valid_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    response = open(url).read
    dictionary = JSON.parse(response)

    dictionary['found']
  end

  def generate_score
    100 + @word.length
  end
end
