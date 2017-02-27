//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let str2 = str.components(separatedBy: ",")

let c = str2[3] ?? "sfa"
print(c)