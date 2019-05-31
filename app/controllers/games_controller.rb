require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    (1..10).each { |_num| @letters << rand(65..90).chr }
  end

  def score
    # raise
    end_time = Time.now
    start_time = params[:start_time]
    @guess = params[:guess]
    @letters = params[:letters].split(' ')
    @message = ''
    @score = 0
    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    json = JSON.parse(open(url).read)
    @message = 'not an english word' if json['found'] == false
    if (in_grid(@letters, @guess) == true) && (json['found'] == true)
      @message = "Well done! '#{@guess}' is a great english word."
      @score = (@guess.length * 10) / (end_time.to_i - start_time.to_i)
    end
    @message = "Word '#{@guess}' can't be built with #{@letters.join('-')}" if
          (json['found'] == true) &&
          (in_grid(@letters, @guess) == false)
    if session.key?(:score)
      session[:score] += @score
    else
      session[:score] = @score
    end
  end

  def in_grid(grid, word)
    tgrid = grid.clone
    word.chars.each do |char|
      if tgrid.include?(char.upcase)
        tgrid.delete_at(tgrid.find_index(char.upcase))
      else
        return false
      end
    end
    return true
  end
end
