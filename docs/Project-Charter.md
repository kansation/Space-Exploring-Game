# Space Exploration Game — Project Charter

Version: 0.1 · October 9, 2026
Status: Initial draft for review; gameplay and production assumptions remain unvalidated.
Owner: Liam Beck
Working project label: Space Exploration Game (final title undecided)

## Purpose

Build a first-person 3D space exploration game about a traveler displaced beyond known space, seeking a route toward Sol. Exploration and equipment-based survival drive play. Inhabitants, opportunities, and discoverable history give places meaning and reasons to return.

The player retains their identity and memories. Their location and route home are uncertain, and local history may contradict their understanding of Sol. The cause of displacement, explanation of these contradictions, and ending remain undecided.

## Design pillars

1. Curiosity: unfamiliar landscapes, life, sounds, and structures invite investigation.
2. Physical presence: the player personally walks through and explores 3D environments.
3. Exploration with decisions: preparation, equipment, and environmental conditions affect access and routes.
4. Meaningful inhabitants: selected characters have distinct purposes, relationships, and responses to player actions.
5. Continuity: selected discoveries and consequences persist when the player returns.

No Man’s Sky is the primary reference for discovery, environmental wonder, and exploration freedom. This project aims to develop stronger character context and more purposeful inhabited places. Its scale and complete feature set are not baseline requirements.

## Confirmed direction

| Area | Decision |
| --- | --- |
| Setting | Sol exists as the connection to home; exploration begins beyond known space. |
| Population | Humans and aliens, introduced gradually. |
| Main activities | Exploration and investigation, supported by survival and equipment improvement. |
| Perspective | First person initially; third person is a later goal. |
| Visual ambition | Grounded proportions, surfaces, and lighting; greater realism where feasible. |
| Modes | Normal has no hunger or thirst. A later Survival mode adds hunger and thirst; further needs are undecided. |
| World direction | Several explorable destinations connected by travel. Manual flight is a later goal. |
| Engine | Godot selected; production suitability remains subject to the foundation test. |
| Installed editor | Godot 4.7.2 .NET, as reported by Liam. GDScript selected for this project. |
| Release intent | Enjoyable personal game first; public release is the ultimate ambition, not a dated commitment. |

Character-background selection, exact environmental hazards, equipment systems, travel transitions, procedural generation, and story branching are proposals or open questions rather than approved implementation requirements.

## Constraints

- One developer, with AI assistance for bounded tasks. Liam remains responsible for creative decisions and playable review.
- MacBook Air M2 with 16 GB RAM is the initial development and validation machine; its actual performance has not been measured.
- Budget: $0 by default. Up to $20 may be available for an essential, demonstrated need; purchases require a specific decision.
- Time: approximately 2–3 hours on available days, varying with work and personal schedules. A dependable weekly total is not established.
- Origins is paused. This project is separate and must preserve a manageable scope.
- No release date or completion estimate is established.

## Immediate milestone: exploration foundation

Prove that we can create a small, convincing, navigable alien environment using a workflow Liam can sustain.

Minimum deliverable: one bounded outdoor test area, first-person movement, basic collision, simple lighting and materials, and one environmental feature that invites investigation. Produce a standalone Mac build.

This is a technical and experiential test, not a complete story slice. Initial geometry and presentation may be disposable.

### Evidence required

- Movement and camera behavior are comfortable for Liam, and common obstacles do not cause frequent collision failures.
- Scale, materials, and lighting provide an acceptable initial direction for grounded visuals.
- A clue invites investigation without a mandatory quest instruction; test this with another player when practical.
- Performance is measured on the Mac with resolution, graphics settings, and test conditions recorded. Numeric targets belong in the Technical & Production Plan before evaluation.
- We can modify the environment and create a second small variation using the same workflow, recording the effort required.
- The standalone build launches and supports the tested experience.

Review each result as pass, revise, or unresolved. A successful launch alone does not establish milestone completion. Failure leads to simplification or a targeted alternative test before expansion.

### Explicit exclusions

No NPC implementation, dialogue, quests, inventory, crafting, hunger, thirst, combat, manual flight, third person, procedural planets, seamless space-to-surface travel, or world streaming in this milestone.

Multiplayer, base building, full economies, extensive creature simulation, and runtime AI dialogue are uncommitted ideas, not scheduled features.

## Development boundaries

Before adding a feature, identify its player purpose, prerequisites, smallest useful test, and evidence required to continue. Work on one bounded experiment at a time and preserve verified versions.

The later settlement expedition is illustrative, not approved story canon. NPCs, environmental hazards, and persistent consequences enter subsequent milestones only after the physical foundation works.

Do not expand the world merely because generation is technically possible. Measure the effort needed to create a second useful piece of content before committing to a larger content count.

## Documentation ownership

| Document | Authoritative responsibility |
| --- | --- |
| Project Charter | Purpose, pillars, constraints, scope boundaries, milestone outcomes, and release intent. |
| Game Design | Player-facing rules, mechanics, progression, world and story details, content design, and reference analysis. |
| Technical & Production Plan | Exact tooling, architecture, asset workflow, saves, performance targets, implementation sequence, and validation procedures. |
| Task board | Work items, bugs, current status, and completion evidence; it is not a fourth design document. |

Cross-reference decisions instead of duplicating them. Mark entries confirmed, proposed, deferred, or open. Update the owning document when an approved decision changes.

## Next decisions

1. Write the minimal Game Design draft, keeping unresolved systems as questions.
2. Specify the foundation test and project workflow in the Technical & Production Plan.
3. Establish the project folder, version control, and backups before production work.
4. Validate the selected engine through the foundation test before substantial architecture or content production.

## Decision record

- October 9, 2026: Consolidate core documentation into three documents with distinct ownership.
- October 9, 2026: Select Godot and GDScript; use the reported installed 4.7.2 .NET editor initially.
- October 9, 2026: Place the exploration foundation before the settlement expedition.
- October 9, 2026: Keep broader world scale, flight, Survival mode, and third person outside the immediate milestone.

This charter records the current direction. It does not claim that gameplay, visual targets, engine suitability, or production estimates have been proven.
