//
//  MathsDomain.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 24/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Foundation

enum MathBracketSymbol {
    case lParen
    case rParen
}

enum FunctionType : String {
    case Arccos = "arccos"
    case Arcsin = "arcsin"
    case Arctan = "arctan"
    case Arg    = "arg"
    case Cos    = "cos"
    case Cosh   = "cosh"
    case Cot    = "cot"
    case Coth   = "coth"
    case Csc    = "csc"
    case Deg    = "deg"
    case Det    = "det"
    case Dim    = "dim"
    case Exp    = "exp"
    case Gcd    = "gcd"
    case Hom    = "hom"
    case Inf    = "inf"
    case Ker    = "ker"
    case Lg     = "lg"
    case Lim    = "lim"
    case Liminf = "liminf"
    case Limsup = "limsup"
    case Ln     = "ln"
    case Log    = "log"
    case Max    = "max"
    case Min    = "min"
    case Pr     = "pr"
    case Sec    = "sec"
    case Sin    = "sin"
    case Sinh   = "sinh"
    case Sup    = "sup"
    case Tan    = "tan"
    case Tanh   = "tanh"
    
    var acceptsLimits : Bool {
        switch self {
        case .Det : return true
        case .Pr  : return true
        case .Gcd : return true
        case .Sup : return true
        case .Inf : return true
        case .Lim : return true
        case .Liminf : return true
        case .Limsup : return true
        case .Max : return true
        case .Min : return true
        case _ : return false
        }
    }
    
    init?(name: String) {
        switch name {
        case "arccos" : self = .Arccos
        case "arcsin" : self = .Arcsin
        case "arctan" : self = .Arctan
        case "arg"      : self = .Arg
        case "cos"      : self = .Cos
        case "cosh"     : self = .Cosh
        case "cot"      : self = .Cot
        case "coth"     : self = .Coth
        case "csc"      : self = .Csc
        case "deg"      : self = .Deg
        case "det"      : self = .Det
        case "dim"      : self = .Dim
        case "exp"      : self = .Exp
        case "gcd"      : self = .Gcd
        case "hom"      : self = .Hom
        case "inf"      : self = .Inf
        case "ker"      : self = .Ker
        case "lg"       : self = .Lg
        case "lim"      : self = .Lim
        case "liminf"   : self = .Liminf
        case "limsup"   : self = .Limsup
        case "ln"       : self = .Ln
        case "log"      : self = .Log
        case "max"      : self = .Max
        case "min"      : self = .Min
        case "pr"       : self = .Pr
        case "sec"      : self = .Sec
        case "sin"      : self = .Sin
        case "sinh"     : self = .Sinh
        case "sup"      : self = .Sup
        case "tan"      : self = .Tan
        case "tanh"     : self = .Tanh
        case _ : return nil
        }
    }
}

enum MathSymbolType {
    case sum
    case integral
}

enum MathSymbolContentType : Equatable {
    case text(text: String)
    case `operator`(op: String)
    case symbol(mode: MathSymbolType)
    case function(type: FunctionType)
}

func ==(l: MathSymbolContentType, r: MathSymbolContentType) -> Bool {
    switch (l,r) {
    case let (.text(text: t1), .text(text: t2)) : return t1 == t2
    case let (.operator(op: o1), .operator(op: o2)) : return o1 == o2
    case let (.symbol(mode: m1), .symbol(mode: m2)) : return m1 == m2
    case let (.function(type: f1), .function(type: f2)) : return f1 == f2
    case _ : return false
    }
}

struct MathSymbol {
    let symbol         : MathSymbolContentType
    let symSubscript   : MathExpr?
    let symSuperscript : MathExpr?
    
    init(symbol: MathSymbolContentType, symSubscript: MathExpr?, symSuperscript: MathExpr?) {
        self.symbol = symbol
        self.symSubscript = symSubscript
        self.symSuperscript = symSuperscript
    }
    
    func shouldInline(_ inline : Bool) -> Bool  {
        switch self.symbol {
        case let .function(ft) : return inline ? true : ft.acceptsLimits
        case .symbol(.integral) : return inline
        case .symbol(.sum) : return inline
        case _ : return true
        }
    }
}


indirect enum MathExpr {
    case symbol(sym: MathSymbol)
    case sequence(exprs: [MathExpr])
    case Fraction(numerator: MathExpr, denominator: MathExpr)
    case Binomial(n: MathExpr, k: MathExpr)
    case Bracketed(left: MathBracketSymbol, expr: MathExpr, right: MathBracketSymbol)
    case Root(order: MathExpr?, expr: MathExpr)
    
    init(value: String) {
        let ct : MathSymbolContentType
        if let fn = FunctionType(name: value) {
            ct = MathSymbolContentType.function(type: fn)
        }
        else if value == "sum" {
            ct = MathSymbolContentType.symbol(mode: .sum)
        }
        else if value == "int" {
            ct = MathSymbolContentType.symbol(mode: .integral)
        }
        else if Set(arrayLiteral: "+","-","/","*","=").contains(value) {
            ct = MathSymbolContentType.operator(op: value)
        }
        else {
            ct = MathSymbolContentType.text(text: value)
        }
        let a = MathSymbol(symbol: ct , symSubscript: .none, symSuperscript: .none)
        self = MathExpr.symbol(sym: a)
    }
}


extension MathExpr : ExpressibleByStringLiteral {
    typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    typealias UnicodeScalarLiteralType = StringLiteralType
    
    init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init(value: value)
    }

    init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init(value: value)
    }

    init(stringLiteral value: StringLiteralType) {
        self.init(value: value)
    }
}

extension MathExpr : ExpressibleByArrayLiteral {
    init(arrayLiteral elements: MathExpr...) {
        self = MathExpr.sequence(exprs: elements)
    }
}


