require 'open-uri'
require 'json'

class LwgController < ApplicationController
# GRID = (0...15).map { (65 + rand(26)).chr }
  def game
    @start_time = Time.now
    @grid = (0...15).map { (65 + rand(26)).chr }
  end

  def score
    end_time = Time.now
    total_time = (end_time - DateTime.parse(params[:start_time])).round(3)
    calculate_score(params[:grid_string].split(""), params[:attempt], total_time)

    session[:scores] = [] if session[:scores].nil?
    scores = session[:scores]
    scores << @results[:score]
    session[:scores] = scores

    @avg_score = avg_score(scores).round(2)
  end

  def avg_score(scores)
    scores.inject{ |sum, element| sum + element }.to_f / scores.size
  end

  def calculate_score(grid, attempt, time) #(attempt, start_time, end_time)
    if !word_in_grid?(attempt, grid)
      @results = { time: time, score: 0, message: "Your word uses a letter that is not in the grid" }
    elsif word_in_dictionary?(attempt)
      @results = { time: time, score: (attempt.length * 20 / time).round(2), message: "well done" }
    else
      @results = { time: time, score: 0, message: "not an english word" }
    end
  end

  def word_in_grid?(attempt, grid)
    attempt.upcase!
    attempt_ar = attempt.chars.sort.uniq
    attempt_ar.each do |ltr|
      return false if attempt.count(ltr) > grid.count(ltr)
    end
    return true
  end

  def word_in_dictionary?(attempt)
    url = 'https://wagon-dictionary.herokuapp.com/' + attempt.downcase
    wagon_dictionary = open(url).read
    definition = JSON.parse(wagon_dictionary)
    return definition["found"]
  end
end
