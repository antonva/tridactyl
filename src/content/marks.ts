/** Local and global marks.
    TODO: wax poetic about marks.
    Global marks should live in the background state.
    Local marks should live in the content state.
    On tabclose, purge global marks with that tabid, consider storing something like { id: 1337, mark: mark }
 */

import state from "@src/state"

export function mark(markChar: string) {
    if (markChar.length == 1) {
        if (/[a-z]/.test(markChar)) {
            localMark(markChar)
        } else if (/[A-Z]/.test(markChar)) {
            globalMark(markChar)
        }
    }
}

export function localMark(markChar: string) {

}

export function globalMark(markChar: string) {

}

export function jumpToGlobalMark(markChar: string) {

}

export function jumpToLocalMark(markChar: string) {

}
