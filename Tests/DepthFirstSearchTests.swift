//
//The MIT License (MIT)
//
//Copyright (c) 2015 Marco Conti<marcoconti83@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//

import XCTest
import Battipista

/// Node within finite graph
private typealias TestNode = GraphNodeFromGraphEdges<String>


class DepthFirstSearchTests: XCTestCase {
    
    func testThatItReturnsTheStartNode() {
        
        // given
        let node = TestNode(graphEdges: [:], nodeContent: "a")
        let sut = DepthFirstSearch(root: node)
        
        // when
        let next = sut.next()?.last
        
        // then
        XCTAssertEqual(next?.content, "a")
    }
    
    func testThatVisitsInDepthFirstOrder() {
        
        // given
        let node = TestNode(graphEdges: [
            "r" : ["A","B"],
            "B" : ["C", "D"],
            "A" : ["E"],
            "C" : ["F"]
            ], nodeContent: "r")
        let sut = DepthFirstSearch(root: node)
        
        // when
        let nodes = sut.map { $0.last!.content }
        
        
        // then
        XCTAssertEqual(nodes, ["r", "B", "D", "C", "F", "A", "E"])
    }
    
    func testThatItDoesNotRevisitNodesIfThereIsACycle() {
        
        // given
        let node = TestNode(graphEdges: [
            "r" : ["A","B"],
            "B" : ["r"]
            ], nodeContent: "r")
        let sut = DepthFirstSearch(root: node)
        
        // when
        let nodes = sut.map { $0.last!.content }
        
        
        // then
        XCTAssertEqual(nodes, ["r", "B", "A"])
    }
    
    func testThatItReturnsTheVisitHistory() {
        
        // given
        let node = TestNode(graphEdges: [
            "r" : ["A","B"],
            "B" : ["C"]
            ], nodeContent: "r")
        let sut = DepthFirstSearch(root: node)
        
        // when
        let visitHistory = sut.map { $0.map { $0.content } }
        
        // then
        let expected = [
            ["r"],
            ["r","B"],
            ["r","B", "C"],
            ["r","A"]
        ]
        XCTAssertEqual(visitHistory, expected)
        
    }
    
    func testThatItVisitAnInfiniteTreeByBranches() {
        
        // given
        let node = GraphNodeFromGeneratingFunction(nodeContent: "") {
            parent in return ["L","R"].map { parent + $0 }
        }
        let sut = DepthFirstSearch(root: node)
        let levels = 4
        
        // when
        let generator = sut.generate()
        var generatedPaths = [[String]]()
        while generatedPaths.count < 100 { // safety count in case there is a bug and the test would never end
            guard let next = generator.next() where next.count < levels+1 else { break }
            generatedPaths.append(next.map { $0.content})
        }
        
        // then
        XCTAssertEqual(generatedPaths, [[""], ["", "R"], ["", "R", "RR"], ["", "R", "RR", "RRR"]])
        
    }
}
