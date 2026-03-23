puts "Seeding database..."

# Conversation 1: Product Strategy
product = Conversation.create!(
  title: "Q2 Product Strategy Discussion",
  start_date: Date.new(2024, 3, 15)
)

msg1 = product.messages.create!(
  text: "What should our top priority be for Q2? I think we should focus on improving user onboarding.",
  date_time_sent: DateTime.new(2024, 3, 15, 10, 0)
)
msg1.thoughts.create!(
  text: "Onboarding is critical — we're losing 40% of signups in the first week.",
  date_time_sent: DateTime.new(2024, 3, 15, 10, 5)
)
msg1.thoughts.create!(
  text: "I'd prioritize retention features over onboarding. Easier wins.",
  date_time_sent: DateTime.new(2024, 3, 15, 10, 7)
)

msg2 = product.messages.create!(
  text: "What about expanding to mobile? Our analytics show 60% of traffic from mobile devices.",
  date_time_sent: DateTime.new(2024, 3, 15, 10, 15)
)
msg2.thoughts.create!(
  text: "Mobile-first makes sense if the data backs it up.",
  date_time_sent: DateTime.new(2024, 3, 15, 10, 18)
)

msg3 = product.messages.create!(
  text: "Let's not forget about the API improvements. Enterprise clients need better webhook support.",
  date_time_sent: DateTime.new(2024, 3, 15, 10, 30)
)
msg3.thoughts.create!(
  text: "Enterprise revenue is 70% of our total. We should listen.",
  date_time_sent: DateTime.new(2024, 3, 15, 10, 33)
)
msg3.thoughts.create!(
  text: "Webhooks + better docs could reduce support tickets significantly.",
  date_time_sent: DateTime.new(2024, 3, 15, 10, 35)
)

# Conversation 2: Engineering Retrospective
retro = Conversation.create!(
  title: "Sprint 14 Engineering Retrospective",
  start_date: Date.new(2024, 3, 22)
)

msg4 = retro.messages.create!(
  text: "What went well this sprint? I thought the deployment pipeline improvements were great.",
  date_time_sent: DateTime.new(2024, 3, 22, 14, 0)
)
msg4.thoughts.create!(
  text: "Agreed — deploy times dropped from 20 minutes to 5. Huge win.",
  date_time_sent: DateTime.new(2024, 3, 22, 14, 3)
)
msg4.thoughts.create!(
  text: "The automated rollback feature saved us during the Wednesday incident.",
  date_time_sent: DateTime.new(2024, 3, 22, 14, 5)
)

msg5 = retro.messages.create!(
  text: "What could we improve? I noticed our test coverage dropped below 80% on the payments module.",
  date_time_sent: DateTime.new(2024, 3, 22, 14, 15)
)
msg5.thoughts.create!(
  text: "We need a coverage gate in CI. No merges below threshold.",
  date_time_sent: DateTime.new(2024, 3, 22, 14, 18)
)

# Conversation 3: Customer Research (search-friendly content)
research = Conversation.create!(
  title: "Customer Research Findings — Enterprise Segment",
  start_date: Date.new(2024, 4, 1)
)

msg6 = research.messages.create!(
  text: "Key insight: enterprise customers value data security and compliance features above all else.",
  date_time_sent: DateTime.new(2024, 4, 1, 9, 0)
)
msg6.thoughts.create!(
  text: "SOC 2 compliance was mentioned by 8 out of 10 interviewees.",
  date_time_sent: DateTime.new(2024, 4, 1, 9, 5)
)
msg6.thoughts.create!(
  text: "This aligns with why we lost the Acme Corp deal last quarter.",
  date_time_sent: DateTime.new(2024, 4, 1, 9, 8)
)

msg7 = research.messages.create!(
  text: "Pricing sensitivity analysis: 65% of prospects found our enterprise tier reasonably priced but wanted annual billing options.",
  date_time_sent: DateTime.new(2024, 4, 1, 9, 30)
)
msg7.thoughts.create!(
  text: "Annual billing with a 15% discount could increase conversion significantly.",
  date_time_sent: DateTime.new(2024, 4, 1, 9, 33)
)

msg8 = research.messages.create!(
  text: "Integration requirements: Salesforce, Slack, and Jira were the top three requested integrations.",
  date_time_sent: DateTime.new(2024, 4, 1, 10, 0)
)
msg8.thoughts.create!(
  text: "We already have Slack. Salesforce should be next — highest ROI.",
  date_time_sent: DateTime.new(2024, 4, 1, 10, 5)
)
msg8.thoughts.create!(
  text: "Jira integration could be a community contribution opportunity.",
  date_time_sent: DateTime.new(2024, 4, 1, 10, 8)
)
msg8.thoughts.create!(
  text: "What about Zapier as a universal connector instead of individual integrations?",
  date_time_sent: DateTime.new(2024, 4, 1, 10, 10)
)

# Conversation 4: Team Culture
culture = Conversation.create!(
  title: "Building a Remote-First Culture",
  start_date: Date.new(2024, 4, 10)
)

msg9 = culture.messages.create!(
  text: "How do we maintain team cohesion with our fully remote setup? I've noticed communication gaps between timezones.",
  date_time_sent: DateTime.new(2024, 4, 10, 11, 0)
)
msg9.thoughts.create!(
  text: "Async-first communication norms would help. Not everything needs a meeting.",
  date_time_sent: DateTime.new(2024, 4, 10, 11, 5)
)
msg9.thoughts.create!(
  text: "Weekly team social hours (optional, no work talk) have worked at my previous company.",
  date_time_sent: DateTime.new(2024, 4, 10, 11, 8)
)

puts "Seeded #{Conversation.count} conversations, #{Message.count} messages, #{Thought.count} thoughts."
puts ""
puts "Search demos you can try:"
puts "  Conversations: 'strategy', 'sprint', 'enterprise', 'remote'"
puts "  Messages: 'mobile', 'compliance', 'pricing', 'webhook', 'timezone'"
