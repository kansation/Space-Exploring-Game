# Space Exploration Game — Technical & Production Plan

Version: 0.1 · October 9, 2026
Status: F1 movement manually confirmed; F2 terrain collision course and bounded step test implemented, with manual review recorded as pending in this environment. A separate fixed landscape scale prototype is now the default run scene. Content, performance, and export validation remain open.
Owner: Liam Beck
References: [Project Charter](Project-Charter.md) · [Game Design](Game-Design.md)

## 1. Ownership and status

This document owns tooling, implementation approach, file organization, development workflow, performance targets, and validation procedures. The Charter owns purpose and scope; Game Design owns player-facing rules. Reference those documents instead of redefining their decisions.

Confirmed: Godot has been selected, with GDScript. Setup inspection on October 10, 2026 selected `/Users/liambeck/Downloads/Godot_mono.app/Contents/MacOS/Godot`, which reports `4.7.2.stable.mono.official.ed1daf0bf`. This is the Mono/.NET-capable build; no C# project or .NET-specific game dependency is intended. A separate standard build at `/Applications/Godot.app/Contents/MacOS/Godot` reports `4.7.stable.official.5b4e0cb0f`. Operating-system compatibility, rendering performance, and export capability have not been inspected or tested.

Everything below is a proposed production baseline unless explicitly described as confirmed or completed. Approval of this document does not establish that a technical test has passed.

## 2. Initial tooling

| Tool | Purpose | Approach |
| --- | --- | --- |
| Godot 4.7.2 Mono/.NET-capable | Editor and game runtime | Use the selected 4.7.2 Mono build with GDScript; no C# project or .NET-specific game dependency is intended. |
| Godot script editor | Initial code editing | Start here; a separate editor is optional, not a prerequisite. |
| Git and a private GitHub repository | Version history and off-device copy | Keep this project separate from Origins. No paid service required for the initial workflow. |
| Markdown | Core documents | Keep the three authoritative documents in the repository alongside the code. |
| Modeling tools | Assets, if needed | No modeling dependency initially. Use primitive geometry before choosing a terrain or art add-on. |

Pin the engine version and later any add-on versions. Do not upgrade mid-milestone simply because an update appears. Evaluate upgrades on a branch, validate, then adopt deliberately.

## 3. Repository and document home

Proposed repository name: `space-exploration-game` (working label, subject to availability and Liam's choice).
Visibility: private initially. Branch: `main`.
Proposed Mac working location: a dedicated local development folder outside live iCloud, Dropbox, or other synchronization folders. The exact path is to be chosen during setup. This assistant's scratch workspace is not Liam's Mac.

| Path | Purpose | Create when |
| --- | --- | --- |
| `README.md` | Entry point: project status, engine version, documentation links, and run instructions | Repository setup |
| `docs/Project-Charter.md` | Scope, purpose, constraints | Repository setup |
| `docs/Game-Design.md` | Player-facing design | Repository setup |
| `docs/Technical-Production-Plan.md` | This plan | Repository setup |
| `AGENTS.md` | Short operational guardrails for code assistants; references core documents | Before AI-assisted code work |
| `.gitignore` | Exclude generated caches, local settings, exports, and secrets | Repository setup |
| `game/project.godot` | Godot project entry point | F0 empty project |
| `game/scenes/` | Scene files, initially one foundation scene | F0 empty project |
| `game/scripts/` | GDScript scripts | When movement implementation begins |
| `game/assets/` | Runtime assets | When assets are introduced |
| `docs/assets.csv` | Sources, licenses, modifications, attribution, and usage | Before importing third-party assets |
| `docs/test-results.md` | Test conditions, results, issues, and evidence | First runnable test |
| `docs/session-notes.md` | Short handoff and next action | First implementation session |

The supporting registers are logs, not additional core design documents. Do not create empty folders or general-purpose systems for anticipated features.

Initial document files supplied through chat are starting deliverables. Once imported into Git, the repository's `docs/` files become the authoritative working versions. Downloaded or shared copies are snapshots; do not maintain independent competing versions.

## 4. Version control and recovery

- Inspect existing files and Git state before changes. Preserve unrelated work.
- Start a session with a clean understanding of the current branch and uncommitted changes; pull before editing if a remote exists.
- Commit coherent changes with descriptive messages. Push verified checkpoints before ending a session.
- Commit documentation corrections alongside the feature changes they describe.
- Use short-lived branches for experiments likely to break or replace the working build; avoid a complex branching model.
- Never commit credentials or redistribute assets without checking permission. Review staged files before committing.
- Keep Godot source scenes, scripts, assets, and applicable import settings/UID sidecars; exclude the generated `.godot/` cache. Validate ignore rules rather than copying blanket patterns.
- Keep exports out of the source repository. Consider Git LFS only when asset sizes demonstrate a need, and check its storage implications first.
- Retain an additional dated local backup of important source and documents, separate from the working directory. A pushed commit is an off-device copy, but not a substitute for recovering uncommitted work.
- Test recovery by opening a fresh checkout or copy at the export checkpoint. Never validate recovery by overwriting the only working copy.

The initial documentation commit contains setup files only. F0 now adds only the empty Godot project entry point and one empty main scene; no game systems or content are included.

## 5. Minimal implementation approach

Begin with one test scene and the smallest movement implementation that can answer the foundation questions. Use Godot's built-in movement/collision capabilities rather than writing a physics engine.

Keep player input/movement, camera settings, and environment construction distinguishable. Do not create universal managers, a faction framework, an inventory architecture, a quest engine, or save infrastructure during the movement test.

Prefer ordinary scenes and reusable scene instances when they solve a current need. Introduce data-driven content formats only after a real second example demonstrates repetition.

Third-person camera separation is a future consideration, not a reason to build character rigs or camera-switching systems now. Similarly, future Survival mode does not justify implementing hunger or mode configuration during the foundation.

## 6. Terrain, visuals, and rendering

Start with authored primitive geometry: flat ground, simple obstacles, slopes, and a ridge. This is disposable test geometry, not a final terrain solution.

Then introduce a small coherent set of licensed materials and a limited number of environment assets. Record sources and licenses before committing them. Check commercial redistribution rights now, since public release is an eventual goal.

Choose the initial rendering method during setup and record it. Compare a lean renderer configuration and more capable settings only if the target appearance requires it. Do not assume a renderer's name establishes performance on the Mac.

Begin with limited lighting and no expensive global-illumination or post-processing requirements. Measure each significant visual addition. Material roughness, believable object scale, and consistent lighting deserve attention before high asset counts.

A terrain add-on, procedural mesh generator, voxel system, or world streamer requires a separate experiment tied to a specific unmet need. Do not infer that procedural planets are necessary for a small region.

## 7. Foundation test sequence

| Step | Smallest deliverable | Validation before advancing |
| --- | --- | --- |
| F0 — Setup | Documentation repository, verified engine version, minimal project when approved | Files are tracked correctly; project opens; no unresolved setup blocker. |
| F1 — Movement | First-person look, walking, gravity, floor and obstacles; jump remains deferred | Camera/control comfort and collision test pass. |
| F2 — Landscape | Primitive gentle/steep ramps, crest, lower floor, and short drop | Walkable routes, slope behavior, sliding, and falling are reliable; manual review pending. |
| F3 — Appearance | Small material set, lighting, representative environmental feature | Liam accepts an initial grounded visual direction; performance measured. |
| F4 — Curiosity | One partially concealed feature or clue | Another player investigates without being told its location when a tester is available. Otherwise mark curiosity evidence provisional. |
| F5 — Export and repeatability | Standalone Mac build and a second small environment variation | Build runs independently; performance and reproduction effort recorded. |

Advance only after reviewing the current step. A failed test leads to adjustment, simplification, or a targeted alternative. Do not compensate for a failed foundation by adding more content.

## 8. Proposed acceptance criteria

These targets are proposals to approve or revise before implementation, not hardware guarantees.

### Movement and collision

- Walk, look, and jump operate consistently on keyboard/mouse or the selected input device.
- Test flat ground, an obstacle, a modest slope, a wall, and a ledge. Record any falling through terrain, unwanted sticking, or uncontrolled camera behavior.
- Mouse capture can be released and restored; movement does not depend on frame rate.
- Liam can explore for ten minutes comfortably. Mouse sensitivity is adjustable; avoid mandatory camera shake or head bob.

### Performance

- Initial benchmark: standalone build at a 1280 × 720 render resolution, with renderer and quality settings recorded.
- Preferred target: sustained 60 FPS in the representative foundation route. Minimum initial usability target: sustained 30 FPS after a warm-up period, without frequent disruptive stalls. Passing only the minimum triggers a visual/performance review before expansion.
- Run for at least ten minutes and repeat under consistent conditions. Record frame-time observations, major stalls, editor-versus-export differences, and available memory information.
- Record Mac model, memory, macOS version, engine build, power conditions, resolution, and settings. These tests establish only this scene's performance, not future flight, NPC counts, or full-world capacity.

### Appearance and curiosity

- Liam approves scale, surface presentation, and lighting as an acceptable direction; photorealism is not a foundation requirement.
- A tester can describe what caught their attention and what they expected to find. This is qualitative evidence, not proof of universal appeal.
- If no independent tester is available, record that limitation rather than marking external validation complete.

### Production and export

- Standalone build launches outside the editor and completes the exploration route. Public signing/notarization and store distribution are later tasks, not current delivery promises.
- A fresh checkout or copy can reproduce the build using recorded instructions and the pinned tooling.
- Produce a second small variation without rewriting movement. Record actual time, custom asset work, and workflow friction; no content-production estimate is assumed beforehand.

## 9. Session workflow and AI guardrails

1. Read the last session note and inspect Git state.
2. Select one bounded task with prerequisites and acceptance criteria.
3. Change the smallest relevant area; avoid unrelated refactoring.
4. Run the affected experience and check errors. Inspect AI-generated changes before accepting them.
5. Record evidence, remaining issues, and material decisions in their owning documents.
6. Commit/push an appropriate checkpoint, and leave the next concrete action.

Each task records purpose, prerequisites, intended behavior, validation, and scope exclusions. Use a simple Ready / Doing / Verify / Done workflow. Keep detailed design out of task-status notes.

AI must not add systems merely because they are mentioned as future goals. It should distinguish changes it implemented from tests it actually ran. Device testing must happen on Liam's Mac; execution in a remote assistant environment cannot establish Mac performance or installation success.

## 10. Testing strategy and later technical gates

Manual playtesting is primary for movement comfort, visual judgment, and curiosity. Add inexpensive automated checks where behavior becomes stable and repeated failures justify them. Do not establish a large test framework before the first runnable scene.

Later persistence needs stable identities and save-version handling; design and test these when the first meaningful persistent change is introduced. Later NPC work starts with one bounded routine and one response. Later region travel starts with two destinations. Generation and flight each require an isolated feasibility test before being scheduled for production.

Milestone review records: passed criteria, failed or unresolved criteria, actual hours, major bottlenecks, and a decision to continue, simplify, retry, or pause. There is no established deadline or production estimate.

## 11. Initial risk register

| Risk | First response |
| --- | --- |
| Target look exceeds available Mac performance | Test representative assets early; reduce cost before expanding scenes. |
| Free assets do not form a cohesive style | Use a narrow asset set and simple custom geometry; do not accumulate unrelated packs. |
| Generated code becomes hard to inspect | Bounded tasks, small diffs, explanations, and verified checkpoints. |
| Scope grows before foundation passes | Keep later systems out of the current task list. |
| Interrupted sessions lose context | Short handoff notes and one explicit next action. |
| Documents drift apart | One authoritative home per decision; repository versions supersede downloaded snapshots. |
| Latest work remains only on one computer | Commit, push, and validate fresh-checkout recovery. |

## 12. Immediate next actions

1. Review this draft, including its proposed performance thresholds.
2. Create a dedicated private remote repository if one does not already exist, and keep the three documents in `docs/`.
3. Add a concise README, ignore rules, and assistant guardrails. Verify the initial commit and remote.
4. Clone onto the Mac in the chosen local development location.
5. Verify Godot and begin F0/F1 only after the foundation documents are reviewed.

F0 setup result — October 10, 2026: Using `/Users/liambeck/Downloads/Godot_mono.app/Contents/MacOS/Godot` (`4.7.2.stable.mono.official.ed1daf0bf`), created `game/project.godot` and an empty `game/scenes/main.tscn` with the Mobile renderer configured provisionally for the M2 MacBook. The project was opened and the empty scene ran without reported errors in headless validation. Git tracks the project and scene source; generated `.godot/` cache remains ignored. Performance and export capability are not validated.

F1 movement result — October 10, 2026: Added a bounded `CharacterBody3D` controller with normalized WASD input, mouse look, gravity, floor/wall collision, and Escape/click mouse release/capture behavior. Added only a flat collision floor and three primitive block obstacles. The manual F1 pass confirmed grounded movement, mouse look/capture behavior, gravity settling, and flat-floor/block collision. Automated validation loaded the project, scenes, and script with the pinned Mono executable and ran the scene to clean exit; Mobile rendering initialized on the Apple M2. No jump, sprint, terrain, external assets, or gameplay systems were added.

Jump update — October 11, 2026: Added Space-to-jump to the existing controller with adjustable `jump_height` initially set to 1.2 m. Jumping is accepted only while grounded through `Input.is_action_just_pressed`, so holding Space does not trigger repeated jumps. Existing walking, mouse look, gravity, step assist, slope limits, and collision behavior remain unchanged. Automated scene loading passed; one brief Mac manual check of jumping, landing, and overhead collision remains recorded as pending until Liam completes it.

F2 terrain result — October 11, 2026: Preserved the primitive gentle/steep ramps, crest, lower floor, flat floor, and blocks, and added isolated 0.1 m, 0.2 m, and 0.4 m ledge tests plus low-overhead clearance. The controller now exposes an adjustable `step_height` initially set to 0.25 m; step candidates require clear upward and forward space plus a walkable landing surface. The 0.1 m and 0.2 m ledges are intended to pass, while the 0.4 m ledge, steep slopes, and low-clearance approach remain blocked. Automated scene/script loading and clean headless exit pass. F2's manual pass and the new head-on/diagonal, overhead, ramp, slope-limit, crest, sliding, and drop checks still require Liam's Mac playtest; they are not claimed as completed by headless validation.

Landscape scale prototype — October 11, 2026: Added a separate fixed `100 m × 100 m` primitive landscape scene with a shallow valley, gentle hill banks, steeper boundary slopes, matching static collision, simple ground material, directional lighting, and a procedural sky resource. The existing F1/F2 debug course remains in `scenes/main.tscn`; `scenes/landscape.tscn` is now the default run scene with a safe start position. No procedural generation, streaming, vegetation, wildlife, buildings, story, or new movement features were added. Automated loading passed; Mac playtest and performance measurement remain pending.

Landscape route refinement — October 11, 2026: Refined the fixed landscape into a sheltered starting spot, a shallow valley route, a ridge/overlook destination, and a distinctive three-piece primitive rock formation visible from the route. Ground color, directional light, ambient environment, and sky contrast were tuned for readable elevation and distance. Matching static collision was preserved for all added geometry. This remains a scale/traversal prototype with no decoration systems or new gameplay; manual route review and performance measurement remain pending.

Procedural terrain test — October 11, 2026: Added a separate `procedural_terrain.tscn` using the existing player controller and a one-shot `FastNoiseLite` generator. The fixed patch is 100 m × 100 m with configurable `seed`, `terrain_height`, `noise_scale`, and `mesh_resolution`; one sampled height grid drives both the generated mesh and triangle collision, and the player is placed above the generated centre height. Existing F1/F2 and authored landscape scenes remain preserved. The procedural scene is now the default run scene. Automated startup, reproducibility inspection, mesh/collision construction, and safe-spawn checks are recorded as pending verification; manual traversal and performance measurement remain pending.

Procedural shading correction — October 11, 2026: The initial generator emitted unshared vertices with one flat normal per triangle and used downward triangle winding, so the neutral material received visibly different lighting on adjacent faces. Replaced it with shared indexed grid vertices, upward winding, accumulated normalized vertex normals, and a single neutral matte material. Increased the default adjustable mesh resolution from 64 to 96 to reduce angular silhouette while preserving seeded heights and matching triangle collision. Automated startup passed; visual confirmation remains a manual playtest check.

Procedural collision/shape correction — October 11, 2026: Replaced the unreliable runtime concave triangle collision with Godot's built-in `HeightMapShape3D`, populated from the same deterministic height array as the mesh and scaled to the 100 m patch. Reduced the default terrain height to 2.5 m and adjusted the default noise scale to 0.045 so the generated patch reads as gentle terrain rather than a rounded cloud; both remain adjustable. Startup validation passed and the pinned build was launched for visual/startup review. Manual confirmation of stable grounding and traversal remains pending.

Procedural terrain shaping/material variation — October 11, 2026: Added deterministic broad and restrained detail noise settings (`terrain_height`, `noise_scale`, `detail_height`, and `detail_noise_scale`) using seed-derived `FastNoiseLite` instances. The same combined height function drives mesh, heightmap collision, and centre spawning. Replaced uniform color with one built-in shader material that blends soil on flatter surfaces into exposed rock by smooth slope threshold; no per-triangle random coloring or new terrain systems were added. Automated startup passes; several-seed visual and traversal review remains pending.

Revision record: October 9, 2026 — initial draft. October 10, 2026 — documentation repository initialized; Godot standard and Mono builds inspected, with the 4.7.2 Mono build selected. October 10, 2026 — empty F0 project and main scene created; Mobile renderer recorded as provisional and empty-scene validation completed. October 10, 2026 — bounded F1 movement implementation added and manually confirmed. October 10, 2026 — primitive F2 terrain collision course added; automated checks pass and manual slope/drop checks remain open.
