# lex-cognitive-echo-chamber

**Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Models self-reinforcing belief loops — the cognitive echo chamber phenomenon where ideas amplify themselves without external correction. Unlike `lex-cognitive-echo` (which tracks individual transient residual activations), the echo chamber models a structured enclosure: echoes of type belief/assumption/bias/hypothesis/conviction circulate inside a Chamber with defined wall thickness. Disruption requires force exceeding the wall. Sealed chambers (wall_thickness >= 0.8) are nearly impervious to external correction.

## Gem Info

- **Gem name**: `lex-cognitive-echo-chamber`
- **Version**: `0.1.0`
- **Module**: `Legion::Extensions::CognitiveEchoChamber`
- **Ruby**: `>= 3.4`
- **License**: MIT

## File Structure

```
lib/legion/extensions/cognitive_echo_chamber/
  cognitive_echo_chamber.rb
  version.rb
  client.rb
  helpers/
    constants.rb
    chamber_engine.rb
    echo.rb
    chamber.rb
  runners/
    cognitive_echo_chamber.rb
```

## Key Constants

From `helpers/constants.rb`:

- `ECHO_TYPES` — `%i[belief assumption bias hypothesis conviction]`
- `CHAMBER_STATES` — `%i[forming resonating saturated disrupted collapsed]`
- `MAX_ECHOES` = `500`, `MAX_CHAMBERS` = `50`
- `AMPLIFICATION_RATE` = `0.1`, `DECAY_RATE` = `0.02`
- `DISRUPTION_THRESHOLD` = `0.7` (resonance level at which a chamber is considered saturated; also the echo amplitude threshold for `resonate?`)
- `SEALED_THRESHOLD` = `0.8` (wall_thickness >= this = sealed, nearly impossible to disrupt)
- `POROUS_THRESHOLD` = `0.3` (wall_thickness <= this = porous, easily disrupted)
- `BREAKTHROUGH_BONUS` = `0.15` (fraction of breakthrough force subtracted from wall_thickness on successful disruption)
- `SILENT_THRESHOLD` = `0.05`, `DEFAULT_AMPLITUDE` = `0.5`, `DEFAULT_WALL_THICKNESS` = `0.5`
- `RESONANCE_LABELS` — range hash: `0.8+` = `:thunderous`, `0.6` = `:resonant`, `0.4` = `:humming`, `0.2` = `:fading`, below = `:silent`
- `AMPLIFICATION_LABELS` — `0.8+` = `:deafening`, `0.6` = `:loud`, `0.4` = `:moderate`, `0.2` = `:quiet`, below = `:muted`
- `CHAMBER_STATE_LABELS` — human-readable descriptions of each chamber state

## Runners

All methods in `Runners::CognitiveEchoChamber`:

- `create_echo(content:, echo_type: :belief, domain: :general, source_agent: nil, amplitude: 0.5, engine: nil)` — creates a new echo in the pool; validates content non-empty; invalid echo_type defaults to `:belief`
- `create_chamber(label:, domain: :general, wall_thickness: 0.5, engine: nil)` — creates a new named chamber enclosure
- `amplify(echo_id:, rate: 0.1, engine: nil)` — increases echo amplitude; also increments echo frequency counter
- `disrupt(chamber_id:, force:, engine: nil)` — attempts to break through a chamber's walls; fails if force <= wall_thickness; success reduces wall_thickness by `breakthrough * BREAKTHROUGH_BONUS` and dampens all enclosed echoes by the breakthrough amount
- `list_echoes(echo_type: nil, domain: nil, engine: nil)` — returns active echoes; optionally filtered by type and/or domain
- `chamber_status(engine: nil)` — full report: total echoes, active echoes, resonating echoes, total chambers, sealed/porous counts, disruption count, loudest 3 echoes

## Helpers

- `ChamberEngine` — manages `@echoes` hash and `@chambers` hash. `decay_all!` applies `DECAY_RATE` to all echoes and prunes silent ones. `add_echo_to_chamber(echo_id:, chamber_id:)` links an echo into a chamber. `disruption_history` returns a copy of the disruption log. Pruning: on overflow, silent echoes removed first; if still over limit, the faintest echo removed.
- `Echo` — amplitude-tracked belief unit. `amplify!(rate)` increments both amplitude and frequency. `dampen!(rate)` reduces amplitude. Predicates: `resonate?` (amplitude >= 0.7), `fading?` (amplitude <= 0.3), `silent?` (amplitude <= 0.05). `frequency_label` uses `RESONANCE_LABELS` against a normalized frequency score (frequency / 20, capped at 1.0).
- `Chamber` — enclosure with `wall_thickness`, `resonance_frequency`, `state`. `add_echo(echo)` adds to internal echo pool and recalculates resonance. `amplify_all!(rate)` amplifies every enclosed echo. `disrupt!(force)` returns `{ success: false }` if force <= wall_thickness, otherwise reduces wall and dampens echoes. `resonance_frequency` = ratio of resonating echoes to total echoes. State transitions: `:forming` -> `:resonating` (resonance >= 0.3) -> `:saturated` (resonance >= 0.7); disruption locks state to `:disrupted`.

## Integration Points

- `lex-cognitive-echo` models individual transient residual activations; `lex-cognitive-echo-chamber` models the structural enclosure effect where similar echoes reinforce each other and resist correction.
- `disrupt` is the mechanism for injecting counter-evidence. Callers from `lex-tick` can call `disrupt` with external input force to model perspective-challenging interactions.
- `source_agent` on echoes links chamber beliefs back to the originating agent — useful for `lex-mesh` multi-agent scenarios where one agent's beliefs propagate into another's echo chamber.
- `chamber_status` resonating/sealed metrics can be surfaced during `lex-tick`'s `post_tick_reflection` phase to flag cognitive rigidity.

## Development Notes

- Chambers and echoes are separate pools — an echo must be explicitly added to a chamber via `add_echo_to_chamber`. Creating an echo does not auto-enroll it in any chamber.
- `Chamber#disrupt!` reduces `wall_thickness` by `breakthrough * BREAKTHROUGH_BONUS`, not by the full breakthrough amount — chambers become easier to disrupt over time but never instantly destroyed.
- Chamber state transitions are blocked once state is `:disrupted` or `:collapsed` — the engine must explicitly manage transition out of these states.
- `resonance_frequency` on a Chamber is the ratio of `resonate?` echoes to total echoes — distinct from the global engine's `resonating_echoes` count.
- `Echo#frequency` counts amplify calls, not time — it is a repetition counter, not a temporal frequency.
