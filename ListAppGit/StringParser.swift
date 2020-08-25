//
//  StringParser.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-08-23.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation

func parseToRootNode(list: String) -> Node {
    var name: String = ""
    let listArray = Array(list)
    var stopPoint: Int = 0
    for i in 1..<listArray.count {
        if listArray[i] == "]" {
            stopPoint = i
            break
        }
        if listArray[i] != "[" {
            name.append(listArray[i])
        } else {
            stopPoint = i
              break
        }
    }
    
    var subString: String = ""
    if (stopPoint + 1) < (list.count - 2) {
        for i in (stopPoint + 1)..<(listArray.count - 2) {
            subString.append(listArray[i])
        }
    }
    
    let n = Node(value: name)
    for node in parseToNodes(listString: subString) {
        n.add(child: node)
    }
    return n
}

func parseToNodes(listString: String) -> [Node] {
    
    var nodes = [Node]()
    var open = 0
    var name: String = ""
    var add = false
    var subString: String = ""

    for i in 0..<listString.count {
        if listString[i] != "[" && add == false {
            name.append(listString[i])
        } else if listString[i] == "[" {
            add = true
            open += 1
        } else if listString[i] == "]" {
            open -= 1
            add = false
        } else if add == true {
            subString.append(listString[i])
        }
        if (listString[i] == "," && open == 0) || i == listString.count - 1 {
            if name != "" && name[name.count - 1] == "," {
                name.removeLast()
            }
            let n = Node(value: name)
            if subString != "" {
                let s = subString
                for node in parseToNodes(listString: s) {
                    n.add(child: node)
                }
            }
            nodes.append(n)
            open = 0
            name = ""
            subString = ""
        }
    }
    return nodes
}

func listsToStringRoot(list: Node) -> String {
    let childrenString = listsToStringChild(list: list.children)
    return "[" + list.value + "[" + childrenString + "]]"
}

func listsToStringChild(list: [Node]) -> String {
    var returnString: String = ""
    
    var i = 1
    for node in list {
        returnString += node.value
        if node.children.count > 0 { returnString += "[" }
        returnString += listsToStringChild(list: node.children)
        if node.children.count > 0 { returnString += "]" }
        if i == list.count { break }
        i += 1
        returnString += ","
    }
    return returnString
}

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}

