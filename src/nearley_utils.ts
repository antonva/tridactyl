import * as nearley from "nearley"

/** Friendlier interface around nearley parsers */
export class Parser {
    private parser
    private initial_state
    /* public results */

    constructor(grammar) {
        this.parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammar))
        this.initial_state = this.parser.save()
        /* this.results = this.parser.results */
    }

    feedUntilError(input) {
        let lastResult = undefined
        let consumedIndex = 0
        try {
            for (let val of input) {
                this.parser.feed(val)
                lastResult = this.parser.results[0]
                consumedIndex++
            }
        } catch (e) {
        } finally {
            this.reset()
            if (lastResult === undefined) {
                throw "Error: no result!"
            } else {
                return [lastResult, input.slice(consumedIndex)]
            }
        }
    }

    feedMe(input) {
        let lastResult
        try {
            this.parser.feed(input)
            lastResult = this.parser.results[0]
        } catch (e) {
        } finally {
            this.reset()
            if (lastResult === undefined) {
                throw "Error: no result!"
            } else {
                return lastResult
            }
        }
    }

    private reset() {
        this.parser.restore(this.initial_state)
    }

    /* feed(input) { */
    /*     return this.parser.feed(input) */
    /* } */
}
