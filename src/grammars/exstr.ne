@builtin "number.ne"
@builtin "string.ne"

#Exstr -> MultiColon:* Count:* Excmd (__ OptionsAndArgs):* (__ Pipe Exstr):* (_ ";" Exstr):*
#Excmd -> Word
#OptionsAndArgs -> (Options | Args):+
#Args -> (Words | String):+
#Options -> (Option):+
#Option -> ShortOption | ClusteredShortOption | LongOption
LongOption -> "--" Word "=" String
ClusteredShortOption -> "-" Word
ShortOption -> "-" AlphaNum (Wschar Words):*
MultiColon -> Colon:+
Colon -> ":"
Pipe -> "|"
Words -> Word:+
Word -> AlphaNum:+
String -> dqstring | sqstring
Count -> Digit:+
AlphaNum -> Letter | Digit
# Needs to handle more than this but this is good enough right now.
Letter -> [a-zA-Z]
Digit -> [0-9]
_ -> Wschar:* {% (d) => { return null } %}
__ -> Wschar:+ {% (d) => { return null } %}
Wschar -> [\t ] {% id %}
