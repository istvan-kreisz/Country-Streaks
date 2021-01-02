//
//  CountdownTimer.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/13/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import Foundation

class CountdownTimer : ObservableObject {
    
    private static let duration = 15

    private var timer: Timer?
    private let duration: Int
    @Published var count: Int
    
    static let `default` = CountdownTimer(count: duration)
    
    private init(count: Int) {
        let count = DebugSettings.shared.shortTimer ? 1 : count
        self.duration = count
        self.count = count
    }
    
    func add(time: Int) {
        count += time
    }
    
    func reset() {
        count = duration
    }
    
    func start(completion: @escaping () -> Void) {
        reset()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.count -= 1
            if self?.count == 0 {
                self?.timer?.invalidate()
                completion()
            }
        }
    }
        
    func stop() {
        timer?.invalidate()
    }
}
