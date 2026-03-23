# Remesh Take-Home - Rails 8 Implementation Brief for Claude Code / Codex

## Purpose

Build a **small, server-rendered Ruby on Rails 8 application** for the Remesh take-home challenge.

This brief is intentionally optimized for an LLM coding agent. It is designed to maximize the odds of producing a submission that:

- fully satisfies the prompt requirements,
- looks like the work of a **senior backend software engineer**,
- stays **simple first**,
- uses **Rails conventions**,
- includes a **thorough test suite**,
- and lays down **lightweight scalable patterns** without overengineering.

The target is a clean, correct, reviewable implementation that can reasonably be completed in a **2-4 hour take-home window**.

---

## Source Requirements Extracted From the PDF

The application must support the following:

### Application requirements
- Create a **conversation** with required fields:
  - `title`
  - `start_date`
- Create **messages** for a conversation with required fields:
  - `text`
  - `date_time_sent`
- Create **thoughts** for a message with required fields:
  - `text`
  - `date_time_sent`
- View a list of conversations.
- Click a conversation and view that conversation's messages and all thoughts for each message.
- View the thoughts for each message in a conversation.
- Search conversations by title.
- Search messages by content.

### Technical requirements
- Use **Ruby on Rails**.
- Use a **relational database**.
- Include a **comprehensive test suite** covering main features and reasonable edge cases.
- Submit a **single repository**.

### Evaluation requirements
- The README must contain **clear, step-by-step local setup instructions**.
- If AI coding tools are used, the README must include:
  - how AI was used,
  - prompt examples,
  - and challenges encountered.
- Styling is **not** part of the evaluation.
- Reviewers will evaluate:
  - whether the app runs locally from the README,
  - whether requirements are met,
  - whether the code is readable, efficient, and well-structured,
  - whether database relationships are modeled properly,
  - and whether the test suite is comprehensive.

---

## Product and Engineering Strategy

### Primary goal
Deliver the **smallest clean Rails 8 app** that completely satisfies the challenge requirements.

### Secondary goal
Make implementation choices that signal **senior backend engineering judgment**, especially around:
- clear domain modeling,
- conventional Rails structure,
- testability,
- transactional data integrity,
- sensible indexes and validations,
- maintainable code organization,
- and lightweight event-driven patterns that can scale later.

### Deliberate tradeoff
Prefer:
- simplicity,
- correctness,
- readability,
- and complete test coverage

Over:
- ambitious architecture,
- premature abstractions,
- fancy frontend work,
- or heavy infrastructure.

### Non-goals
Do **not** add:
- authentication,
- authorization,
- users,
- APIs unless needed for internal architecture,
- JavaScript-heavy frontend patterns,
- websockets,
- background processing infrastructure beyond what Rails already provides,
- or speculative microservice/event-bus complexity.

This should look like a polished, thoughtful, monolithic Rails app.

---

## Required Stack and Constraints

Use the following stack unless there is a compelling reason not to:

- **Ruby on Rails 8**
- **PostgreSQL**
- **Server-rendered MVC with ERB**
- **RSpec**
- **FactoryBot**
- **Request specs**
- **System specs**
- **Model specs**
- **Service specs**
- **Job / instrumentation specs where applicable**

Use Rails defaults and conventions wherever possible.

Avoid introducing unnecessary dependencies.

---

## Implementation Philosophy

Build this as a senior backend engineer would:

1. **Get the core domain right.**
2. **Keep controllers thin.**
3. **Use models for relationships and validations.**
4. **Use service objects for creation workflows if they add clarity.**
5. **Wrap multi-record write flows in transactions.**
6. **Use lightweight asynchronous/event patterns that are easy to extend later.**
7. **Test every important layer.**
8. **Keep the UI intentionally plain but clear.**
9. **Optimize the README for a reviewer following it line-by-line.**
10. **Leave the codebase cleaner than a rushed take-home normally would be.**

---

## Recommended Domain Model

Use the simplest correct domain model:

### Conversation
- has many messages
- attributes:
  - `title` (required)
  - `start_date` (required)

### Message
- belongs to conversation
- has many thoughts
- attributes:
  - `text` (required)
  - `date_time_sent` (required)

### Thought
- belongs to message
- attributes:
  - `text` (required)
  - `date_time_sent` (required)

### Relationship expectations
- Deleting a conversation should not leave orphaned messages.
- Deleting a message should not leave orphaned thoughts.
- Prefer `dependent: :destroy` unless there is a very strong reason otherwise.

### Database expectations
Use real foreign keys, not just model associations.

Add indexes for:
- foreign keys,
- ordering fields used in UI,
- and search-relevant fields where reasonable.

Keep indexing practical. Do not overengineer search infrastructure for this challenge.

---

## Search Expectations

Implement the two required search features clearly and simply. Put an emphasis on secure practices around handling user input and sanitizing input. The search boxes should handle common OWASP security practices. 

### Conversation search
- Search by `title`
- Use a simple query parameter driven flow, for example from the conversations index page
- Prefer case-insensitive partial matching

### Message search
- Search messages by `text`
- Present results in a way that clearly shows the matching message and its parent conversation
- Prefer case-insensitive partial matching

### Recommended simplicity-first approach
Use simple ActiveRecord scopes backed by SQL `ILIKE` in PostgreSQL.

That is enough for the take-home.

Use trigram/full-text indexing as part of the initial setup. We want the search capabilities to scale. Do not worry about replication or sharding techniques on the initial build, but you can talk about them as natural follow-ups and production hardening techniques
---

## UI / Page Expectations

Keep the UI server-rendered, minimal, and easy to follow.
The style should be inviting, clean, and professional

At minimum, include pages/flows for:

### Conversations index
- list all conversations
- search conversations by title
- link to create a conversation
- link to each conversation show page
- optionally surface a link to message search

### Conversation new
- form to create a conversation

### Conversation show
- show conversation details
- show messages for that conversation
- for each message, show all associated thoughts
- include a form or link to create a message
- include a form or link to create a thought for a given message

### Message creation
- create a message under a conversation

### Thought creation
- create a thought under a message

### Message search page
- search messages by text
- show results with enough context to understand where the message belongs

The UI should be plain but coherent.

Do not spend time on advanced styling. A clean layout, clear headings, flash messages, and readable forms are enough.

---

## Rails Architecture Guidance

### Routing
Use conventional RESTful routes.

A good direction is:
- `resources :conversations, only: [:index, :show, :new, :create]`
- nested `messages` under conversations for creation
- nested `thoughts` under messages for creation, or another equally clear conventional approach
- one dedicated route/page for message search

Choose the cleanest conventional route design and stay consistent.

### Controllers
Keep controllers thin.

Controllers should mainly:
- load records,
- authorize inputs through strong params,
- call a service object where helpful,
- handle success/failure flows,
- and render/redirect clearly.

### Models
Use models for:
- associations,
- validations,
- scopes,
- and small domain-level conveniences.

Avoid putting controller-ish orchestration into models.

### Services
Use service objects where they improve clarity, especially for record creation flows.

Examples:
- `Conversations::Creator`
- `Messages::Creator`
- `Thoughts::Creator`

Service objects should:
- be small,
- be explicit,
- return a clear success/failure contract,
- and use transactions when needed.

If the flow is truly trivial, do not force unnecessary abstraction. But a consistent service layer for creation is acceptable and aligns with the desired architecture.

---

## Lightweight Scalable Messaging Pattern

Use a **light**, Rails-native pattern that shows scalable thinking without overengineering:

### Desired pattern
- perform writes through normal Rails flows,
- publish domain events after commit,
- instrument via `ActiveSupport::Notifications`,
- and fan out lightweight async work using `ActiveJob`.

### Good example
When a conversation, message, or thought is created:
- the record is persisted,
- an `after_commit` hook publishes a namespaced event,
- a subscriber or listener may enqueue a job or log structured instrumentation.

### Why this is useful
This shows:
- awareness of post-commit correctness,
- separation between write path and side effects,
- and a path to future scaling,

without introducing outbox/event-bus complexity.

### Important boundary
Do **not** let this pattern become the main focus of the challenge.

It should be lightweight and tasteful. The app's primary value is still the working CRUD/search functionality and the test suite.

### Suggested implementation shape
- Use an `after_commit` callback on create to publish events like:
  - `conversations.created`
  - `messages.created`
  - `thoughts.created`
- Use `ActiveSupport::Notifications.instrument`
- Add a simple subscriber/handler and one or more tiny jobs for demonstration value
- Keep side effects non-critical, such as logging, audit-style instrumentation, or metrics-ready hooks

This should signal senior engineering judgment, not architecture theater.

---

## Data Integrity and Validation Guidance

At minimum:

### Conversation validations
- `title` present
- `start_date` present

### Message validations
- `conversation` present
- `text` present
- `date_time_sent` present

### Thought validations
- `message` present
- `text` present
- `date_time_sent` present

### Optional niceties
Reasonable length validations are acceptable if they do not create unnecessary risk.

Do not invent business rules that are not in the prompt.

### Transactions
Use transactions for create flows when helpful, especially if event publication or side-effect setup is involved.

### Query hygiene
Avoid N+1 issues on the conversation show page. Preload what you render.

---

## Testing Expectations

The test suite should be one of the strongest parts of the submission.

The reviewers explicitly care about it.

### Test strategy
Cover the app at multiple layers:

#### Model specs
Test:
- associations
- validations
- search scopes
- dependent behavior if relevant

#### Service specs
Test creation services for:
- success cases
- validation failure cases
- transaction behavior if applicable
- event/instrumentation behavior if applicable

#### Request specs
Test key HTTP flows:
- conversations index
- conversation create
- conversation show
- message create
- thought create
- conversation search
- message search
- invalid submission handling

#### System specs
Test end-to-end user behavior:
- create conversation
- create message in a conversation
- create thought for a message
- view nested message/thought hierarchy
- search conversations
- search messages

#### Job / notification specs
Test that the instrumentation/event hooks actually fire in a reliable way.

These tests can be small but should prove the messaging pattern is real.

### Test quality bar
Tests should be:
- readable,
- deterministic,
- focused on behavior,
- and not overly coupled to implementation details.

Prefer a smaller number of excellent tests over a bloated suite full of repetition, but still ensure comprehensive coverage of the main flows and reasonable edge cases. Usw simplecov gem to ensure test coverage above 95%

### Factories
Use `FactoryBot` consistently.

Prefer factories and traits over noisy fixture-style setup.

---

## README Requirements

The README is a first-class deliverable.

Write it for a reviewer who will literally copy commands line-by-line.

### README must include
- project overview
- chosen stack
- Ruby version
- PostgreSQL requirement
- exact local setup steps
- database setup steps
- how to run the app
- how to run the test suite
- any assumptions made
- any tradeoffs made
- a short architecture overview
- a section describing the event/instrumentation pattern
- and an explicit **AI usage** section

### Setup instructions should be extremely explicit
Include commands for things like:
- cloning the repo
- installing dependencies
- database creation/migration
- starting the Rails server
- running specs

Minimize ambiguity.

### AI usage section
Because the submission instructions require it, include a dedicated section such as:
- whether AI was used
- what tasks AI helped with
- what prompts or prompt categories were used
- representative prompt examples
- where human judgment overrode AI output
- challenges encountered while using AI

This section should be honest, concrete, and reviewer-friendly.

---

## Implementation Priorities

Follow this order of operations:

1. Create the domain models, migrations, validations, associations, and indexes.
2. Implement conventional routes/controllers/views for the required flows.
3. Add search for conversations and messages.
4. Add service objects for creation workflows where useful.
5. Add post-commit notification publishing and a lightweight subscriber/job example.
6. Add thorough automated tests at every layer.
7. Polish the README.
8. Do one final pass for readability, naming, and reviewer experience.

This order matters. Finish the challenge before polishing architecture.

---

## Coding Style Expectations

The resulting code should feel boring in the best possible way.

Prioritize:
- descriptive names,
- small methods,
- thin controllers,
- conventional Rails structure,
- cohesive POROs,
- and readable tests.

Avoid:
- meta-programming,
- clever abstractions,
- giant service objects,
- callback-heavy business logic,
- or unusual gems unless truly necessary.

If you add comments, keep them sparse and useful.

---

## Suggested Deliverables in the Repo

Aim for a repo that contains:
- Rails 8 app
- PostgreSQL configuration
- domain models and migrations
- MVC views/controllers/routes for the required flows
- service objects where appropriate
- lightweight notification/job infrastructure
- comprehensive RSpec suite
- clean README

A seed file is optional but may help reviewer usability.

---

## Explicit Acceptance Criteria

Before stopping, ensure the repo supports all of the following:

- A user can create a conversation with `title` and `start_date`.
- A user can view all conversations.
- A user can click into a conversation.
- A user can create a message for that conversation with `text` and `date_time_sent`.
- A user can create a thought for a message with `text` and `date_time_sent`.
- A user can view messages and thoughts within the conversation page.
- A user can search conversations by title.
- A user can search messages by content.
- The app uses PostgreSQL.
- The repo includes a comprehensive automated test suite.
- The README contains exact setup instructions.
- The README contains an AI usage section with prompt examples and challenges.

---

## Senior Backend Engineer Signals To Emphasize

Without making the solution too complex, bias toward choices that communicate seniority:

- proper relational modeling and foreign keys
- thin controllers and clean domain boundaries
- preload associations where rendered
- conventional route design
- clean service object usage where valuable
- post-commit instrumentation instead of inline side effects
- thoughtful tests at multiple layers
- clear tradeoff notes in the README
- restrained scope discipline

A reviewer should come away thinking:

> This person knows how to ship a clean Rails app, model data correctly, test thoroughly, and make sound architectural tradeoffs.

---

## Final Instruction To The Coding Agent

Build the simplest polished version that fully meets the challenge.

Do not chase unnecessary complexity.

Complete the requirements, make the code easy to review, test the important flows thoroughly, and leave behind a README that makes local setup nearly impossible to get wrong.

---

## Self-Check Checklist

Do not stop until you can honestly answer **yes** to each item below.

### Requirements coverage
- [ ] Can a conversation be created with `title` and `start_date`?
- [ ] Can a message be created for a conversation with `text` and `date_time_sent`?
- [ ] Can a thought be created for a message with `text` and `date_time_sent`?
- [ ] Can all conversations be viewed?
- [ ] Can a conversation be viewed with its messages and each message's thoughts?
- [ ] Can conversations be searched by title?
- [ ] Can messages be searched by content?

### Technical expectations
- [ ] Is this a Rails 8 application?
- [ ] Does it use PostgreSQL?
- [ ] Are database relationships modeled with foreign keys and proper associations?
- [ ] Are controllers thin and reasonably conventional?
- [ ] Are N+1 risks addressed on the conversation show page?

### Messaging / architecture expectations
- [ ] Are create flows clean and readable?
- [ ] Is there a lightweight `after_commit` + `ActiveSupport::Notifications` pattern in place?
- [ ] Is any async work kept intentionally light and non-critical?
- [ ] Did you avoid overengineering?

### Testing expectations
- [ ] Are there model specs?
- [ ] Are there request specs?
- [ ] Are there system specs?
- [ ] Are there service specs where services are used?
- [ ] Are notification/job behaviors tested if implemented?
- [ ] Do tests cover both happy paths and reasonable invalid cases?

### Reviewer experience
- [ ] Does the README contain exact setup steps?
- [ ] Does the README explain how to run the app?
- [ ] Does the README explain how to run tests?
- [ ] Does the README include assumptions and tradeoffs?
- [ ] Does the README include a concrete AI usage section with prompt examples and challenges?

### Final quality check
- [ ] Is the code readable and well structured?
- [ ] Does the solution feel intentionally simple rather than incomplete?
- [ ] Would a reviewer likely be able to run this locally without confusion?
- [ ] Does this submission look like the work of a thoughtful senior backend engineer operating under time constraints?
