#@preprocessor typescript
@builtin "string.ne"

@{%
    const moo = require('moo')
    //import * as moo from 'moo'

    //TODO: Break lexer up into states to help options and arguments parsing.
    let lexer = moo.compile({
        ws:        /[ \t]+/,
        connector: ['|', ';'],
        colon:     ':',
        dash:      '-',
        eq:        '=',
        sq:        '\'',
        dq:        '"',
        number:     /0|[1-9][0-9]*/,
        word:      { match: /[^=^\s|^\n]+/, 
                     lineBreaks: false,
                   },
    })
%}

@lexer lexer

#Exstr                -> %colon:* unsigned_decimal:* Excmd (__ OptionsAndArgs):* (_ %connector _ Exstr):* {% (d) => {
#    return(d[0])
#    }
#%}
Exstr          -> Colon:* Count:* Excmd (__ ShortOption):*
Excmd          -> %word {% (d) => { return {type: 'excmd', value: d[0].value} }  %}
Colon          -> %colon {% (d) => {return null}%}
#OptionsAndArgs -> (Options | Args):+ {% (d) => {return d[0]} %}
Args           -> %word:+
#Options        -> (Option):+ {% (d) => { return d[0] } %}
#Option         -> ShortOption | LongOption #{% (d) => { return d[0] } %}
#LongOption     -> %dash %dash %word {% 
#                                        (d) => { 
#                                            return {
#                                                type: 'longopt',
#                                                value: d[2].value
#                                            } 
#                                        } 
#                                    %}
#                | %dash %dash %word %eq String {% 
#                                                    (d) => { 
#                                                        return d
#                                                        //return {
#                                                        //    type: 'longopt',
#                                                        //    value: d[2].value, 
#                                                        //    args: d[4][0].split(' ') 
#                                                        //} 
#                                                    }
#                                                %}
#
ShortOption     -> %dash %word {% 
                                    (d) => {
                                        console.log(d)
                                        if (d[1].value.length >1) {
                                            return {
                                                type: 'clusteredshortopt',
                                                value: d[1].value.split('')
                                            }
                                        } else if (d[1].value.length === 1) {
                                            return {
                                                type: 'shortopt',
                                                value: d[1].value
                                            }
                                        }
                                    } 
                                %}
                 | %dash [a-zA-Z] (__ %word):+ {% 
                                                (d, l, reject) => {
                                                    // We will not accept clustered shortopts with arguments.
                                                    if (d[1].value.length > 1) return reject
                                                    else {
                                                        return {
                                                            type: 'shortopt',
                                                            value: d[1].value,
                                                            args: d[2]
                                                        }
                                                    }
                                                }
                                            %}
#String          -> dqstring 
#                 | sqstring                               
#Colon           -> %colon {% (d) => { return null } %}
Count           -> %number {% (d) => { d[0].type = 'count'; return d[0] } %}
## 0 or more whitespace characters
_               -> %ws:* {% (d) => { return null } %}
## 1 or more whitespace characters
__              -> %ws:+ {% (d) => { return null } %}
