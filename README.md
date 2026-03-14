# lex-cognitive-echo-chamber

Self-reinforcing belief loop modeling for the LegionIO cognitive architecture. Tracks how beliefs, assumptions, and biases amplify inside an enclosed cognitive space — and models how external disruption can break through chamber walls.

## What It Does

An echo chamber is a named enclosure with a wall thickness that resists external input. Echoes (of type belief, assumption, bias, hypothesis, or conviction) are created in a shared pool and can be added to a chamber. Echoes inside a chamber amplify each other — the more a belief echoes, the stronger its amplitude grows. Disruption requires applying a force that exceeds the wall thickness; a successful disruption reduces the wall (making future disruptions easier) and dampens enclosed echoes.

Chambers progress through states: `forming` (sparse) -> `resonating` (active reinforcement) -> `saturated` (maximum self-reinforcement). A sealed chamber (wall_thickness >= 0.8) is nearly impervious to correction. A porous chamber (wall_thickness <= 0.3) absorbs external input readily.

## Usage

```ruby
client = Legion::Extensions::CognitiveEchoChamber::Client.new

# Create an echo in the pool
result = client.create_echo(
  content: 'all uncertainty should be resolved before acting',
  echo_type: :belief,
  domain: :decision_making
)
echo_id = result[:echo][:id]

# Create a chamber enclosure
chamber_result = client.create_chamber(
  label: 'conservative_bias',
  domain: :decision_making,
  wall_thickness: 0.6
)
chamber_id = chamber_result[:chamber][:id]

# Amplify the echo — each call increases amplitude and frequency count
client.amplify(echo_id: echo_id)

# Attempt disruption with external counter-evidence
client.disrupt(chamber_id: chamber_id, force: 0.8)
# Returns: { success: true, breakthrough: 0.2, wall_remaining: 0.57 }
# Or: { success: false, reason: 'insufficient_force' }

# Query echoes
client.list_echoes(echo_type: :belief, domain: :decision_making)

# Status report
client.chamber_status
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
