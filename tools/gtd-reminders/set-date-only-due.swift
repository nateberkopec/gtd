#!/usr/bin/env swift
import EventKit
import Foundation

guard CommandLine.arguments.count >= 3 else {
    fputs("Usage: set-date-only-due.swift <reminder_id> <YYYY-MM-DD>\n", stderr)
    exit(1)
}

let reminderID = CommandLine.arguments[1]
let dueDateString = CommandLine.arguments[2]

let formatter = DateFormatter()
formatter.locale = Locale(identifier: "en_US_POSIX")
formatter.timeZone = TimeZone.current
formatter.dateFormat = "yyyy-MM-dd"

guard let dueDate = formatter.date(from: dueDateString) else {
    fputs("Invalid due date format: \(dueDateString)\n", stderr)
    exit(1)
}

let store = EKEventStore()
let semaphore = DispatchSemaphore(value: 0)
var accessGranted = false
var accessError: Error?

store.requestFullAccessToReminders { granted, error in
    accessGranted = granted
    accessError = error
    semaphore.signal()
}
semaphore.wait()

if let error = accessError {
    fputs("Reminders access error: \(error)\n", stderr)
    exit(1)
}
if !accessGranted {
    fputs("Reminders access denied\n", stderr)
    exit(1)
}

// Fetch reminder by searching all reminders (calendarItem doesn't see newly created items from other processes)
func fetchReminder(id: String, store: EKEventStore) -> EKReminder? {
    let calendars = store.calendars(for: .reminder)
    let predicate = store.predicateForReminders(in: calendars)
    var found: EKReminder? = nil
    let fetchSemaphore = DispatchSemaphore(value: 0)
    
    store.fetchReminders(matching: predicate) { reminders in
        found = reminders?.first { $0.calendarItemIdentifier == id }
        fetchSemaphore.signal()
    }
    fetchSemaphore.wait()
    return found
}

var reminder: EKReminder? = nil
for _ in 0..<10 {
    if let r = fetchReminder(id: reminderID, store: store) {
        reminder = r
        break
    }
    Thread.sleep(forTimeInterval: 0.2)
}

guard let reminder else {
    fputs("Reminder not found: \(reminderID)\n", stderr)
    exit(1)
}

// Set date components WITHOUT hour/minute - this makes it "all day"
let calendar = Calendar.current
var components = calendar.dateComponents([.year, .month, .day], from: dueDate)
components.timeZone = calendar.timeZone
reminder.dueDateComponents = components

do {
    try store.save(reminder, commit: true)
} catch {
    fputs("Failed to save: \(error)\n", stderr)
    exit(1)
}
