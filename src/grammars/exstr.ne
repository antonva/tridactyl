#@preprocessor typescript
@builtin "string.ne"

@{%
    const moo = require('moo')
    //import * as moo from 'moo'

    //TODO: Break lexer up into states to help options and arguments parsing.
    let lexer = moo.compile({
        WS:        /[ \t]+/,
        CONNECTOR: ['|', ';'],
        COLON:     ':',
        DASH:      '-',
        EQ:        '=',
        //SQ:        '\'',
        //DQ:        '"',
        NUMBER:     /0|[1-9][0-9]*/,
        STRING:    [
            {match: /"(?:\\["\\rn]|[^"\\\n])*?"/, value: x => x.slice(1, -1)},
            {match: /'(?:\\['\\rn]|[^'\\\n])*?'/, value: x => x.slice(1, -1)},
        ],
        WORD:      { match: /[^=^\s|^\n]+/, 
                     lineBreaks: false,
                   },
    })

    const processLongOptionNoArgs = (d) => {
        return {
            type: 'longopt',
            value: d[2].value
        } 
    }

    const processLongOptionWithArgs = (d) => {
        //return d
        return {
            type: 'longopt',
            value: d[2].value, 
            args: d[4][0].split(' ') 
        } 
    }

    const processShortOptNoArgs = (d) => {
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
    
    const processShortOptWithArgs = (d, l, reject) => {
        // We will not accept clustered shortopts with arguments.
        if (d[1].value.length > 1) {
            return reject
        } else {
            return {
                type: 'shortopt',
                value: d[1].value,
                args: d[3][0].value
            }
        }
    }

    const processArgs = (d) => {
        let returnObj = { type: 'args', value: [] }
        for (let val of d[0]) {
            returnObj.value.push(val[0].value)
        }
        return returnObj
    }
%}

@lexer lexer

#Exstr                -> %colon:* unsigned_decimal:* Excmd (__ OptionsAndArgs):* (_ %connector _ Exstr):* {% (d) => {
#    return(d[0])
#    }
#%}
Exstr          -> Colon:* Count:* Excmd _ OptionsAndArgs
Excmd          -> %WORD {% (d) => { return {type: 'excmd', value: d[0].value} }  %}
Colon          -> %COLON {% (d) => {return null}%}
OptionsAndArgs -> (Options | Args):* {% (d) => {return d[0]} %}
Args           -> (%WORD _):+                          {% (d) => processArgs(d) %}
Options        -> (Option _):+                         {% (d) => { return d[0] } %}
Option         -> ShortOption | LongOption             {% (d) => { return d[0] } %}
LongOption     -> %DASH %DASH %WORD                    {% (d) => processLongOptionNoArgs(d) %}
                | %DASH %DASH %WORD %EQ %STRING        {% (d) => processLongOptionWithArgs(d) %}
ShortOption    -> %DASH %WORD                          {% (d) => processShortOptNoArgs(d) %}
                | %DASH [a-zA-Z] __ (%WORD | %STRING)  {% (d,l, reject) => processShortOptWithArgs(d, l, reject) %}
Colon          -> %COLON                               {% (d) => { return null } %}
Count          -> %NUMBER                              {% (d) => { d[0].type = 'count'; return d[0] } %}
# 0 or more whitespace characters
_              -> %WS:*                                {% (d) => { return null } %}
# 1 or more whitespace characters
__             -> %WS:+                                {% (d) => { return null } %}
