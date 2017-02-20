//
//  AlgorithmSwiftTests.swift
//  Algorithms
//
//  Created by Maxime Boulat on 2/19/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

import XCTest
@testable import Algorithms

class AlgorithmSwiftTests: XCTestCase {
	
	var numbers: [Int] = []
    
    override func setUp() {
        super.setUp()
		
		self.numbers = AlgorithmManagerSwift .makeArrayOfInts(capacity: 1000, range: 100)
		
//		print("Here are my numbers: \(self.numbers)")
		
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testPushZeroes() {
		
		let shifted = AlgorithmManagerSwift.pushZeroesWith(array: self.numbers)
		var passed = true
		
		if shifted.count != self.numbers.count {
			passed = false
		}
		
		var rangeStarted = false
		for i in 0..<shifted.count {
			
			let number = shifted[i]
			
			if !rangeStarted {
				if number == 0 {
					rangeStarted = true
				}
			}
			else if number != 0 {
				passed = false
			}
			
			if rangeStarted && i == shifted.count - 1 && number != 0 {
    			passed = false
			}
		}
		
		XCTAssertTrue(passed)
	}
	
	func testPullZeroes() {
		
		let shifted = AlgorithmManagerSwift.pullZeroesWith(array: self.numbers)
		
		var passed = true
		
		if shifted.count != self.numbers.count {
			passed = false
		}
		
		var rangeStarted = false
		
		for i in (0..<shifted.count).reversed() {
			
			let number = shifted[i]
			
			if !rangeStarted {
				if number == 0 {
					rangeStarted = true
				}
			}
			else if number != 0 {
				passed = false
			}
			
			if rangeStarted && i == 0 && number != 0 {
				passed = false
			}

		}

		XCTAssertTrue(passed);
	}
	
	func testRemoveDuplicates() {
		
		let result = AlgorithmManagerSwift.removeDuplicatesWith(array: self.numbers)
		
		let bag = Set(self.numbers.map({$0}))
		
		let g = Array(bag)
		
		XCTAssertEqual(g.sorted(by: <), result.sorted(by: <))
	}
	
	func testLocationSort() {
		
		let sorted = AlgorithmManagerSwift.locationSort(array: self.numbers)
		
		XCTAssertEqual(self.numbers.sorted(by: <), sorted)
	}
	
	func testInsertionSort() {
		
		let sorted = AlgorithmManagerSwift.insertionSort(array: self.numbers)
		
		XCTAssertEqual(self.numbers.sorted(by: <), sorted)
	}
	
	func testMergeSort() {
		
		let sorted = AlgorithmManagerSwift.mergeSort(array: self.numbers, start: 0, end: self.numbers.count - 1)
		
		XCTAssertEqual(self.numbers.sorted(by: <), sorted)
	}
	
	func testQuickSort() {
		
		let sorted = AlgorithmManagerSwift.quickSort(array: self.numbers, start: 0, end: self.numbers.count - 1)
		
		XCTAssertEqual(self.numbers.sorted(by: <), sorted)
	}
	
	func testPalindrome() {
		let palindrome = "rotor"
		let notPalindrome = "svwevc"
		
		XCTAssertTrue(AlgorithmManagerSwift.isPalindrome(string: palindrome))
		XCTAssertFalse(AlgorithmManagerSwift.isPalindrome(string: notPalindrome))
	}
	
	
	func testBinaryTreeToList() {
		
		let binaryTree = BinaryTreeSwift()
		
		for number in self.numbers {
			binaryTree.insertValue(value: number)
		}
		
		let list = AlgorithmManagerSwift.binaryTreeToListWith(tree: binaryTree)
		
		XCTAssertEqual(self.numbers.sorted(by: <), list)
		
	}
	
	func testPermutations() {
		
		let map = [2 : ["A", "B", "C"],
		           3 : ["D", "E", "F"],
		           4 : ["G", "H", "I"],
		           5 : ["J", "K", "L"],
		           6 : ["M", "N", "O"],
		           7 : ["P", "Q", "R", "S"],
		           8 : ["T", "U", "V"]]
		
		let input = [2, 3, 4]
		
		let result = AlgorithmManagerSwift.setupPermutations(map: map, input: input)
		
		let g = ["ADG", "ADH", "ADI", "AEG", "AEH", "AEI", "AFG", "AFH", "AFI", "BDG", "BDH", "BDI", "BEG", "BEH", "BEI", "BFG", "BFH", "BFI", "CDG", "CDH", "CDI", "CEG", "CEH", "CEI", "CFG", "CFH", "CFI"]
		
		
		XCTAssertEqual(result.sorted(by: <), g.sorted(by: <))
		
	}
	
	func testEnumerator() {
		
		let array: [Any] = [[[3, 45, 4, [2, 89, 7], 4, 1], 7, [35, 2], 6], 15, 97]
		
		let enumerator = EnumeratorSwift(data: array)
		
		XCTAssertEqual(enumerator.next(), 3);
		XCTAssertEqual(enumerator.next(), 45);
		XCTAssertEqual(enumerator.next(), 4);
		XCTAssertEqual(enumerator.next(), 2);
		XCTAssertEqual(enumerator.next(), 89);
		XCTAssertEqual(enumerator.next(), 7);
		XCTAssertEqual(enumerator.next(), 4);
		XCTAssertEqual(enumerator.next(), 1);
		XCTAssertEqual(enumerator.next(), 7);
		XCTAssertEqual(enumerator.next(), 35);
		XCTAssertEqual(enumerator.next(), 2);
		XCTAssertEqual(enumerator.next(), 6);
		XCTAssertEqual(enumerator.next(), 15);
		XCTAssertEqual(enumerator.next(), 97);
		
		let g: [Int] = [3, 45, 4, 2, 89, 7, 4, 1, 7, 35, 2, 6, 15, 97]
		
		XCTAssertEqual(enumerator.allObjects(), g)
		
	}
	
	func testSortPerformance() {
	
		self.measure {
			_ = self.numbers.sorted(by: <)
		}
	
	}
	
	func testLocationSortPerformance() {
		
		self.measure {
			_ = AlgorithmManagerSwift.locationSort(array: self.numbers)
		}
	}
	
	func testInsertionSortPerformance() {
		
		self.measure {
			_ = AlgorithmManagerSwift.insertionSort(array: self.numbers)
		}
	}
	
	func testMergeSortPerformance() {
		
		self.measure {
			_ = AlgorithmManagerSwift.mergeSort(array: self.numbers, start: 0, end: self.numbers.count - 1)
		}
	}
	
	func testQuickSortPerformance() {
		
		self.measure {
			_ = AlgorithmManagerSwift.quickSort(array: self.numbers, start: 0, end: self.numbers.count - 1)
		}
	}
	
}
