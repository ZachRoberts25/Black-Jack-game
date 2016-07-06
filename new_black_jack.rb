#If we recreate a black jack game, we can then install our own
#methods of how we play and from there can configure a percentage
#that we can win :)
module PlayersDealers
  def get_hand(card1, card2)
    @first_card = card1
    @second_card = card2
    @total = @first_card.value + @second_card.value
  end
  def show_hand
    puts "#{self.name} has a #{@first_card.rank} of #{@first_card.suit} & #{@second_card.rank} of #{@second_card.suit}"
  end
  def bust?(player)
    player.total > 21
  end
end

class Card
  attr_accessor :rank, :suit, :deck_of_cards

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
  def value
    Player.show_players.each do |player|
    return 11 if @rank == "A"
    return 10 if @rank == "K" || @rank == "Q" || @rank == "J" || @rank == "10"
    #for 2 though 9 if it equals its self then return that
    i = 2
      while i < 10 do
      return i if @rank == "#{i}"
      i += 1
      end
    end
  end
end
class Deck_of_cards
  attr_accessor :deck_of_cards, :array
  def initialize
    @array = []
    suits = %w{Spades Hearts Diamonds Clubs}
    ranks = %w{A K Q J 10 9 8 7 6 5 4 3 2}
    ranks.size.times do |i|
      suits.each do |suit|
        @array << Card.new(ranks[i] , suit)
        @array
      end
    end
  end
end
class Player
  include PlayersDealers
  attr_accessor :name, :amount_of_money, :total
  @@players = []
  def initialize(name, amount_of_money)
    @name = name
    @amount_of_money = amount_of_money
    @@players << self
  end

  def self.show_players
    @@players
  end
  def hit(dealer)
    self.total += dealer.deal_card.value
    #whichever player were on.total += #whatever card the dealer deals
  end

  def bet(bet_amount)
    @bet_amount = bet_amount
    @amount_of_money -= @bet_amount
  end
  def win
    @amount_of_money += (2 * @bet_amount)
  end
  def win?(dealer)
    self.total > dealer.total
  end
  def lose
    @amount_of_money
  end
  def push?(dealer)
    self.total == dealer.total
  end
end


class Dealer
  include PlayersDealers
  attr_accessor :name, :total, :first_card, :second_card
  def initialize(deck_of_cards, name)
    @deck_of_cards = deck_of_cards
    @name = name
  end
  def hit
    self.total += self.deal_card.value
  end
  def deal_cards
    @deck_of_cards.shuffle!
    Player.show_players.each do |player|
      player.get_hand(deal_card, deal_card)
    end
    self.get_hand(deal_card, deal_card)
  end
  def deal_card
    @deck_of_cards.pop
  end
end

class World
  attr_accessor :dealer, :response, :total
  def initialize
    #   puts "How many players want to play blackjack?"
    #   number = gets.chomp.to_i
    #   number.times {
    #   puts "player name?"
    #   player_name = gets.chomp
    #   puts "How much money does #{player_name} have?"
    #   start_amount = gets.chomp.to_i
    #  Player.new(player_name, start_amount)
    new_deck = Deck_of_cards.new.array
    @dealer = Dealer.new(new_deck, "dealer")
  end
  def deal
    @dealer.deal_cards
    p @dealer.total
    # Player.show_players.each {|player| player.show_hand}
    # puts "#{@dealer.name} has #{@dealer.first_card.rank} of #{@dealer.first_card.suit}"
  end
  # def prompt_to_hit(player)
  #   puts "#{player.name} you total is #{player.total}, do you (H)it or (S)tay?"
  #   @response = gets.chomp.downcase
  # end
  # def update_player_on_hand(player)
  #   puts "#{player.name} you total is #{player.total}"
  # end
#dealer should be able to do this too
  def hit_or_stay
    Player.show_players.each do |player|
      # @response = "h"
       #@response == "h"
        while player.total < 16 && player.total < 22
        # prompt_to_hit(player)
        # if @response == "h"
          player.hit(@dealer)
        #     update_player_on_hand(player)
        # elsif @response == "s"
        #   update_player_on_hand(player)
        # end
      end
    end
  end
  def dealer_hit
    # puts "Dealer has #{@dealer.total}"
    until @dealer.total > 16 do
      @dealer.hit
    end
    # puts "Dealer has #{@dealer.total}"
  end
  def show_total_dealer
    puts "#{@dealer.name} has a total of #{@dealer.total}"
  end
  def determine_winners
    Player.show_players.each do |player|
      player.win?(@dealer) ? player.win : player.lose
    end
  end
end


Player.new("zach", 5000).bet(5000)
Player.new("craig", 5000).bet(5000)
Player.new("austin", 5000).bet(5000)

game1 = World.new
game1.deal
game1.hit_or_stay
game1.dealer_hit
game1.show_total_dealer
game1.determine_winners
Player.show_players.each{|player| p player.amount_of_money}







# class BlackJack
#   attr_accessor  :array_of_totals, :awnser, :deck_of_cards, :card_values, :gamblers, :players_and_cards_hash, :dealer_card_total, :player_card_totals
#   def create_array_of_deck_of_cards
#     deck_of_cards = []
#     suits = %w{Spades Hearts Diamonds Clubs}
#     ranks = %w{A K Q J 10 9 8 7 6 5 4 3 2}
#     ranks.size.times do |i|
#       suits.each do |suit|
#         deck_of_cards << [ranks[i] , suit]
#       end
#     end
#     @deck_of_cards = deck_of_cards
#   end
#   def get_card
#     card = @deck_of_cards.slice!(rand(@deck_of_cards.length - 1))
#   end
#
#   def get_players
#     gamblers = []
#     puts "How many players are playing?"
#     answer = gets.chomp.to_i
#     answer.times do |x|
#       puts "Name?"
#       gamblers << gets.chomp
#     end
#     @gamblers = gamblers
#   end
#   # def give_players_money
#   #   @gamblers.each do |gambler|
#   #     puts "You all start with $10,000"
#   def deal_cards_to_players
#     players_and_cards_hash = []
#     i = 0
#     while i < @gamblers.length
#       players_and_cards_hash[i] =  {:name => @gamblers[i],
#         :first_card => get_card,
#         :second_card => get_card
#       }
#       i += 1
#     end
#     @players_and_cards_hash = players_and_cards_hash
#     #player_and_cards_hash is an array of hashes, where the keys are
#     #{:name=>"zach", :first_card=>["A", "Hearts"], :second_card=>["Q", "Clubs"]}
#     #example of the hash ^,
#   end
#   #player_card_totals is an array of hashs, where the keys are the gamblers
#   #and the values are the total of the players first 2 cards
#   def player_card_totals
#     i = 0
#     player_card_totals = []
#     while i < @gamblers.length
#       total_value_of_players_cards = @card_values[@players_and_cards_hash[i][:first_card][0]] + @card_values[@players_and_cards_hash[i][:second_card][0]]
#       player_card_totals[i] = {@gamblers[i] => total_value_of_players_cards}
#       i += 1
#     end
#     @player_card_totals = player_card_totals
#   end
#
#   def assign_value_to_cards
#     card_values = {
#       "A" => 11,
#       "K" => 10,
#       "Q" => 10,
#       "J" => 10,
#       "10" => 10,
#       "9" => 9,
#       "8" => 8,
#       "7" => 7,
#       "6" => 6,
#       "5" => 5,
#       "4" => 4,
#       "3" => 3,
#       "2" => 2
#     }
#     @card_values = card_values
#   end
#
#   def display_cards
#     i = 0
#     while i < @players_and_cards_hash.length
#       puts "#{@players_and_cards_hash[i][:name]} is dealt #{@players_and_cards_hash[i][:first_card]}
#       , #{@players_and_cards_hash[i][:second_card]}"
#       # if  @players_and_cards_hash[i][:first_card][0] == @players_and_cards_hash[i][:second_card][0]
#       #   puts "#{@players_and_cards_hash[i][:name]}, would you like to split (Y)es or (N)o?"
#       #   awnser = gets.chomp.downcase
#       # end
#       # if awnser == "y"
#       #   split_cards(@players_and_cards_hash[i][:name])
#       # end
#       #This code works, just need to write split_cards method
#       i += 1
#     end
#   end
#
#   def display_total_for_players
#     array_of_totals = []
#     i = 0
#     while i < @gamblers.length
#       puts "#{gamblers[i]}, your total is #{@player_card_totals[i][@gamblers[i]]}"
#       array_of_totals << @player_card_totals[i][@gamblers[i]]
#       i += 1
#     end
#     @array_of_totals = array_of_totals
#     #array_of_totals is a simple of array of fixnums
#   end
#
#   def deal_the_dealer_cards
#     dealer_card_total = @card_values[@dealer_face_card[0]] + @card_values[get_card[0]]
#     @dealer_card_total = dealer_card_total
#   end
#
#   def show_dealer_face_card
#     dealer_face_card = get_card
#     @dealer_face_card = dealer_face_card
#     puts "Dealer has a #{@dealer_face_card}"
#   end
#
#   # def split_cards(gambler_name)
#   #   player_hand1 = @array_of_totals(@gamblers.index(gambler_name)
#   #   player_hand2 = @array_of_totals(@gamblers.index(gambler_name)
#   #   puts "Your first hand total is #{player_hand1}"
#   #
#     #working on it....
#   end
#
#   def hit_or_stay
#     @gamblers.each do |gambler|
#       while @array_of_totals[@gamblers.index(gambler)] < 21
#         puts "#{gambler}, would you like to hit or stay"
#         awnser = gets.chomp
#         if awnser == "hit"
#           @array_of_totals[@gamblers.index(gambler)] += @card_values[get_card[0]]
#           puts "#{gambler} now has #{@array_of_totals[@gamblers.index(gambler)]}"
#         end
#         if awnser == "stay"
#           puts "#{gambler} stays with #{@array_of_totals[@gamblers.index(gambler)]}"
#           break
#         end
#       end
#     end
#   end
#
#   def show_dealer_second_card
#     puts "The dealer flips his second card"
#     puts "The dealer's total is now #{@dealer_card_total}"
#   end
#   def hit_the_dealer
#     return @dealer_card_total if @dealer_card_total > 16
#     while @dealer_card_total < 17
#       puts "The dealer must hit"
#       @dealer_card_total += @card_values[get_card[0]]
#       puts "The dealer hits, he now has #{@dealer_card_total}"
#     end
#   end
#   def determine_winners
#     @gamblers.each do |gambler|
#       if @array_of_totals[@gamblers.index(gambler)] > 21
#         puts "#{gambler} Busted"
#       elsif @array_of_totals[@gamblers.index(gambler)] > @dealer_card_total
#         puts "#{gambler} Wins"
#       elsif @array_of_totals[@gamblers.index(gambler)] < @dealer_card_total
#         puts "#{gambler} Loses :("
#       else
#         puts "#{gambler} Ties"
#       end
#     end
#   end
# end
