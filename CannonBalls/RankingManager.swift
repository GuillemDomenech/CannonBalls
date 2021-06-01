//
//  RankingManager.swift
//  CannonBalls
//
//  Created by Guillem Domènech Rofín on 01/06/2021.
//

import Foundation

class RankingManager {
    var rank = [String:Int]()
    
    init() {
        retrieveScores()
    }
    
    func addScore(nick: String, score: Int) {
        if score <= rank[nick] ?? Int.min { return }
        rank[nick] = score
        fixScoresDict()
        saveScores()
    }
    
    func fixScoresDict() {
        let rankArr = Array(rank).sorted { $0.1 > $1.1 }
        var resizedArr = [Dictionary<String, Int>.Element]()
        
        let maxScores = 10
        
        let i = rank.count < maxScores ? rank.count : maxScores
        for i in 0...i-1 {
            resizedArr.append(rankArr[i])
        }
        
        rank.removeAll()
        
        for elem in resizedArr {
            rank[elem.key] = elem.value
        }
    }
    
    func saveScores() {
        do {
            let dataToSave = try NSKeyedArchiver.archivedData(withRootObject: rank, requiringSecureCoding: false)
            UserDefaults.standard.set(dataToSave, forKey: "ranking")
            
        } catch {
            print("Couln't save data")
        }
    }
    
    func retrieveScores() {
        do {
            guard let userDefaultsData = UserDefaults.standard.value(forKey: "ranking") as? Data else { return }
            
            guard let retrievedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userDefaultsData) as? [String:Int] else { return }
            rank = retrievedData
            
        } catch {
            print("Couln't retrieve scores")
        }
    }
    
    func printRank() {
        print(rank)
    }
    
    func getRankString() -> String {
        var rankingStr = ""
        (Array(rank).sorted{ $0.1 > $1.1 }).forEach { (rank) in
            rankingStr += rank.key + ": " + String(rank.value) + "\n"
        }
        return rankingStr
    }
}
