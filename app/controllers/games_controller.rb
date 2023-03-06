require 'open-uri'
require 'json'

class GamesController < ApplicationController
  # display a new random grid and a form
  def new
    @grid = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  # form will be submitted (with POST) to the score action
  def score
    @guess = params[:guess]
    @result = compute_score(params[:guess], params[:grid])
  end

  private

  def compute_score(guess, grid)
    return "That is not an English word" if english_word?(guess) == false
    return "There are letters not in the grid" if included?(guess.upcase, grid) == false

    if english_word?(guess) && included?(guess.upcase, grid)
      return "Well done!"
    end
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(guess)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{guess}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
