class BlackJack
  attr_accessor  :array_of_totals, :awnser, :deck_of_cards, :card_values, :gamblers, :players_and_cards_hash, :dealer_card_total, :player_card_totals
  def create_array_of_deck_of_cards
    deck_of_cards = []
    suits = %w{Spades Hearts Diamonds Clubs}
    ranks = %w{A K Q J 10 9 8 7 6 5 4 3 2}
    ranks.size.times do |i|
      suits.each do |suit|
        deck_of_cards << [ranks[i] , suit]
      end
    end
    @deck_of_cards = deck_of_cards
  end
  def get_card
    card = @deck_of_cards.slice!(rand(@deck_of_cards.length - 1))
  end

  def get_players
    gamblers = []
    puts "How many players are playing?"
    answer = gets.chomp.to_i
    answer.times do |x|
      puts "Name?"
      gamblers << gets.chomp
    end
    @gamblers = gamblers
  end
  # def give_players_money
  #   @gamblers.each do |gambler|
  #     puts "You all start with $10,000"
  def deal_cards_to_players
    players_and_cards_hash = []
    i = 0
    while i < @gamblers.length
      players_and_cards_hash[i] =  {:name => @gamblers[i],
        :first_card => get_card,
        :second_card => get_card
      }
      i += 1
    end
    @players_and_cards_hash = players_and_cards_hash
    #player_and_cards_hash is an array of hashes, where the keys are
    #{:name=>"zach", :first_card=>["A", "Hearts"], :second_card=>["Q", "Clubs"]}
    #example of the hash ^,
  end
  #player_card_totals is an array of hashs, where the keys are the gamblers
  #and the values are the total of the players first 2 cards
  def player_card_totals
    i = 0
    player_card_totals = []
    while i < @gamblers.length
      total_value_of_players_cards = @card_values[@players_and_cards_hash[i][:first_card][0]] + @card_values[@players_and_cards_hash[i][:second_card][0]]
      player_card_totals[i] = {@gamblers[i] => total_value_of_players_cards}
      i += 1
    end
    @player_card_totals = player_card_totals
  end

  def assign_value_to_cards
    card_values = {
      "A" => 11,
      "K" => 10,
      "Q" => 10,
      "J" => 10,
      "10" => 10,
      "9" => 9,
      "8" => 8,
      "7" => 7,
      "6" => 6,
      "5" => 5,
      "4" => 4,
      "3" => 3,
      "2" => 2
    }
    @card_values = card_values
  end

  def display_cards
    i = 0
    while i < @players_and_cards_hash.length
      puts "#{@players_and_cards_hash[i][:name]} is dealt #{@players_and_cards_hash[i][:first_card]}
      , #{@players_and_cards_hash[i][:second_card]}"
      # if  @players_and_cards_hash[i][:first_card][0] == @players_and_cards_hash[i][:second_card][0]
      #   puts "#{@players_and_cards_hash[i][:name]}, would you like to split (Y)es or (N)o?"
      #   awnser = gets.chomp.downcase
      # end
      # if awnser == "y"
      #   split_cards(@players_and_cards_hash[i][:name])
      # end
      #This code works, just need to write split_cards method
      i += 1
    end
  end

  def display_total_for_players
    array_of_totals = []
    i = 0
    while i < @gamblers.length
      puts "#{gamblers[i]}, your total is #{@player_card_totals[i][@gamblers[i]]}"
      array_of_totals << @player_card_totals[i][@gamblers[i]]
      i += 1
    end
    @array_of_totals = array_of_totals
    #array_of_totals is a simple of array of fixnums
  end

  def deal_the_dealer_cards
    dealer_card_total = @card_values[@dealer_face_card[0]] + @card_values[get_card[0]]
    @dealer_card_total = dealer_card_total
  end

  def show_dealer_face_card
    dealer_face_card = get_card
    @dealer_face_card = dealer_face_card
    puts "Dealer has a #{@dealer_face_card}"
  end

  # def split_cards(gambler_name)
  #   player_hand1 = @array_of_totals(@gamblers.index(gambler_name)
  #   player_hand2 = @array_of_totals(@gamblers.index(gambler_name)
  #   puts "Your first hand total is #{player_hand1}"
  #
    #working on it....
  end

  def hit_or_stay
    @gamblers.each do |gambler|
      while @array_of_totals[@gamblers.index(gambler)] < 21
        puts "#{gambler}, would you like to hit or stay"
        awnser = gets.chomp
        if awnser == "hit"
          @array_of_totals[@gamblers.index(gambler)] += @card_values[get_card[0]]
          puts "#{gambler} now has #{@array_of_totals[@gamblers.index(gambler)]}"
        end
        if awnser == "stay"
          puts "#{gambler} stays with #{@array_of_totals[@gamblers.index(gambler)]}"
          break
        end
      end
    end
  end

  def show_dealer_second_card
    puts "The dealer flips his second card"
    puts "The dealer's total is now #{@dealer_card_total}"
  end
  def hit_the_dealer
    return @dealer_card_total if @dealer_card_total > 16
    while @dealer_card_total < 17
      puts "The dealer must hit"
      @dealer_card_total += @card_values[get_card[0]]
      puts "The dealer hits, he now has #{@dealer_card_total}"
    end
  end
  def determine_winners
    @gamblers.each do |gambler|
      if @array_of_totals[@gamblers.index(gambler)] > 21
        puts "#{gambler} Busted"
      elsif @array_of_totals[@gamblers.index(gambler)] > @dealer_card_total
        puts "#{gambler} Wins"
      elsif @array_of_totals[@gamblers.index(gambler)] < @dealer_card_total
        puts "#{gambler} Loses :("
      else
        puts "#{gambler} Ties"
      end
    end
  end
end
