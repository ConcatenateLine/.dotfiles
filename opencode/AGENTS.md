# Context7

Always use context7 when I need code generation, setup or configuration steps, or
library/API documentation. This means you should automatically use the Context7 MCP
tools to resolve library id and get library docs without me having to explicitly ask.

## Task Creation Template for Asana

This template is optimized for creating tasks in Asana projects.
Review the Asana Integration for get the current project name.

### Standard Template Structure

When creating tasks in Asana projects, use this optimized format:

#### Task Name Format

- **Clean action/feature names**
- Examples: "Implement drag and drop", "Enable keyboard shortcuts", "Create task filtering"
- **AVOID:** "User story:", "US-001:", "Feature:" prefixes

#### Custom Fields

- **Story Points Field ID:** `1212469928332185`
- **TASK1 Field ID:** `1212469928332179` (auto-generated, read-only)

### Story Points & Time Duration

#### Recommended Story Points

| Story Points | Time Duration | Complexity | Example Tasks |
|-------------|---------------|-------------|----------------|
| 1 | 1-2 hours | Simple bug fixes, text changes | "Fix typo", "Update label" |
| 2 | 3-4 hours | Minor features, simple logic | "Add validation", "Style updates" |
| 3 | 5-8 hours | Standard features, moderate complexity | "Add filtering", "Basic CRUD" |
| 5 | 10-16 hours | Complex features, multiple components | "User authentication", "File upload" |
| 8 | 17-24 hours | Very complex, integrations | "Payment gateway", "Advanced filtering" |
| 13 | 25-40 hours | Epic-level, major feature sets | "Complete redesign", "New module" |

#### Due Date Calculation

**Formula:** `Due Date = Today + (Story Points × 2 business days)`

**IMPORTANT:** Always set due_on parameter when creating tasks

Examples:

- **1 point:** Due in 2 days
- **2 points:** Due in 4 days
- **3 points:** Due in 6 days  
- **5 points:** Due in 10 days
- **8 points:** Due in 16 days

#### Due Date Implementation

When creating tasks with story points, automatically calculate and set:

```bash
due_date = today + (story_points × 2 business days)
```

### Quick Reference

#### Common Task Patterns

1. **Simple Tasks (1-2 points):** Bug fixes, text updates, minor UI changes
2. **Standard Features (3-5 points):** New components, basic functionality
3. **Complex Features (5-8 points):** Multi-component features, integrations
4. **Epics (8+ points):** Major features requiring multiple sprints

#### Template Examples

```
# Task Template

## Task Name
- Short, action-oriented, technical description  
- Example: "Implement password reset mutation"

## Task Description
- Clear explanation of what needs to be done technically  
- Example: Implement a GraphQL mutation in NestJS that allows users to reset their password.

## Acceptance Criteria
- [ ] Mutation rejects invalid/expired tokens  
- [ ] Mutation updates password successfully with valid token  
- [ ] Mutation triggers confirmation email  

## Technical Notes 
- Use Prisma for token storage with expiration  
- Configure SMTP service for email delivery  
- Follow project’s error response format (no stacktrace)

## Test Cases
- Should fail if token is invalid  
- Should fail if token is expired  
- Should succeed with valid token  
- Should send confirmation email  

## Story Points
- Estimate effort (1, 2, 3, 5, 8, 13)  
- Example: 3 points (~6 business days)

## Due Date
- Formula: `today + (story_points × 2 business days)`  
- Example: Due in 6 business days

## Linked Story
- Example: US-123

## Priority
- P1 = High (critical path, must be done first) 
- P2 = Medium (important but not blocking) 
- P3 = Low (nice-to-have, can wait)
- Pn...
- Example: High (P1) 

## Dependencies 
- Blocked By = hard stop → you cannot move forward until the other task is complete.
- Depends On = soft dependency → you can start, but completion or correctness relies on another task.
- Example: Blocked by: Implement user schema 
- Example: Depends on: Configure SMTP service

```

### Usage with Opencode

Just tell me: "Create task: [name] with [X] story points" and I'll generate the complete task using this template structure.

## User Story Template

#### User Story Notes Format

```
As a user, I want to [goal] so that [benefit]

Acceptance Criteria:
- [specific requirement 1]
- [specific requirement 2]
- [specific requirement 3]

Technical Notes: [implementation details]
```
