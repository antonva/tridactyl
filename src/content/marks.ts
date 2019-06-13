/** Local and global marks.
    TODO: wax poetic about marks.
    TODO: On tabclose, purge global marks with that tabid, consider storing something like { id: 1337, mark: mark }
    Global marks live in the background state.
    Local marks live in the content state.
 */

import * as DOM from "@src/lib/dom"
import * as webext from "@src/lib/webext"
import state from "@src/state"
import { contentState } from "@src/content/state_content"
import * as Messaging from "@src/lib/messaging"

// Initialize marks in their respective states.
contentState.localMarks = {}

export function setLocalMark(markChar: string): string {
    const anchors = DOM.anchors()
    const markElement = anchors.reduce(topElementReducer)
    contentState.localMarks[markChar] = markElement
    return `Local mark ${markChar} set.`
}

export async function setGlobalMark(markChar: string): Promise<string> {
    const id = await webext.activeTabId
    const anchors = DOM.anchors()
    const markElement = anchors.reduce(topElementReducer)
    state.globalMarks[markChar] = {id: id, element: markElement}
    return "Global mark ${markChar} set."
}

export async function jumpToGlobalMark(markChar: string) {
    const m = state.globalMarks[markChar]
    webext.browserBg.tabs.update(m["id"], {active: true})
    m["element"].scrollIntoView()
}

export function jumpToLocalMark(markChar: string) {
    const m = contentState.localMarks[markChar]
    m.scrollIntoView()
}

function topElementReducer(a: HTMLElement, b: HTMLElement): HTMLElement {
    const arect = a.getBoundingClientRect()
    const brect = b.getBoundingClientRect()

    if (brect.top < arect.top) {
        return b
    }
    return a
}

function deleteMarks(marks: string) {
    if (marks === "!") {
        state.globalMarks = {}
        contentState.localMarks = {}
    } else {
    }
}
