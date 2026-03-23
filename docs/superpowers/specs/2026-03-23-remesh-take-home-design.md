# Remesh Take-Home Rails 8 Application Design

## Context

Build a server-rendered Ruby on Rails 8 application for the Remesh take-home challenge. The app manages conversations, messages, and thoughts with search capabilities. The goal is a clean, correct, reviewable implementation that signals senior backend engineering judgment.

## Stack

- Ruby 3.3.0 / Rails 8.1.2
- PostgreSQL 16
- Server-rendered MVC with ERB + Tailwind CSS
- RSpec, FactoryBot, Capybara (headless Chrome), SimpleCov (95%+ coverage)

## Domain Model

### Conversation
- `title:string` (required)
- `start_date:date` (required)
- `has_many :messages, dependent: :destroy`

### Message
- `text:text` (required)
- `date_time_sent:datetime` (required)
- `conversation_id:bigint` (FK, not null)
- `belongs_to :conversation`
- `has_many :thoughts, dependent: :destroy`

### Thought
- `text:text` (required)
- `date_time_sent:datetime` (required)
- `message_id:bigint` (FK, not null)
- `belongs_to :message`

### Validations
- **Conversation:** `validates :title, presence: true` and `validates :start_date, presence: true`
- **Message:** `belongs_to :conversation` (implicit presence validation in Rails 5+), `validates :text, presence: true`, `validates :date_time_sent, presence: true`
- **Thought:** `belongs_to :message` (implicit presence validation in Rails 5+), `validates :text, presence: true`, `validates :date_time_sent, presence: true`

### Database Constraints
- Real foreign keys with `on_delete: :cascade`. Note: DB-level cascades bypass Rails callbacks and the event pattern — this is intentional defense-in-depth. Normal application deletes go through `dependent: :destroy` which fires callbacks.
- NOT NULL on all required columns
- Indexes: FK columns, `date_time_sent` on messages and thoughts (ordering)
- First migration must `enable_extension 'pg_trgm'` before trigram indexes can be created
- GIN trigram indexes on `conversations.title` and `messages.text` for ILIKE search

### Search
- `Conversation.search_by_title(query)` — case-insensitive partial match via `ILIKE`
- `Message.search_by_text(query)` — case-insensitive partial match via `ILIKE`
- Backed by GIN trigram indexes (`pg_trgm` extension)
- All queries use ActiveRecord parameterized queries to prevent SQL injection
- User input sanitized for LIKE special characters (`%`, `_`, `\`)

## Routing

```ruby
resources :conversations, only: [:index, :show, :new, :create] do
  resources :messages, only: [:new, :create]
end

resources :messages, only: [] do
  resources :thoughts, only: [:new, :create]
end

get "messages/search", to: "messages#search", as: :search_messages

root "conversations#index"
```

## Controllers

All controllers are thin — load records, permit params, delegate to services, handle success/failure.

### ConversationsController
- `index` — lists conversations, filters with `?q=` search param via `search_by_title` scope
- `show` — loads conversation with `messages.includes(:thoughts).order(date_time_sent: :asc)` to prevent N+1
- `new` — renders form
- `create` — delegates to `Conversations::Creator`, redirects on success, re-renders on failure

### MessagesController
- `new` — renders form scoped to parent conversation
- `create` — delegates to `Messages::Creator`, redirects to conversation show on success
- `search` — searches messages by `?q=`, displays results with parent conversation context

### ThoughtsController
- `new` — renders form scoped to parent message
- `create` — delegates to `Thoughts::Creator`, redirects to conversation show on success

## Service Objects

Located in `app/services/`. Each follows the same pattern:

```ruby
module Conversations
  class Creator
    def self.call(params:)
      # wrap in transaction
      # create record
      # return Result (success/failure)
    end
  end
end
```

- `Conversations::Creator.call(params:)` — creates conversation
- `Messages::Creator.call(conversation:, params:)` — creates message for conversation
- `Thoughts::Creator.call(message:, params:)` — creates thought for message

Each returns a `ServiceResult` value object with `.success?`, `.record`, `.errors`.

`ServiceResult` is a simple PORO in `app/services/service_result.rb`:
- Success: `ServiceResult.new(success: true, record: record)` — `.errors` returns `nil`
- Failure: `ServiceResult.new(success: false, record: record, errors: record.errors)` — `.errors` returns the ActiveModel::Errors object so views can render inline errors via `record.errors.full_messages`

## Event Pattern

### Publishing
Each model has an `after_commit :publish_created_event, on: :create` callback that calls:
```ruby
ActiveSupport::Notifications.instrument("conversations.created", conversation: self)
```
(Namespaced per model: `messages.created`, `thoughts.created`)

### Subscribing
`app/subscribers/domain_event_subscriber.rb` — a module that registers listeners for each event.

### Registration
`config/initializers/domain_events.rb` — wires up `ActiveSupport::Notifications.subscribe` calls at boot.

### Jobs
`EventLogJob` — receives event name + record info, logs structured output. Non-critical, fire-and-forget. Demonstrates async side-effect pattern.

## Views

### Layout
Tailwind CSS. Centered content container. Simple nav with links to Conversations index and Message Search.

### Pages
- **Conversations Index** — heading, search form (GET `?q=`), list of conversations (title + start_date), "New Conversation" link
- **Conversation New** — form: title (text), start_date (date picker). Inline validation errors.
- **Conversation Show** — title + start_date, "Add Message" link, chronological messages each showing text + timestamp + nested thoughts + "Add Thought" link
- **Message New** — form: text (textarea), date_time_sent (datetime picker). Scoped to conversation.
- **Thought New** — form: text (textarea), date_time_sent (datetime picker). Scoped to message. Redirects to conversation show.
- **Message Search** — search form (GET `?q=`), results showing message text + timestamp + link to parent conversation. Intentionally excludes thoughts from search results — thoughts are only visible on the conversation show page.

### Feedback
- Flash notice on successful create actions (POST-redirect-GET)
- Inline validation errors on failed submissions via `shared/_form_errors` partial

## Testing

### Factories
- `conversation` — valid defaults, trait `:with_messages`
- `message` — valid defaults, associated conversation, trait `:with_thoughts`
- `thought` — valid defaults, associated message

### Test Layers

**Model specs:** Associations, validations, search scopes, dependent destroy behavior.

**Service specs:** Success case (record created, returns success), failure case (invalid params, returns errors), event publication (`ActiveSupport::Notifications` fires), transaction behavior.

**Request specs:** All controller actions — valid and invalid inputs, search with query params, proper redirects and status codes.

**System specs:** Full user flows — create conversation, view list, click into conversation, add message, add thought, view nested hierarchy, search conversations by title, search messages by text.

**Job specs:** `EventLogJob` performs without error with expected payload.

**Subscriber specs:** Domain event subscriber enqueues correct job when notification fires.

**Coverage:** SimpleCov configured in `spec/spec_helper.rb` with `SimpleCov.minimum_coverage 95`. Runs automatically when `COVERAGE=true` or always in CI. Reports to `coverage/` directory (gitignored).

## README

Will include:
- Project overview and stack
- Ruby/PostgreSQL version requirements
- Exact setup steps (clone, bundle, db:create, db:migrate, rails s, rspec)
- Architecture overview (services, events, testing layers)
  - Add a diagram
- Event/instrumentation pattern explanation
  - Add a diagram
- Assumptions and tradeoffs
- AI usage section (tools used, prompt categories, challenges, human judgment decisions)
  - Emphasis on planning. User came with a a structured prompt engineered .md file from the beginning. Most time spent in plan mode. 6-7 Iterations in plan mode. 

## Seed Data

Create some seed data with `db/seeds.rb` with sample conversations, messages, and thoughts for reviewer convenience. This should highlight all the objects created in the application, and it should provide some unique search cases that highlight the indexing and search capabilities. 
