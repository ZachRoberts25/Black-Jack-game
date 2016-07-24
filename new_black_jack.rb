require "card_deck"
#If we recreate a black jack game, we can then install our own
#methods of how we play and from there can configure a percentage
#that we can win :)
module PlayersDealers
  def get_hand(card1, card2)
    @first_card = card1
    @second_card = card2
    @cards_in_hand = @first_card, @second_card
  end

  def total
    sum = 0
    cards_in_hand.each {|card| sum += card.value}
    sum
  end
  def show_hand
    # puts "#{self.name} has a #{@first_card.num} of #{@first_card.suit} & #{@second_card.num} of #{@second_card.suit}"
  end
  def bust?(player)
    player.total > 21
  end
end

class CardDeck::Card
  def value
      case @num
	when "Ace" then 11
	when "King", "Queen", "Jack" then 10
      else @num end
  end
end

class Player
  include PlayersDealers
  attr_accessor :name, :amount_of_money, :cards_in_hand
  @@players = Array.new
  def initialize(name, amount_of_money)
    @name = name
    @amount_of_money = amount_of_money
    @@players << self
  end
  #array for each player of all cards in their hand

  def self.show_players
    @@players
  end
  def hit(dealer)
    @cards_in_hand << dealer.deal_card
  end

  def bet(bet_amount)
    @bet_amount = bet_amount
    @amount_of_money -= @bet_amount
  end
  def win_amount
    @amount_of_money += (2 * @bet_amount)
  end
  def win?(dealer)
	if dealer.total == total
		"tie"
	elsif self.total > 21
		false
	elsif dealer.total > 21 || total > dealer.total
		true
	elsif dealer.total > total
		false
	else
		"error"
	end
  end
  def lose
    @amount_of_money
  end
  def push?(dealer)
    total == dealer.total
  end
end


class Dealer
  include PlayersDealers
  attr_accessor :name, :first_card, :second_card, :cards_in_hand
  def initialize
    @deck_of_cards = CardDeck::Deck.new.cards
    @name = "dealer"
  end
  def hit
    cards_in_hand << deal_card
  end
  def deal_cards
    @deck_of_cards.shuffle!
    Player.show_players.each { |player| player.get_hand(deal_card, deal_card) }
    get_hand(deal_card, deal_card)
  end
  def deal_card
    @deck_of_cards.pop
  end
end

class World
	@@statistics = Hash.new(0)
	def self.stats
		@@statistics
	end
  	attr_accessor :dealer, :response, :total
  	def initialize
#		puts "How many players want to play blackjack?"
#		number = STDIN.gets.chomp.to_i
# 		number.times do
#   			print "Player name?\n> "
#  			player_name = STDIN.gets.chomp
#   			print "How much money does #{player_name} have?/n> "
#   			start_amount = STDIN.gets.chomp.to_i
#   			Player.new player_name, start_amount
# 		end
    		@dealer = Dealer.new
  	end
  	def deal
    		@dealer.deal_cards
    		@dealer.total
    		Player.show_players.each {|player| player.show_hand}
#		puts "#{@dealer.name} has #{@dealer.first_card.num} of #{@dealer.first_card.suit}"
  	end
	def prompt_to_hit(player)
#		print "#{player.name}, your total is #{player.total}. Do you (H)it or (S)tay?\n> "
  		@response = STDIN.gets.chomp.downcase
	end
	def update_player_on_hand(player)
#		puts "#{player.name}, your total is #{player.total}"
	end

def hit_or_stay
  #creating an method that should play like me :)
  #All possibilities, Dealer can have 2-11, I can have 4-22
  Player.show_players.each do |player|
    #This STDIN.gets rid of anytime I have 18, 19, 20, 21, or 22 so we gucci
    while player.total < 17
      # always hit if I have under 10, no possible bust here
      player.hit @dealer if player.total < 11
      
      # I have between 11 and 16, and the dealer is showing 7-11 then hit
      player.hit(@dealer) if (player.total > 10 && player.total < 17) && (@dealer.first_card.value < 12 && @dealer.first_card.value > 6)

      # I have 11-15, when dealer is showing 2-6
      break if (player.total > 10 && player.total < 17) && (@dealer.first_card.value < 7 && @dealer.first_card.value > 1)
    end
  end
end



#This is code to play a normal game of black jack
  # Player.show_players.each do |player|
  #   @response = "h"
  #   @response == "h"
  #   while player.total < 22
  #     prompt_to_hit(player)
  #     if @response == "h"
  #       player.hit(@dealer)
  #       update_player_on_hand(player)
  #     elsif @response == "s"
  #       update_player_on_hand(player)
  #       break
  #     end
  #   end
  # end
# end
def dealer_hit
  # puts "Dealer has #{@dealer.total}"
  @dealer.hit until @dealer.total > 16
  # puts "Dealer has #{@dealer.total}"
end
def show_total_dealer
  # puts "#{@dealer.name} has a total of #{@dealer.total}"
end
def determine_winners
	Player.show_players.each do |player|
		outcome = case player.win? @dealer
			when "tie" then :ties
			when "error" then :errors
			when true then :wins
			when false then :losses
		end
		@@statistics[outcome] += 1
  	end
	@@statistics[:games] += 1
end
end
Player.new("zach", 5000)

# Player.new("craig", 5000).bet(5000)
# Player.new("austin", 5000).bet(5000)



100000.times do 
	game1 = World.new
	game1.deal
	game1.hit_or_stay
	game1.dealer_hit
	game1.determine_winners
end
puts "Percent of wins = #{World.stats[:wins].to_f/World.stats[:games] * 100}%"
puts "Percent of ties = #{World.stats[:ties].to_f/World.stats[:games] * 100}%"
puts "Percent of losses = #{World.stats[:losses].to_f/World.stats[:games] * 100}%"
puts "Percent of errors = #{World.stats[:errors].to_f/World.stats[:games] * 100}%"