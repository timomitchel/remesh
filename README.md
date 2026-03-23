# Remesh Take-Home

A server-rendered Rails 8 app for managing conversations, messages, and thoughts with full-text search. Built as a take-home project demonstrating conventional Rails MVC with a service layer, event-driven instrumentation, and thorough test coverage.

---

## Stack

| Layer | Technology |
|-------|-----------|
| Language | Ruby 3.3.0 |
| Framework | Rails 8.1.2 |
| Database | PostgreSQL 16 |
| CSS | Tailwind CSS v4 |
| Testing | RSpec 8, FactoryBot, shoulda-matchers |
| Coverage | SimpleCov |

---

## Prerequisites

- **Ruby 3.3.0** — recommend [rbenv](https://github.com/rbenv/rbenv) or [asdf](https://asdf-vm.com/)
- **PostgreSQL 16+** — must be running locally
- **Chrome or Chromium** — required for system (feature) tests

---

## Setup Instructions

```bash
git clone <repo-url>
cd remesh
bundle install
bin/rails db:create db:migrate
bin/rails db:seed    # optional — loads demo data to explore search
bin/dev              # starts Rails server + Tailwind CSS watcher
```

Visit [http://localhost:3000](http://localhost:3000)

---

## Running Tests

```bash
bundle exec rspec                    # full suite
COVERAGE=true bundle exec rspec      # with SimpleCov HTML coverage report
bundle exec rspec spec/models        # model layer only
bundle exec rspec spec/requests      # controller/request specs
bundle exec rspec spec/system        # end-to-end browser specs (Capybara + Chrome)
bundle exec rspec spec/services      # service object specs
bundle exec rspec spec/jobs          # ActiveJob specs
bundle exec rspec spec/subscribers   # event subscriber specs
```

Coverage report is written to `coverage/index.html` when `COVERAGE=true` is set.

---

## Architecture Overview

```mermaid
graph LR
    Browser -->|HTTP| Routes
    Routes --> Controllers
    Controllers --> Services
    Services --> Models
    Models --> PostgreSQL

    Models -->|after_commit| Notifications["ActiveSupport::Notifications"]
    Notifications --> DomainEventSubscriber
    DomainEventSubscriber --> EventLogJob
    EventLogJob -->|async log| PostgreSQL
```

### Design Principles

- **Thin controllers** — controllers authenticate params, call a service, and redirect or render. No business logic.
- **Service objects** — `Conversations::Creator`, `Messages::Creator`, and `Thoughts::Creator` encapsulate creation logic and return a `ServiceResult` (success/failure + payload).
- **Models** — handle associations, validations, and search scopes (ILIKE with trigram indexes for case-insensitive partial-match search).
- **Server-rendered ERB views** with Tailwind CSS v4 utility classes. No JavaScript framework.

---

## Event / Instrumentation Pattern

```mermaid
sequenceDiagram
    participant C as Controller
    participant S as Service
    participant M as Model
    participant DB as PostgreSQL
    participant N as AS::Notifications
    participant Sub as DomainEventSubscriber
    participant J as EventLogJob

    C->>S: call(params)
    S->>M: create!(attrs)
    M->>DB: INSERT
    DB-->>M: commit
    M->>N: instrument("conversations.created", payload)
    N->>Sub: notify(event)
    Sub->>J: perform_later(event_data)
    J->>DB: log structured event
```

### How It Works

Each model includes the `Publishable` concern. After a successful database commit, `after_commit on: :create` fires and calls `ActiveSupport::Notifications.instrument` with a namespaced event name (e.g., `conversations.created`, `messages.created`, `thoughts.created`).

`DomainEventSubscriber` subscribes to these namespaced events at boot time and enqueues `EventLogJob` for each event. The job logs structured event data asynchronously.

**Key design decisions:**

- Events fire **only after a successful commit** — no phantom events on rolled-back transactions.
- The subscriber pattern is an **extension point**: adding webhooks, analytics pipelines, or push notifications requires only a new subscriber or job, not touching the models or controllers.
- Jobs are async by default; in test mode they run inline so specs can assert on side effects.

---

## Future Scaling Considerations

- **Search** — replace ILIKE/trigram with PostgreSQL `tsvector` full-text search or an external service (Elasticsearch, Typesense) for high cardinality data.
- **Event bus** — replace `ActiveSupport::Notifications` with Kafka or RabbitMQ for high-throughput, multi-consumer event processing.
- **Database** — read replicas for reporting queries, PgBouncer for connection pooling, table partitioning for large message/thought tables.
- **Pagination** — Pagy or Kaminari; currently all records are returned which is fine for demo scope but would need pagination in production.

---

## Assumptions & Tradeoffs

### Assumptions

- **No authentication/authorization** — single-user context per the brief.
- **No conversation end date** — conversations are open-ended.
- **No pagination** — dataset size is small enough for demo purposes.

### Tradeoffs

| Decision | Chosen | Alternative | Reason |
|----------|--------|-------------|--------|
| Search | ILIKE + trigram indexes | Full-text `tsvector` | Simpler setup, sufficient for demo |
| Creation logic | Service objects for all creates | Fat models or inline controllers | Consistency and testability over minimalism |
| Pagination | None | Pagy/Kaminari | Clean demo UX; would add in production |
| Event timing | `after_commit` | `after_create` / inline | Guarantees no phantom events on rollback |

---

## AI Usage

**Tools Used:** Claude Code (Anthropic's CLI agent) running the Claude Opus model.

### Process

The emphasis was on **planning over coding**. The project began with a structured, prompt-engineered brief document (`remesh_take_home_llm_brief.md`) that defined requirements, architecture, and acceptance criteria upfront. **6–7 iterations were spent in plan mode** before any code was written, including:

- Design spec creation with an automated review pass
- Architecture decision exploration (service objects, event patterns, search approach)
- File structure mapping
- Test strategy design
- Implementation plan broken into bite-sized TDD tasks

### Prompt Categories

1. **Architecture design** — service layer structure, event/instrumentation patterns
2. **Test design** — comprehensive specs at model, request, service, job, subscriber, and system layers
3. **Domain modeling** — schema with indexes, foreign keys, trigram search
4. **Automated review** — spec review loops to verify completeness and correctness

### Representative Prompts

- **Initial brief:** a structured markdown document defining all requirements (see `remesh_take_home_llm_brief.md`)
- **Design iteration:** "Does the domain model and database design look correct?"
- **Architecture decision:** "Which implementation approach — full services + events, selective services, or no services?"

### Human Judgment

- Chose Tailwind CSS over bare HTML for professional presentation
- Designed seed data to exercise and demonstrate search capabilities
- Added architecture diagrams (Mermaid) beyond the brief requirements
- Reviewed and approved each design section before allowing implementation to proceed

### Challenges

- Balancing thoroughness with simplicity — resisted gold-plating while still demonstrating senior engineering patterns
- Keeping the event pattern lightweight so it serves as a clear extension point rather than unnecessary complexity
- Managing the tension between "senior engineering signals" (service objects, event-driven design) and YAGNI

### Prompts

Below is the complete history of prompts sent to Claude Code across all sessions for this project, in chronological order.

**Session 1 — Initial build**

1. "Move this file: `/Users/timtyrrell/Downloads/remesh_take_home_llm_brief.md` into this directory, and begin implementing the plans in that file."
2. "Continue with max effort"
3. "Looks like you stopped, can you continue with the plan"
4. "For the create thought page, we should record the timestamp automatically on the backend. Remove anything related to the timestamp selection box on the frontend and update the specs accordingly."
5. "Sorry, lets revert the changes and allow the time to be an input, I see that the user should be able to input these fields on the requirements doc."
6. "Great, lets do a security audit of the entire repo and make sure we didn't introduce any security risks. Also, add rubocop, make sure the default rubocop settings are enforced, and add top level documentation comments for each service class or custom notification/job class."

**Session 2 — UI polish, datepickers, form validation, and deployment**

7. "There are a few issues with the datepicker. We should just see 'Choose Date & Time' on the button before the user selects anything. We should have a way to advance/accept the input on the pop up other than clicking outside the pop up modal. And, when we click anywhere on the element, that should open the date picker. Address this feedback on all datepickers in the app."
8. "See image and previous prompt" *(attached screenshot of native datepicker)*
9. "Great, can we also give any actionable/clickable elements a button ui? For example, in the image, add thought and back to conversations should have a button ui/look/element"
10. "Add thought should have a clean shape and look professional like Add message. Fix this"
11. "I want all actions/buttons to have the same shape/style/color – Change them to all be the blue with white text style."
12. "All the date pickers should have the same style as well."
13. "I DO want them to clearly have a difference between 'Choose Date' and 'Choose Date & Time' to represent what is underneath, but I want them to look like the other buttons in the app with the blue/white/hover that is the same."
14. "The color of the datepicker font doesn't quite match, and we want the size to line up with the element underneath. Create Thought is the example in the screenshot"
15. "What is the caret-color element representing?"
16. "We can get rid of this text above the element: Date/time sent. The sizing of the two buttons still doesn't match in the screenshot"
17. "The Create Thought button should be grayed out until a user has filled in the message and chosen a date/time. Once the user has completed those required fields, the submit button should change to green"
18. "Make sure you add specs to verify this."
19. "You did something in your disabling to hide the button completely, but I just want the color to be grey first, not hidden."
20. "I'm also seeing these devtools errors: `ActionController::RoutingError (No route matches [GET] \"/.well-known/appspecific/com.chrome.devtools.json\")` — And, I don't see the button still"
21. "You can see the devtools have the element selected here but it's not visible on the screen. We need to fix visibility." *(attached screenshot with DevTools)*
22. "Still not quite right" *(attached screenshot showing Tailwind base layer override)*
23. "Great, that actually worked. Now lets finish up these changes with a commit and merge to main"
24. "Great, make sure you're auth'd on github as timomitchel. Then check the currently tracked files to make sure you aren't pushing anything sensitive or irrelevant. If you are, remove them from the git history and add to gitignore. Once you've finished all of these checks, Then push this repo up to create a new repo in github."
25. "Can you grab the history of my prompts from all sessions that started in this repo and add a section named 'prompts' to the README in the AI section?"
