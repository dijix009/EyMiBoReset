enum BreakState {
    case idle
    case countdownToBreak
    case preBreak
    case breakActive
    case countdownToResume
    case snoozed

    // C: smart-paused due to detected context (meeting, recording, etc.)
    case paused
}
