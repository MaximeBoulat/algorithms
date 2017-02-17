//
//  AlgorithmManager.swift
//  Algorithms
//
//  Created by Maxime Boulat on 2/14/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

import UIKit

class AlgorithmManagerSwift: NSObject {
	
	// MARK:- Shift zeroes

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
	
	// MARK:- Remove duplicate
	
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
	
	// MARK:- Binary tree to list
	
	static func binaryTreeToListWith(tree: BinaryTreeSwift) {
		
		let node = tree.root
		
		let array: [Int] = []
		let result = self.doBreadthFirstSearch(node: node!, array: array)
		print("Did I get my binary List from a tree \(result)")
		
	}
	
	static func doBreadthFirstSearch(node: BinaryTreeNodeSwift?,  array: [Int]) -> [Int]{
		
		var copy = array
		
		if let theNode = node {
			copy = self.doBreadthFirstSearch(node: theNode.leftChild, array: copy)
			copy.append(theNode.value)
			copy = self.doBreadthFirstSearch(node: theNode.rightChild, array: copy)
		}
		
		return copy
	}
	
	// MARK:- Permutations
	
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
	
	// MARK:- Nearest common ancestor
	
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
	
	// MARK:- Swap nodes
	
	static func swapNodes(node: LinkedListItemSwift) {
		
		// we move in pairs, therefore we only care if there is a neighbor to the incoming node. If that's not the case we stop the recursion
		
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
			
			// recurse
			if nextpairFirst != nil {
				self.swapNodes(node: nextpairFirst!)
			}
		}
	}
	
	// MARK:- Palindrome
	
	static func isPalindrome(string: String) -> Bool {
		
		if string.characters.count <= 1 {
			return true
		}
		
		let first = string[string.startIndex];
		let last = string[string.index(before: string.endIndex)]
		
		if first == last {
			let range = string.index(after: string.startIndex)..<string.index(before: string.endIndex)
			let substring = string[range]
			return self.isPalindrome(string: substring)
		}
		else {
			return false
		}
		
	}
	
	// MARK:- Sorting
	
	static func locationSort( array: [Int])-> [Int] {
	
		var sorted = array
		
		for i in 0..<array.count {
			let indexOfSmallest = self.indexOfSmallest(startingindex: i, array: sorted)
			let smallest = sorted[indexOfSmallest]
			sorted.remove(at: indexOfSmallest)
			sorted.insert(smallest, at: i)
		}
		
		return sorted
	}
	
	private static func indexOfSmallest(startingindex: Int, array: [Int]) -> Int {
		
		var smallest = array[startingindex]
		var
		indexOfSmallest = startingindex
		
		for i in indexOfSmallest + 1..<array.count {
			if array[i] < smallest {
				smallest = array[i]
				indexOfSmallest = i
			}
		}
		
		return indexOfSmallest
	}
	
	static func insertionSort( array: [Int]) -> [Int] {
		
		var copy = array
		
		for i in 1..<copy.count {
			let reference = copy[i]
			var insertIndex = i

			for j in (0...i-1).reversed(){
				let incoming = copy[j]
				
				if incoming > reference {
					insertIndex = j
					copy[j+1] = copy[j]
				}
				else {
					break
				}
			}
			
			copy[insertIndex] = reference
		}
		
		return copy
	}
	
	static func mergeSort( array: [Int], start: Int, end: Int) -> [Int] {
		
		var copy = array
		
		if end > start {
			
			let q = (start + end) / 2
			copy = self.mergeSort(array: copy, start: start, end: q)
			copy = self.mergeSort(array: copy, start: q + 1, end: end)
			copy = self.merge(array: copy, start: start, midPoint: q, end: end)
		}
		
		return copy
	}
	
	private static func merge( array: [Int], start: Int, midPoint: Int, end: Int) -> [Int] {
		
		var copy = array
		var lowerHalf = Array(copy[start...midPoint])
		var upperHalf = Array(copy[midPoint + 1...end])
		var indexLowerHalf = 0
		var indexUpperHalf = 0
		
		for i in start...end {
			
			if indexLowerHalf == lowerHalf.count {
				let rangeOfRemaining = indexUpperHalf..<upperHalf.count
				let remaining = Array(upperHalf[rangeOfRemaining])
				copy.replaceSubrange(i...end, with: remaining)
				break
			}
			else if (indexUpperHalf == upperHalf.count) {
				let rangeOfRemaining = indexLowerHalf..<lowerHalf.count
				let remaining = Array(lowerHalf[rangeOfRemaining])
				copy.replaceSubrange(i...end, with: remaining)
				break
			}

			let valueLowerHalf = lowerHalf[indexLowerHalf]
			let valueUpperHalf = upperHalf[indexUpperHalf]
			
			if valueLowerHalf < valueUpperHalf {
				copy[i] = valueLowerHalf
				indexLowerHalf += 1
			}
			else {
				copy[i] = valueUpperHalf
				indexUpperHalf += 1
			}
		}
		
		return copy
	}
	
	static func quickSort(array: [Int], start: Int, end: Int) -> [Int] {
		
		var copy = array
		
		if end > start {
			let partition = self.partition(array: copy, start: start, end: end)
			copy = partition.array
			let newPivotIndex = partition.newIndex
			copy = self.quickSort(array: copy, start: start, end: newPivotIndex-1)
			copy = self.quickSort(array: copy, start: newPivotIndex + 1, end: end)
		}
		
		return copy
		
	}
	
	private static func partition( array: [Int], start: Int, end: Int) -> (array: [Int], newIndex: Int) {
		
		var copy = array
		var q = start
		let reference = copy[end]

		for i in start..<end {
			if copy[i] < reference {
			
    		copy = self.swap(array: copy, from: i, to: q)
				q += 1

			}
		}
		
		copy = self.swap(array: copy, from: q, to: end)
		
		return (copy, q)
	}
	
	private static func swap (array: [Int], from: Int, to: Int) -> [Int] {
		var copy = array
		let foo = copy[from]
		copy[from] = copy[to]
		copy[to] = foo
		
		return copy
	}
	
	
}





// MARK:- Binary Tree Declaration

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

// MARK:- Linked list declaration

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

// MARK:- Enumerator declaration

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
			if let current = self.currentEnumerator { // nested enumerator detected, attempt to step through it
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
	
	private func moveToNextIndex() -> NSNumber? {
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
	
	func allObjects() -> [Any] {
		
		var retVal: [Any] = []
		
		for element in self.data {
			if let array = element as? [Any] {
				let enumerator = EnumeratorSwift(data: array)
				let objects = enumerator.allObjects()
				retVal += objects
			}
			else {
				retVal += [element]
			}
		}
		return retVal
	}
	
}
