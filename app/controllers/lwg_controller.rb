require 'open-uri'
require 'json'

class LwgController < ApplicationController
# GRID = (0...15).map { (65 + rand(26)).chr }
  def game
    @@start_time = Time.now
    @@grid = (0...15).map { (65 + rand(26)).chr }
  end

  helper_method :grid
  def grid
    @@grid
  end

  def score
    end_time = Time.now
    calculate_score(params[:attempt], (end_time - @@start_time).round(3))
  end

  def calculate_score(attempt, time) #(attempt, start_time, end_time)
    if !word_in_grid?(attempt)
      @results = { time: time, score: 0, message: "Your word uses a letter that is not in the grid" }
    elsif word_in_dictionary?(attempt)
      @results = { time: time, score: (attempt.length * 20 / time).round(2), message: "well done" }
    else
      @results = { time: time, score: 0, message: "not an english word" }
    end
  end

  def word_in_grid?(attempt)
    attempt.upcase!
    attempt_ar = attempt.chars.sort.uniq
    attempt_ar.each do |ltr|
      return false if attempt.count(ltr) > @@grid.count(ltr)
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
