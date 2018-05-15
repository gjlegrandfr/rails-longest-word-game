require 'json';
require 'open-uri';

class GamesController < ApplicationController

  def new
    @letters = generate_grid(10);
  end

  def score
    @score ||= session[:score] || 0;
    letters = params[:letters].split(//)
    play = params[:play].upcase
    if !check_in_grid(play, letters)
      @message = "Sorry but <strong>#{play}</strong> can't be built out of #{letters.join(",")}".html_safe
    else
      url = "https://wagon-dictionary.herokuapp.com/#{play}"
      json = JSON.parse(open(url, &:read));
      if json["found"]
        @message = "<strong>Congratulations!</strong> #{play} is a valid English word!".html_safe
        @score += play.length
        session[:score] = @score
      else
        @message = "Sorry but <strong>#{play}</strong> does not seem to be a valid English word...".html_safe
      end
    end
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    ret = []
    grid_size.times.each do
      ret << ("A".."Z").to_a.sample
    end
    return ret
  end

  def check_in_grid(attempt, grid)
    grid_copy = grid[0..-1]
    attempt.upcase.split(//).each do |letter|
      if grid_copy.include?(letter)
        grid_copy.delete(letter)
      else
        return false
      end
    end
    return true
  end
end
