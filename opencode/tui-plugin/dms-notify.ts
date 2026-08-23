import { spawn } from "node:child_process"
import type { TuiPlugin, TuiPluginModule } from "@opencode-ai/plugin/tui"

const APP_NAME = "opencode"

type SessionLike = {
  title?: string
  parentID?: string
}

type PermissionEvent = {
  properties: {
    id: string
    sessionID: string
    permission?: string
    metadata?: Record<string, unknown>
  }
}

type QuestionEvent = {
  properties: {
    id: string
    sessionID: string
  }
}

type SessionStatusEvent = {
  properties: {
    sessionID: string
    status: { type: "busy" | "retry" | "idle" | (string & {}) }
  }
}

type SessionErrorEvent = {
  properties: {
    sessionID?: string
    error?: {
      name?: string
      data?: Record<string, unknown>
    }
  }
}

function errorMessage(error: SessionErrorEvent["properties"]["error"]): string {
  if (error?.name === "MessageAbortedError") return "Session aborted"
  const data = error?.data
  if (data && typeof data === "object" && "message" in data && data.message === "SSE read timed out") {
    return "Model stopped responding"
  }
  return "Session error"
}

function permissionLabel(event: PermissionEvent): string {
  const tool = event.properties.metadata
  if (tool && typeof tool === "object" && "tool" in tool && typeof tool.tool === "string") {
    return `Permission needs input (${tool.tool})`
  }
  if (event.properties.permission) return `Permission needs input (${event.properties.permission})`
  return "Permission needs input"
}

const tui: TuiPlugin = async (api) => {
  let focused: boolean | null = null

  api.renderer.on("focus", () => {
    focused = true
  })
  api.renderer.on("blur", () => {
    focused = false
  })

  function send(title: string, message: string) {
    if (focused !== false || api.lifecycle.signal.aborted) return
    try {
      spawn("dms", ["notify", title, message, "--app", APP_NAME], {
        stdio: "ignore",
      }).on("error", () => {})
    } catch {}
  }

  function title(sessionID: string): string {
    const session = api.state.session.get(sessionID) as SessionLike | undefined
    return session?.title?.trim() || APP_NAME
  }

  const questions = new Set<string>()
  const permissions = new Set<string>()
  const active = new Set<string>()
  const errored = new Set<string>()

  api.event.on("question.asked", (event: QuestionEvent) => {
    if (questions.has(event.properties.id)) return
    questions.add(event.properties.id)
    send(title(event.properties.sessionID), "Question needs input")
  })

  api.event.on("question.replied", (event) => {
    questions.delete(event.properties.requestID)
  })
  api.event.on("question.rejected", (event) => {
    questions.delete(event.properties.requestID)
  })

  api.event.on("permission.asked", (event: PermissionEvent) => {
    if (permissions.has(event.properties.id)) return
    permissions.add(event.properties.id)
    send(title(event.properties.sessionID), permissionLabel(event))
  })

  api.event.on("permission.replied", (event) => {
    permissions.delete(event.properties.requestID)
  })

  api.event.on("session.status", (event: SessionStatusEvent) => {
    const sessionID = event.properties.sessionID
    if (event.properties.status.type === "busy" || event.properties.status.type === "retry") {
      active.add(sessionID)
      errored.delete(sessionID)
      return
    }
    if (event.properties.status.type !== "idle") return
    if (!active.has(sessionID)) return
    active.delete(sessionID)
    if (errored.has(sessionID)) {
      errored.delete(sessionID)
      return
    }
    const session = api.state.session.get(sessionID) as SessionLike | undefined
    send(title(sessionID), session?.parentID ? "Subagent done" : "Session done")
  })

  api.event.on("session.error", (event: SessionErrorEvent) => {
    const sessionID = event.properties.sessionID
    if (!sessionID) return
    if (!active.has(sessionID)) return
    errored.add(sessionID)
    send(title(sessionID), errorMessage(event.properties.error))
  })
}

const plugin: TuiPluginModule & { id: string } = {
  id: "dms-notify",
  tui,
}

export default plugin
