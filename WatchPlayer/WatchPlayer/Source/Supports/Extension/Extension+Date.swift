//
//  Extension+Date.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/8/24.
//

import Foundation

extension Date {
    static func getCurrentDateString(
        _ outputFormat: String = "yyyy.MM.dd HH:mm:ss"
    ) -> String {
        let currentDate = self.now
        
        // 출력 형식 지정
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = outputFormat

        // 변환된 날짜를 원하는 형식으로 변환
        let formattedDateString = outputDateFormatter.string(from: currentDate)
        
        return formattedDateString
    }
    
    func getDateString(
        _ outputFormat: String = "yyyy.MM.dd HH:mm:ss"
    ) -> String {
        // 출력 형식 지정
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = outputFormat

        // 변환된 날짜를 원하는 형식으로 변환
        let formattedDateString = outputDateFormatter.string(from: self)
        
        return formattedDateString
    }
}
