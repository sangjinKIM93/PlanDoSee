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

    public init(dueTime: TimeInterval = 1, skipFirst: Bool = false) {
        $text
            .removeDuplicates()
            .debounce(for: .seconds(dueTime), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                if skipFirst && self.isInitialText {
                    self.isInitialText = false
                    return
                }
                self.debouncedText = value
            })
            .store(in: &bag)
    }
}
