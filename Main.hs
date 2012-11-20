import Codec.TPTP
import System.Cmd
import System.IO
import System.Environment
import Data.Generics
import Data.List


import Debug.Trace


main = do
  args <- getArgs
  forms <- parseFile $ head args
  -- this strips comments and includes
  let formulas  = filter ( \x -> case x of
        (AFormula {}) -> True
        _ -> False ) forms
  --let a =  parse "fof(ax, axiom, a(c) => ! [X] : b(X))."
  putStrLn $ "[" ++  ((intercalate ",\n") . (map jsonify)) formulas ++ "]"

getString (AtomicWord s) = s
getName  (AFormula {name = s}) = getString s
getRole  (AFormula {role = (Role {unrole = s})}) = s
getFormula (AFormula { formula = f }) = genFormula $ unwrapF f

genFormula (BinOp f1 op f2) = "{"++
                               "\"type\": \"binaryOperator\" ,\n" ++
                               "\"op\"" ++ ": "++ decodeOp(op) ++ ",\n" ++
                               "\"leftFormula\"" ++ ": " ++ genFormula (unwrapF f1) ++ ",\n" ++
                               "\"rightFormula\"" ++ ": " ++ genFormula (unwrapF f2) ++ "\n" ++
                               "}"
genFormula (Quant quantor variables f) = "{" ++
                                "\"type\": \"quantor\",\n \"op\": " ++ decodeQuantor quantor ++ ",\n" ++
                                "\"variables\" : [" ++ ((intercalate ","). (map genVar)) variables ++ "]," ++
                                "\"formula\" : " ++ genFormula (unwrapF f) ++ "}"
genFormula ((:~:) f) = "{ \"type\" : \"unaryOperator\", \"op\" : \"~\", \"formula\" : " ++ (genFormula . unwrapF) f ++ "}"
genFormula (PredApp (AtomicWord s) args ) = "{ \"type\" : \"relation\", \"name\" : \"" ++ s ++ "\", " ++
                                            "\"terms\" : " ++ genTermList args  ++ "}"

genTerm (FunApp (AtomicWord name) args) = "{ \"type\" : \"function\", \"name\" : \"" ++ name ++ "\", " ++
                                            "\"terms\" : " ++ genTermList args  ++ "}"
genTerm (Var v) = genVar v

genVar (V s) = "{ \"type\" : \"variable\", \"name\": \"" ++ s ++ "\" }"



genTermList list = "[ " ++ intercalate ", " ( map (genTerm . unwrapT) list) ++ "]"

decodeQuantor q = "\"" ++ decodeQuantor1 q ++ "\""
decodeQuantor1 (All) = "!"
decodeQuantor1 (Exists) = "?"

decodeOp op = "\"" ++ decodeOp1 op ++ "\""
decodeOp1 (:=>:) = "=>"
decodeOp1 (:<=>:) = "<=>"
decodeOp1 (:<=:) = "<="
decodeOp1 (:&:) = "&"
decodeOp1 (:~&:) = "~&"
decodeOp1 (:|:) = "|"
decodeOp1 (:~|:) = "~|"


jsonify a@(AFormula{}) = "{" ++
            " \"name\" " ++ ": \"" ++ getName a ++ "\" ," ++
            " \"type\" " ++ ": \"" ++ getRole a ++ "\" ," ++
            " \"formula\" " ++ ":" ++ getFormula a ++ "}"
