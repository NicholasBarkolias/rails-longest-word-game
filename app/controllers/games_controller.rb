# frozen_string_literal: true

# Countdown game controller
class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    @letters = []
    10.times { @letters << rand(65..89).chr }
  end

  def score
    @user_letters = params[:letters].upcase
    @user_word = params[:word].upcase
    @win = if included?(@user_word, @user_letters) && api(@user_word)
             "You won and your score is #{compute_score(params[:word])}"
           elsif api(@user_word) == false
             'Your word is not a valid english word'
           else
             "Sorry but #{params[:word].upcase} cant be built from #{params[:letters].upcase}"
           end
  end

  def api(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = URI.open(url).read
    word_check = JSON.parse(user_serialized)
    @real_word = word_check['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(word)
    letter = word.split('')
    @score = 0
    letter.each do
      @score += 1
    end
    @score
  end
end
