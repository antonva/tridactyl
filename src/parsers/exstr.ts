import { Parser } from "../nearley_utils"
import * as exstr_grammar from "../grammars/.exstr.generated"

const exstr_parser = new Parser(exstr_grammar)

export function parseExStr(inputStr) {
    return exstr_parser.feedMe(inputStr)
}
