# tptp-to-json

This package translates tptp fol syntax into json objects. I don't do any
parsing my self, the glory for that belongs [logic-tptp]. Please ensure you
have installed alex and happy.

## status

* just a small wrapper around [logic-tptp]
* code was used once in a course
* there are no tests
* only fol is supported

## example

    $ dist/build/tptp-to-json/tptp-to-json example/SYN320+1.p

    [
        {
            "name":"church_46_3_1",
            "type":"conjecture",
            "formula":{
                "type":"quantor",
                "op":"?",
                "variables":[
                    {
                        "type":"variable",
                        "name":"Z"
                    },
                    {
                        "type":"variable",
                        "name":"X"
                    }
                ],
                "formula":{
                    "type":"quantor",
                    "op":"!",
                    "variables":[
                        {
                            "type":"variable",
                            "name":"Y1"
                        },
                        {
                            "type":"variable",
                            "name":"Y2"
                        }
    ...


## installation

    $ git clone https://github.com/slomo/tptp-to-json.git
    $ cd tptp-to-json
    $ cabal configure
    $ cabal build
    <wait almost for ever>

[logic-tptp]: http://hackage.haskell.org/package/logic-TPTP "logic-tptp from hackage"
