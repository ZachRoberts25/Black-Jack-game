#If we recreate a black jack game, we can then install our own
#methods of how we play and from there can configure a percentage
#that we can win :)
module PlayersDealers

  def get_hand(card1, card2)
    @first_card = card1
    @second_card = card2
    @cards_in_hand = []
    @cards_in_hand << @first_card
    @cards_in_hand << @second_card
    self.total
  end
  def calc_total
    @total = 0
    self.cards_in_hand.each{|card| @total += card.value}
    if @total > 21
      self.cards_in_hand.each do |card|
        # p self.name, card
        if card.rank == "A"
          card.rank = "A1"
          card.value = 1
          @total = 0
          self.cards_in_hand.each{|card| @total += card.value}
          break
        end
      end
    end
  end
  def show_hand
    self.cards_in_hand.each do |card|
      # puts "#{self.name} has a #{card.rank + card.suit}"
    end

  end
  def bust?(player)
    player.total > 21
  end
end

class Card
  attr_accessor :rank, :value, :suit, :deck_of_cards
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @value = value
  end

  def value
    Player.show_players.each do |player|
      return 11 if @rank == "A"
      return 10 if @rank == "K" || @rank == "Q" || @rank == "J" || @rank == "10"
      return 1 if @rank == "A1"
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
  attr_accessor :name, :amount_of_money, :cards_in_hand, :total, :bet_amount
  @@players = []
  def initialize(name, amount_of_money)
    @name = name
    @amount_of_money = amount_of_money
    @@players << self
  end
  # #array for each player of all cards in their hand
  # def split
  #
  # end
  # def double_down(dealer)
  #   self.hit(dealer)
  #   self.bet_amount += self.bet_amount
  #
  # end

  def self.show_players
    @@players
  end
  def hit(dealer)
    self.cards_in_hand << dealer.deal_card
    self.calc_total
  end

  def bet(bet_amount)
    @bet_amount = bet_amount
    @amount_of_money -= @bet_amount
  end
  def win
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
    self.total == dealer.total
  end
end


class Dealer
  include PlayersDealers
  attr_accessor :name, :first_card, :second_card, :cards_in_hand, :total
  def initialize(deck_of_cards, name)
    @deck_of_cards = deck_of_cards
    @name = name
  end
  def hit
    self.cards_in_hand << self.deal_card
    self.calc_total
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
  @@statistics = Hash.new(0)

  attr_accessor :dealer, :response, :total
  def initialize
    # puts "How many players want to play blackjack?"
    # number = gets.chomp.to_i
    # number.times {
    #   puts "player name?"
    #   player_name = gets.chomp
    #   puts "How much money does #{player_name} have?"
    #   start_amount = gets.chomp.to_i
    #   Player.new(player_name, start_amount)
    # }
    new_deck = Deck_of_cards.new.array
    @dealer = Dealer.new(new_deck, "dealer")

  end
  def self.stats
    @@statistics
  end
  def deal
    @dealer.deal_cards
    @dealer.total
    # Player.show_players.each {|player| player.show_hand}
    # puts "#{@dealer.name} has #{@dealer.first_card.rank} of #{@dealer.first_card.suit}"
  end
  # def prompt_to_hit(player)
  #   puts "#{player.name} you total is #{player.total}, do you (H)it or (S)tay?"
  #   @response = gets.chomp.downcase
  # end
  # def update_player_on_hand(player)
  #   puts "#{player.name} your total is #{player.total} and your cards are #{player.cards_in_hand}"
  # end

  def hit_or_stay
    #creating an method that should play like me :)
    #All possibilities, Dealer can have 2-11, I can have 4-22

    Player.show_players.each do |player|
      # This gets rid of anytime I have 18, 19, 20, 21, or 22 so we gucci
      player.calc_total
      while player.total < 17
        #always hit if I have under 10, no possible bust here
        if player.total < 11
          player.hit(@dealer)
        end
        #I have between 11 and 16, and the dealer is showing 7-11 then hit
        if (player.total > 10 && player.total < 17) && (@dealer.first_card.value < 12 && @dealer.first_card.value > 6)
          player.hit(@dealer)
        end
        #I have 11-15, when dealer is showing 2-6
        break  if (player.total > 10 && player.total < 17) && (@dealer.first_card.value < 7 && @dealer.first_card.value > 1)

      end
    end
  end




#This is code to play a normal game of black jack
#   Player.show_players.each do |player|
#     @response = "h"
#     @response == "h"
#     player.calc_total
#     @dealer.calc_total
#     while player.total < 21
#       prompt_to_hit(player)
#       if @response == "h"
#         player.hit(@dealer)
#         update_player_on_hand(player)
#       elsif @response == "s"
#         update_player_on_hand(player)
#         break
#       elsif @resonse == "d"
#         player.double_down
#         update_player_on_hand
#         break
#       end
#     end
#   end
# end
def dealer_hit
  # puts "Dealer has #{@dealer.total}"
  @dealer.calc_total
  until @dealer.total > 16 do
    @dealer.hit
  end
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

zach = Player.new("zach", 5000)

# Player.new("craig", 5000).bet(5000)
# Player.new("austin", 5000).bet(5000)
# game1 = World.new
# game1.deal
# zach.show_hand
# game1.hit_or_stay
# zach.show_hand
# game1.dealer_hit


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
