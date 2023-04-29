//
//  Observable.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 28/04/23.
//


import Foundation

public final class Observable<T> {
    
    struct Observer<Value> {
        weak var observer: AnyObject?
        let block: (Value) -> Void
    }
    
    private var observers = [Observer<T>]()
    
    public var value: T {
        didSet { notifyObservers() }
    }
    
    public init(_ value: T) {
        self.value = value
    }
    
    public func observe(on observer: AnyObject, observerBlock: @escaping (T) -> Void) {
        observers.append(Observer(observer: observer, block: observerBlock))
        observerBlock(self.value)
    }
    
    public func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    private func notifyObservers() {
        for observer in observers {
            DispatchQueue.main.async { observer.block(self.value) }
        }
    }
}
