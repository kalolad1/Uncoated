//
//  Genre.swift
//  Social-Feedback-App
//
//  Created by Darshan Kalola on 8/6/17.
//  Copyright © 2017 Darshan Kalola. All rights reserved.
//

import Foundation

public struct MessageConstants {
    
    // All genres keywords
    private let basicGenres = ["Generosity", "Courage", "Judgment"]
    private let workGenres = ["Leadership", "Intelligence", "Cooperation"]
    
    // All specific message keywords
    let allBasicGenreMessage: [String: [String]]  = [
        "Generosity" : ["I feel that you could give more to others—your time, especially. After all, you manage your time well!",
        "Sometimes I feel that you could be more generous with your money. Though it may be hard, at the end of the day, materials aren't what give us true satisfaction in life!", "Hospitality is one of the nicest attributes of a person. Lately, I haven't felt that you have been the most hospitable to others."],
        
        "Courage" : ["You have so much potential! Sometimes I've noticed you shy away from chasing your goals or dreams. Go for it!", "I think that failure brings you down in a way that is too harsh. Remember, all successful people, in some way or another, have experienced failure.", "Voice what you think needs to be said. Your opinion matters!"],
        
        "Judgment" : ["Every individual is great in their own way. I know you understand that, but sometimes I feel that you are too harsh on me for being me.", "Being normal isn't real. In reality, there is no normal, and no reason to obide entirely by the rules dictated to us by society.", "Others aren't perfect. Flaws can be listed forever. So, let's try to focus on the positives of people!"],
        
        "Kindness" : ["Kindness is one of the greatest virtues, especially when kept in the face of everyone. Please do your best to be kind!", "Sometimes, the subtle manner of your speech and body language are too harsh. Try to put yourself in the shoes of who you are interacting with. Everyone enjoys being treated with respect.", "Be kind to those who are in a more disadvantaged position than you. This represents true character."],
        
        "Ego" : ["Confidence is key, but arrogance is not. Try thinking about the fine line between both", "Confidence isn't the belief you are better than others, but the belief that you are better than who you were in the past.", "Don't believe you don't matter - you are an individual, and there is no one in the world like you."],
        
        "Work ethic" : ["You have so much hidden talent and potential! Work a little harder and you will accomplish amazing things."],
        
        "Awareness" : ["Be mindful of every moment you have. Try not to focus on next week's plans when today's haven't even unfolded.", "I've noticed that sometimes you may be distracted when interacting with others. The greatest gift you can give is that of undivided attention."],
        
        "Patience" : ["Sometimes you are too eager for things to happen! Go with the flow.", "All great things come with time."]
    ]
}
