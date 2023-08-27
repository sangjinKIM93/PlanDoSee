//
//  DebounceObject.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/25.
//

import Combine
import Foundation

public final class DebounceObject: ObservableObject {
    @Published var text: String = ""
    @Published var debouncedText: String = ""
    @Published var isInitialText = true
    private var bag = Set<AnyCancellable>()

    public init(dueTime: TimeInterval = 0.8) {
        $text
            .removeDuplicates()
            .filter { [weak self] _ in
                guard let self = self else { return false }
                if self.isInitialText {
                    self.isInitialText = false
                    return false
                } else {
                    return true
                }
            }
            .debounce(for: .seconds(dueTime), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.debouncedText = value
            })
            .store(in: &bag)
    }
}
