//: Playground - noun: a place where people can play

import UIKit

extension Array where Element: Comparable {
    func countUniques() -> Int {
        let sorted0 = sorted(by: <)
        let initial: (Element?, Int) = (.none, 0)
        let reduced = sorted0.reduce(initial) { ($1, $0.0 == $1 ? $0.1 : $0.1 + 1) }
        return reduced.1
    }
}

["a","b","b","1","2"].countUniques()


struct Pizza {
    let ingredients: [String]
}
protocol Pizzeria {
    func makePizza(ingredients: [String]) -> Pizza
//    func makeMargherita() -> Pizza
}
extension Pizzeria {
    func makeMargherita() -> Pizza {
        return makePizza(ingredients: ["tomato", "mozzarella"])
    }
}

struct Lombardis: Pizzeria {
    func makePizza(ingredients: [String]) -> Pizza {
        return Pizza(ingredients: ingredients)
    }
    func makeMargherita() -> Pizza {
        return makePizza(ingredients: ["tomato", "basil", "mozzarella"])
    }
}

let lombardis1: Pizzeria = Lombardis()
let lombardis2: Lombardis = Lombardis()
lombardis1.makeMargherita()
lombardis2.makeMargherita()