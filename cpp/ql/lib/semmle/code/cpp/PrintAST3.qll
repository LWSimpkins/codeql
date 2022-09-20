/**
 * Provides queries to pretty-print a C++ AST as a graph.
 *
 * By default, this will print the AST for all functions in the database. To change this behavior,
 * extend `PrintASTConfiguration` and override `shouldPrintFunction` to hold for only the functions
 * you wish to view the AST for.
 */

import cpp
import semmle.code.cpp.PrintAST

/**
 * A node representing an `Expr`.
 */
class ExprNode3 extends ExprNode, AstNode {
  override string getProperty(string key) {
    result = AstNode.super.getProperty(key)
    or
    key = "ValuePrimaryClass" and
    result = primaryQlClass(expr)
    // or
    // key = "ValueClass" and
    // result = aQlClass(expr)
    or
    key = "Value" and
    result = getValue()
    or
    key = "TypePrimaryClass" and
    result = primaryQlClass(expr.getType())
    // or
    // key = "TypeyClass" and
    // result = aQlClass(expr.getType())
    or
    key = "Type" and
    result = expr.getType().toString()
    // or
    // key = "ValueCategory" and
    // result = expr.getValueCategoryString()
  }

  /**
   * Gets the value of this expression, if it is a constant.
   */
  // [AnalysedExpr,CompileTimeConstantInt,DefOrUse,Literal,NameQualifiableElement,PostOrderNode,PrintableElement] 10
  override string getValue() { result = expr.getValue() }
}

/**
 * A node representing a `StringLiteral`.
 */
class StringLiteralNode3 extends ExprNode3, StringLiteralNode {
  override string getValue() {
    result = StringLiteralNode.super.getValue()
  }
}

/**
 * A node representing a `Conversion`.
 */
class ConversionNode3 extends ExprNode3, ConversionNode{

}

/**
 * A node representing a `Cast`.
 */
class CastNode3 extends ConversionNode3, CastNode {

  override string getProperty(string key) {
    result = ConversionNode3.super.getProperty(key)
    or
    key = "Conversion" and
    result = "[" + qlConversion(cast) + "] " + cast.getSemanticConversionString()
  }
}

/**
 * A node representing a `StmtExpr`.
 */
class StmtExprNode3 extends ExprNode3, StmtExprNode {
  
}

/**
 * A node representing a `DeclarationEntry`.
 */
class DeclarationEntryNode3 extends DeclarationEntryNode, BaseAstNode {
  override string getProperty(string key) {
    result = BaseAstNode.super.getProperty(key)
    or
    key = "TypeClass" and
    result = qlClass(ast.getType())
    or
    key = "Type" and
    result = ast.getType().toString()
  }
}

/**
 * A node representing a `Parameter`.
 */
class ParameterNode3 extends ParameterNode {
  override string getProperty(string key) {
    result = super.getProperty(key)
    or
    key = "TypeClass" and
    result = qlClass(param.getType())
    or
    key = "Type" and
    result = param.getType().toString()
  }
}

string primaryQlClass(PrintableElement el) {
  result = "[" + concat(el.getAPrimaryQlClass0(), ",") + "]"
}

string aQlClass(PrintableElement el) {
  result = "["+ concat(el.getAQlClass(), ",") + "]"
}
