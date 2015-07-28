//
//  Chapter8.swift
//  CrackingCodeInterview
//
//  Created by Andrea Bizzotto on 01/08/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

import Foundation

public class Chapter8 {
    
    
    // Design the data structures for a generic deck of cards. Explain how you would subclass the data structures to implement blackjack.    
    class Card {
        
        enum Color {
            case Black
            case Red
        }
        
        enum Suit : Character {
            case Hearts = "♡"
            case Clubs = "♣"
            case Spades = "♠"
            case Diamonds = "♢"
            
            var color : Color {
                switch (self) {
                case Hearts:   return Color.Red
                case Diamonds: return Color.Red
                case Spades:   return Color.Black
                case Clubs:    return Color.Black
                }
            }
        }
        
        enum Rank : Int {
            case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten
            case Jack, Queen, King, Ace
            struct Values {
                let first: Int, second: Int?
            }
            var values: Values {
                switch self {
                case .Ace:
                    return Values(first: 1, second: 11)
                case .Jack, .Queen, .King:
                    return Values(first: 10, second: nil)
                default:
                    return Values(first: self.rawValue, second: nil)
                }
            }
            
            init(fromInt: Int) {
                switch(fromInt) {
                case 1: self = Ace
                case 2: self = Two
                case 3: self = Three
                case 4: self = Four
                case 5: self = Five
                case 6: self = Six
                case 7: self = Seven
                case 8: self = Eight
                case 9: self = Nine
                case 10: self = Ten
                case 11: self = Jack
                case 12: self = Queen
                case 13: self = King
                default: self = Ace
                }
            }
        }
        
        
        let suit : Suit
        let rank: Rank
        
        init(suit: Suit, rank : Rank) {
            self.suit = suit
            self.rank = rank
        }
        
        var description: String {
            var output = "suit is \(suit.rawValue),"
            output += " value is \(rank.values.first)"
            if let second = rank.values.second {
                output += " or \(second)"
            }
            return output
        }
    }
    
    class Deck {
        
        var cards : [Card]
        
        init() {
            
            cards = Array(count: 52, repeatedValue: Card(suit: Card.Suit.Clubs, rank: Card.Rank.Ace))
            for var i = 1; i <= 13; i++ {
                cards[(i-1)*4]   = Card(suit: Card.Suit.Clubs, rank: Card.Rank(fromInt: i))
                cards[(i-1)*4+1] = Card(suit: Card.Suit.Diamonds, rank: Card.Rank(fromInt: i))
                cards[(i-1)*4+2] = Card(suit: Card.Suit.Hearts, rank: Card.Rank(fromInt: i))
                cards[(i-1)*4+3] = Card(suit: Card.Suit.Spades, rank: Card.Rank(fromInt: i))
            }
            shuffle()
        }
        
        func shuffle() {
            // TODO: Implement
        }
        
        func removeCard() -> Card {
            return cards.removeLast()
        }
        
        
        func showDeck() {
            for card in cards {
                print("\(card.description)")
            }
        }
    }
    
    class BlackJackGame {
        
        let maxScore = 21
        
        var deck : Deck
        var score : Int
        init() {
            deck = Deck()
            score = 0
        }
        
        func popCard() {
            let card = deck.removeCard()
            let firstValue = card.rank.values.first
            if let secondValue = card.rank.values.second {
                if score + secondValue > maxScore {
                    score += firstValue
                }
                else {
                    score += secondValue
                }
            }
            else {
                score += firstValue
            }
            print("New score: \(score)")
            if self.lost {
                print("you lost: \(score)")
            }
        }
        
        var lost : Bool {
            
            return score > maxScore
        }
    }
    
    public init() {
        
        //let deck = Deck()
        //deck.showDeck()
        
        let game = BlackJackGame()
        while !game.lost {
            game.popCard()
        }
        
        //        var card = Card(suit: Card.Suit.Hearts, rank: Card.Rank.Ace)
        //        println("\(card.description)")
        // Done. Missing Hand class and Deck class should not remove cards but just increment the index
    }
    
}

