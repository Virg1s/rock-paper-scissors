class ThrowController < ApplicationController
  require 'rest_client'

  LINKS = { 'development' => 'https://private-anon-bfe05106bd-curbrockpaperscissors.apiary-mock.com/rps-stage/throw',
            'staging' => 'https://private-anon-bfe05106bd-curbrockpaperscissors.apiary-mock.com/rps-stage/throw',
            'production' => 'https://5eddt4q9dk.execute-api.us-east-1.amazonaws.com/rps-stage/throw' }.freeze
  RULES = { 'rock' => ['scissors'], 'paper' => ['rock'], 'scissors' => ['paper'] }.freeze

  ## Rules can be modified to include additional signs by adding additional k:v pairs, where k is new sign and v is array of signs weaker then the new sign
  ## For example uncomment the following line to include hammer:
  #RULES = { 'rock' => ['scissors'], 'paper' => ['rock'], 'scissors' => ['paper'], 'hammer' => ['rock', 'scissors'] }.freeze

  def index
    @bets = RULES.keys

    @game_name = @bets.map(&:upcase).join('-')

    @rule_description = RULES.map { |key, value| "- #{key.camelize} beats #{value.join(', ')}" }
  end

  def result
    @heading, @message = outcome(user_choice: params[:throw], server_choice: get_server_choice)
  end

  def crub_busy
  end

  private

  def outcome(user_choice:, server_choice:)
    choices = "You chose #{user_choice} and Crub chose #{server_choice}"

    if user_choice == server_choice
      return ['Draw!', "Both you and Crub chose #{user_choice}"]
    elsif RULES[user_choice].include? server_choice
      return ['You won!', choices]
    else
      return ['You lost!', choices]
    end
  end

  def get_server_choice
    begin
      response = RestClient.get LINKS[Rails.env]
      
      result = JSON.parse response
    rescue
      redirect_to crub_busy_path
    end

    return if result.nil?

    status_code_good = result['statusCode'].is_a?(Integer) && result['statusCode'].between?(200, 299)

    body_good = RULES.keys.include? result['body'] 

    redirect_to crub_busy_path unless status_code_good && body_good

    result['body']
  end
end
