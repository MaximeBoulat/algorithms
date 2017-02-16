//
//  AlgorithmManager.swift
//  Algorithms
//
//  Created by Maxime Boulat on 2/14/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

import UIKit

class AlgorithmManagerSwift: NSObject {

	static func pushZeroesWith(array: [Int]) {
		
		var arrayCopy = array;
		
		var length = 0
		
		for i in (1...array.count - 1).reversed() {
			let value = array[i]
			
			if value == 0 {
				length = length + 1
			}
			else if length != 0 {
				let start = i + 1
				let range = start..<start + length
				let zeroes = array[range]
				arrayCopy.removeSubrange(range)
				arrayCopy += zeroes
				length = 0
			}
		}
		
		print("Did I push the zeroes \(arrayCopy)")
		
	}
	
	static func pullZeroesWith(array: [Int]) {
		
		var copy = array;
		var length = 0
		
		for i in 0..<copy.count {
			let value = copy[i]
			
			if value == 0 {
				length = length + 1
			}
			else if length != 0 {
				let range = i - length..<i
				let zeroes = copy[range]
				copy.removeSubrange(range)
				copy.insert(contentsOf: zeroes, at: 0)
			}
			
		}
		
		print("Did I pull the zeroes \(copy)");
	 
	}
	
	static func removeDuplicatesWith(array: [Int]) {
		
		var copy = array
		
		var bag: Set<Int> = []
		
		var index = 0
		while index < copy.count {
			let value = copy[index]
			if bag.contains(value) {
				copy.remove(at: index)
			}
			else {
				bag.insert(value)
				index = index + 1
			}
		}
		
		print("Did I remove the duplicates? \(copy)")
		
	}
	
	static func binaryTreeToListWith(tree: BinaryTreeSwift) {
		
		let node = tree.root
		
		let array: [Int] = []
		let result = self.doBreadthFirstSearch(node: node!, array: array)
		print("Did I get my binary List from a tree \(result)")
		
	}
	
	static func doBreadthFirstSearch(node: BinaryTreeNodeSwift?,  array: [Int]) -> [Int]{
		
		var copy = array
		print("Coming in with node \(node?.value)")
		
		if let theNode = node {
			copy = self.doBreadthFirstSearch(node: theNode.leftChild, array: copy)
			print("What's happening to my array 1? \(copy.count)")
			copy.append(theNode.value)
			print("What's happening to my array 2? \(copy.count)")
			copy = self.doBreadthFirstSearch(node: theNode.rightChild, array: copy)
			print("What's happening to my array 3? \(copy.count)")
		}
		
		return copy
	}
	
	static func setupPermutations() {
		
		let map = [2 : ["A", "B", "C"],
		           3 : ["D", "E", "F"],
		           4 : ["G", "H", "I"]]
		
		let input = [2, 3, 4]
		
		let results = self.doPermutations(map: map, input: input, output: [], index: 0, payload: "")
		
		print("permutation result: \(results)")
		
	}
	
	static func doPermutations(map: [Int: [String]], input: [Int], output: [String], index: Int, payload: String) -> [String] {
		
		var copy = output
		if index == input.count {
			
			copy += [payload]
			return copy
		}
		
		let key = input[index]
		
		let options = map[key]
		
		for i in 0..<options!.count {
			var newPayload = payload
			newPayload += options![i]
			copy =  self.doPermutations(map: map, input: input, output: copy, index: index + 1, payload: newPayload)
		}
		
		return copy
		
	}
	
	static func findCommonAncestor(i: UIView, m: UIView) -> UIView? {
		
		// tarverse the tree upwards
		
		var superview: UIView?
		superview = i.superview
		var path1: [UIView] = []
		
		while superview != nil {
			path1.append(superview!)
			superview = superview!.superview
		}
		
		// traverse it downwards until you find a fork
		
		superview = m.superview
		var path2: [UIView] = []
		
		while superview != nil {
			path2.append(superview!)
			superview = superview?.superview
		}
		
		var commonSuperView: UIView?
		
		while !path1.isEmpty && !path2.isEmpty {
			
			let superview1 = path1.last
			let superview2 = path2.last
			
			if superview1 === superview2 {
    			commonSuperView = superview1
			}
			else {
				break
			}
			
			path1.removeLast()
			path2.removeLast()
			
		}
		
		return commonSuperView
		
	}
	
	static func swapNodes(node: LinkedListItemSwift) {
		
		// we move in pairs, therefore we only care if there is a neighbor to the incoming node. If that's the case we stop the recursion
		
		if let next = node.next {
			
			// get the next pair
			// Doesn't matter if its nil, we'll use it to nil out the next pointer of the incoming node
			let nextpairFirst = next.next
			
			// reverse the pair
			next.next = node
			
			/* hook into the next pair: 
			Either its a complete pair in which case we hook into the second item. 
			Or its a dangling node and the end of the list, in which case we hook into the dangling node.
			Or the current pair is the end of the list, in which case we nil out the node's next pointer.
*/
			if let nextPairSecond = nextpairFirst?.next {
				node.next = nextPairSecond
			}
			else {
				node.next = nextpairFirst
			}
			
			if nextpairFirst != nil {
				self.swapNodes(node: nextpairFirst!)
			}
		}
	}
	
	
}

class BinaryTreeSwift: NSObject {
	
	@objc var root: BinaryTreeNodeSwift?
	
	func insertValue (value: Int) {
		
		let newNode = BinaryTreeNodeSwift(value: value)
		
		if let root = self.root {
			root.addNode(node: newNode)
		}
		else {
			self.root = newNode
		}
	}
	
}

class BinaryTreeNodeSwift: NSObject {
	
	var leftChild: BinaryTreeNodeSwift?
	var rightChild: BinaryTreeNodeSwift?
	var value: Int
	
	init(value: Int) {
		self.value = value
	}
	
	func addNode (node: BinaryTreeNodeSwift) {
		
		
		if node.value < self.value {
			if let left = self.leftChild {
				left.addNode(node: node)
			}
			else {
				self.leftChild = node
			}

		}
		else {
			if let right = self.rightChild {
				right.addNode(node: node)
			}
			else {
				self.rightChild = node
			}
		}
	}
	
}

class LinkedListSwift: NSObject {
	
	var head: LinkedListItemSwift?
	
	func insertValue(value: Int) {
		
		if let head = self.head {
			head.insertItem(item: LinkedListItemSwift(value: value))
		}
		else {
			self.head = LinkedListItemSwift(value: value)
		}
	}
}

class LinkedListItemSwift: NSObject {
	
	var next: LinkedListItemSwift?
	var value: Int
	
	init(value: Int) {
		self.value = value
	}
	
	func insertItem(item: LinkedListItemSwift) {
		if let next = self.next {
			next.insertItem(item: item)
		}
		else {
			self.next = item;
		}
	}
	
	func recursivePrint () {
		print("linked list item with value: \(self.value)")
		self.next?.recursivePrint()
	}
	
}

class EnumeratorSwift: NSObject {
	
	var data: [Any]
	var currentEnumerator: EnumeratorSwift?
	var currentIndex: Int = 0
	
	
	init(data: [Any]) {
		self.data = data
	}

	func next () -> NSNumber? {
		
		if self.currentIndex == self.data.count { // out of bounds
			return nil
		}
		else {
			if let current = self.currentEnumerator { // nested enumerator present, attempt to step through it
				let success = current.next()
				
				if success != nil {
					return success
				}
				else { // nested enumerator bailed, pop out of it
					self.currentEnumerator = nil
					return self.moveToNextIndex()
				}
			}
			else {
				return self.moveToNextIndex()
			}
		}
	}
	
	func moveToNextIndex() -> NSNumber? {
		let current = self.currentIndex
		self.currentIndex = self.currentIndex + 1
		
		if let value = self.data[current] as? [Any] {
			self.currentEnumerator = EnumeratorSwift(data: value)
			return self.currentEnumerator?.next()
		}
		else {
			return self.data[current] as? NSNumber
		}
	}
	
}
