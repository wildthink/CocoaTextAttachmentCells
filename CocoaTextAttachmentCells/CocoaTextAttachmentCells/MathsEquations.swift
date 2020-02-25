//
//  MathsEquations.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 24/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Cocoa


//infix operator ^- {associativity left precedence 130}
infix operator ^- : MultiplicationPrecedence

func ^-(le: MathExpr, re: MathExpr) -> MathExpr {
    switch le {
    case let .symbol(sym) :
        let ns = MathSymbol(symbol: sym.symbol, symSubscript: re, symSuperscript: sym.symSuperscript)
        return MathExpr.symbol(sym: ns)
    case _ : return MathExpr.sequence(exprs: [le,re])
    }
}

//infix operator ^^ {associativity left precedence 130}
infix operator ^^ : MultiplicationPrecedence
func ^^(le: MathExpr, re: MathExpr) -> MathExpr {
    switch le {
    case let .symbol(sym) :
        let ns = MathSymbol(symbol: sym.symbol, symSubscript: sym.symSubscript, symSuperscript: re)
        return MathExpr.symbol(sym: ns)
    case _ : return MathExpr.sequence(exprs: [le,re])
    }
}


func /(le : MathExpr, re: MathExpr) -> MathExpr {
    return MathExpr.Fraction(numerator: le, denominator: re)
}

struct MathEquations {
    
    static func v(_ t: String) -> MathSymbolContentType {
        return MathSymbolContentType.text(text: t)
    }
    
    static func op(_ t: String) -> MathSymbolContentType {
        return MathSymbolContentType.operator(op: t)
    }
    
    static func s(_ s: MathSymbolContentType, sub: MathExpr? = .none, sup: MathExpr? = .none) -> MathSymbol {
        return MathSymbol(symbol: s, symSubscript: sub, symSuperscript: sup)
    }
    
    static func se(_ s: MathSymbolContentType, sub: MathExpr? = .none, sup: MathExpr? = .none) -> MathExpr {
        let a = MathSymbol(symbol: s, symSubscript: sub, symSuperscript: sup)
        return MathExpr.symbol(sym: a)
    }
    
    static func se(_ s: String, sub: MathExpr? = .none, sup: MathExpr? = .none) -> MathExpr {
        let sym = v(s)
        let a = MathSymbol(symbol: sym , symSubscript: sub, symSuperscript: sup)
        return MathExpr.symbol(sym: a)
    }
    
    static func pythagorasTheorum() -> (NSAttributedString,MathExpr,NSAttributedString) {
        let pretxt = NSAttributedString(string: "Pythagoras's Theorum: ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :Pythagoras, 530 BC\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        // a^2 + b^2 = c^2
//        let v : MathExpr = "x"

        let expr : MathExpr = ["a" ^^ "2" , "+", "b" ^^ "2", "=", "c" ^^ "2"]
        return (pretxt,expr,posttxt)
    }
    
    static func logarithms() -> (NSAttributedString,MathExpr,NSAttributedString) {
        let pretxt = NSAttributedString(string: "Logarithms:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :John Napier, 1610\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        // log xy = log x + log y
        let expr : MathExpr = ["log", " ", ["x","y"], "=", ["log"," ","x"], "+", ["log", " ", "y"]]
        return (pretxt,expr,posttxt)
    }
    
    static func calculus() -> (NSAttributedString,MathExpr,NSAttributedString) {
        // df/dt = lim(h->0) = (f(t+h) - f(t))/h
        
        let pretxt = NSAttributedString(string: "Calculus:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :Newton, 1668\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        let expr : MathExpr = [["d","f"] / ["d","t"], "=", "lim" ^- ["h", "\u{21a6}", "0"], "=", ["f", "(", "t", "+", "h", ")", "-", "f", "(", "t", ")"] / "h"]
        
        return (pretxt,expr,posttxt)
    }
    
    static func lawOfGravity() -> (NSAttributedString,MathExpr,NSAttributedString) {
        // F = G((m_1 m_2)/r^2)
        
        let pretxt = NSAttributedString(string: "Law of Gravity:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :Newton, 1687\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        let expr : MathExpr = ["F", "=", "G", ["m" ^- "1", "m" ^- "2"] / ("r" ^^ "2")]
        
        return (pretxt,expr,posttxt)
    }
    
    static func rootMinusOne() -> (NSAttributedString,MathExpr,NSAttributedString) {
        // F = G((m_1 m_2)/r^2)
        
        let pretxt = NSAttributedString(string: "The square root of minus one:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :Euler, 1750\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        let expr : MathExpr = ["i" ^^ "2" , "=", "-1"]
        
        return (pretxt,expr,posttxt)
    }
    
    static func polyhedra() -> (NSAttributedString,MathExpr,NSAttributedString) {
        // V - E + F = 2
        
        let pretxt = NSAttributedString(string: "Euler's formula for polyhedra:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :Euler, 1751\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        let expr : MathExpr = ["V", "-", "E", "+", "F", "=" , "2"]
        
        return (pretxt,expr,posttxt)
    }
    
    static func normalDistribution() -> (NSAttributedString,MathExpr,NSAttributedString) {
        let pretxt = NSAttributedString(string: "Normal Distribution:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :C.F. Gauss, 1810\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        let root : MathExpr = ["1" / MathExpr.Root(order: .none, expr: ["2", "\u{03C0}", "p"])]
        let ep : MathExpr = [["(", "\u{221E}", "-", "\u{03BC}",")" ^^ "2"] / ["2", "p" ^^ "2"]]
        let expr : MathExpr = ["\u{03C6}", "(", "x",")", "=", [root, "e" ^^ ep]]
        
        return (pretxt,expr,posttxt)
    }
    
    static func waveEquation() -> (NSAttributedString,MathExpr,NSAttributedString) {
        let pretxt = NSAttributedString(string: "Wave Equation:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :J. d'Almbert, 1746\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        let expr : MathExpr = [["\u{03B4}" ^^ "2", "u"] / ["\u{03B4}", "t" ^^ "2"], "=", "c" ^^ "2", ["\u{03B4}" ^^ "2", "u"] / ["\u{03B4}", "x" ^^ "2"]]
        
        return (pretxt,expr,posttxt)
    }
    
    static func fourierTransform() -> (NSAttributedString,MathExpr,NSAttributedString) {
        let pretxt = NSAttributedString(string: "Fourier Transform:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :J. Fourier, 1822\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        let expr : MathExpr = ["f", "(", "w", ")", "int" ^^ "\u{221E}" ^- "\u{221E}", "f", "(", "x", ")", "e" ^^ ["-2", "\u{03C0}", "i", "x", "w"], "d", "x"]
        
        return (pretxt,expr,posttxt)
    }
    
    static func navierStokes() -> (NSAttributedString,MathExpr,NSAttributedString) {
        let pretxt = NSAttributedString(string: "Navier-Stokes Equation:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :C. Navier, G. Stokes, 1845\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        let brk = MathExpr.Bracketed(left: .lParen, expr: [["\u{03B4}", "v"] / ["\u{03B4}", "t"], "+", "v", "\u{2022}", "\u{25bd}", "v"], right: .rParen)
        let expr : MathExpr = ["\u{03C1}", brk, "=", "-", "\u{25bd}", "p", "+", "\u{25bd}", "\u{2022}", "T", "f", " "] // bug with trailing f sizing so add extra space (needs fixing)
        
        return (pretxt,expr,posttxt)
    }
    
    static func maxwells() -> (NSAttributedString,MathExpr,NSAttributedString) {
        let pretxt = NSAttributedString(string: "Maxwell's Equations:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :J.C. Maxwell, 1865\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        let expr : MathExpr = []
        
        return (pretxt,expr,posttxt)
    }
    
    static func thermo() -> (NSAttributedString,MathExpr,NSAttributedString) {
        let pretxt = NSAttributedString(string: "Second Law of Thermodynamics:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :L. Boltzmann, 1874\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        let expr : MathExpr = ["d", "S" , " ", "\u{2265}", " ", "0"]
        
        return (pretxt,expr,posttxt)
    }
    
    static func relativity() -> (NSAttributedString,MathExpr,NSAttributedString) {
        let pretxt = NSAttributedString(string: "Relativity:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :Einstein, 1905\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        let expr : MathExpr = ["E", "=", "m", "c" ^^ "2"]
        
        return (pretxt,expr,posttxt)
    }
    
    static func schrodinger() -> (NSAttributedString,MathExpr,NSAttributedString) {
        let pretxt = NSAttributedString(string: "Schrodingers's Equation:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :E. Schrodinger, 1927\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        let expr : MathExpr = ["i", "h", "\u{03B4}" / ["\u{03B4}", "t"], "\u{03A8}", "=", "H", "\u{03A8}"]
        
        return (pretxt,expr,posttxt)
    }
    
    static func infoTheory() -> (NSAttributedString,MathExpr,NSAttributedString) {
        let pretxt = NSAttributedString(string: "Information Theory:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :C. Shannon, 1949\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        let expr : MathExpr = ["H", "=", "-", "sum", "p", "(", "x", ")", "log", "p", "(", "x", ")"]
        
        return (pretxt,expr,posttxt)
    }
    
    static func chaos() -> (NSAttributedString,MathExpr,NSAttributedString) {
        let pretxt = NSAttributedString(string: "Chaos Theory:      ", attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18)])
        let posttxt = NSAttributedString(string: "      :Robert May, 1975\n\n", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 18)])
        
        let brk = MathExpr.Bracketed(left: .lParen, expr: ["1", "-", "x" ^- "t"], right: .rParen)
        let expr : MathExpr = ["x" ^- ["t", "+", "1"], "=", "k", "x" ^- "t", brk]
        
        return (pretxt,expr,posttxt)
    }
    
//    static func blackScholes() -> (NSAttributedString,MathExpr,NSAttributedString) {
//        let pretxt = NSAttributedString(string: "Black-Scholes Equation:      ", attributes: [NSFontAttributeName: NSFont.boldSystemFont(ofSize: 18)])
//        let posttxt = NSAttributedString(string: "      :F. Black, M.Scholes, 1990\n\n", attributes: [NSFontAttributeName: NSFont.systemFont(ofSize: 18)])
//        
//        let expr : MathExpr = ["1" / "2", "\u{03C3}" ^^ "2", "S" ^^ "2", ["\u{03B4}" ^^ "2", "V"] / ["\u{03B4}", "S" ^^ "2"], "+", "r", "S", ["\u{03B4}" , "V"] / ["\u{03B4}", "S"], "+", ["\u{03B4}", "V"] / ["\u{03B4}", "t"], "-" , "r", "V", "=", "0"]
//        
//        return (pretxt,expr,posttxt)
//    }


}











