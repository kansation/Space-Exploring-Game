# Space Exploration Game — Game Design

Version: 0.1 · October 9, 2026
Status: Initial draft; no gameplay has been implemented or validated.
Owner: Liam Beck
Related document: [Project Charter](Project-Charter.md)

## Document responsibility

This document owns player-facing behavior, gameplay rules, progression, world and narrative details, and reference analysis. The Project Charter owns scope and constraints. The Technical & Production Plan will own implementation and validation procedures.

Status labels: **Confirmed** = accepted direction, not proof of feasibility; **Proposed** = candidate for testing; **Deferred** = future direction outside the current milestone; **Open** = unresolved.

## Intended experience

**Confirmed.** Personally explore unfamiliar 3D environments as a traveler displaced beyond known routes, seeking a connection toward Sol. Strange nature invites curiosity; inhabitants and opportunities provide destinations; mysteries and history give context along the way. Exploration and survival are the primary gameplay interests.

The player should have reasons both to travel onward and to revisit familiar places. The route home provides continuity, while local exploration permits a developing identity and relationships.

**Proposed.** Returning home is a long-term objective rather than an uninterrupted emergency. The precise story must justify time spent exploring without making the character appear indifferent to their situation.

## Player actions

| Action | Status | Intended player-facing behavior |
| --- | --- | --- |
| Look and walk | Confirmed | Observe and move through the environment directly in first person. |
| Jump | Proposed for the foundation | Traverse modest obstacles; tune its usefulness before adding movement abilities. |
| Investigate | Confirmed direction; interaction details open | Examine clues and unfamiliar features to learn something useful or meaningful. |
| Prepare and equip | Confirmed direction; rules open | Improve or select equipment to support exploration and survival. |
| Choose a route | Proposed | Use observations to weigh access, exposure, and potential discoveries. |
| Talk and take opportunities | Confirmed direction; conversation format open | Learn about places and people, and decide whether to become involved. |
| Travel between destinations | Confirmed direction; initial controls open | Reach several explorable locations. |
| Pilot a ship | Deferred | Manual flight is a later goal; handling and travel scale are undecided. |

Scanning, sprinting, climbing, swimming, mining, weapon use, and collecting physical samples are **Open**, not baseline controls. Each needs a specific purpose and test before approval.

## Exploration loop

**Proposed working loop:**

1. Notice a feature, signal, clue, or opportunity.
2. Investigate enough to decide whether and how to pursue it.
3. Travel, observing the environment and responding to an obstacle when relevant.
4. Discover information, a place, a resource, or an opportunity.
5. Use or share the result, improving access, understanding, or selected relationships.
6. Choose the next destination or revisit somewhere familiar.

Every discovery does not need all six steps. Quiet discoveries may simply reward curiosity. Avoid making every unusual feature a mandatory quest or collectible.

The loop is not validated. The foundation milestone tests only physical exploration and curiosity; equipment, inhabitants, hazards, and consequences require later experiments.

## Discovery design

| Discovery type | Confirmed purpose | Proposed example, not story canon |
| --- | --- | --- |
| Nature and phenomena | Invite exploration of unfamiliar things. | Vegetation clusters around sheltered ground, suggesting environmental conditions. |
| People and opportunities | Give reasons to visit and return. | A technician wants information from a neglected installation. |
| History and mysteries | Reveal context and challenge assumptions. | An old navigation record contains an unexpected connection to Sol. |

**Proposed rules:**

- Important landmarks can be found through observation, signals, rumors, maps, or direct exploration. A document may explain a place without being the sole permission to discover it.
- Different discoveries should sometimes change the player's actions, understanding, or opportunities rather than only their currency balance.
- Repeatable location families need differences in purpose or interaction, not merely appearance.
- Environmental clues should be readable; curiosity must not depend on knowing the designer's intended answer.
- Where possible, observation should precede an explanatory interface marker. Exact navigation assistance remains open and should accommodate player needs.

## Survival and equipment

**Confirmed mode distinction:** Normal has no hunger or thirst. A later Survival mode adds hunger and thirst. Additional bodily needs are open.

**Confirmed direction:** Equipment improvement supports exploration and survival. Its acquisition, costs, inventory format, and upgrade rules are open.

**Proposed baseline for later testing:** Environmental exposure can matter in both modes. Safe places allow preparation; equipment or route choices allow access to more challenging areas. Test one hazard before adding multiple interacting hazards.

**Open:** health, damage, recovery, death and respawn, penalties, hazard replenishment, crafting, resource gathering, food and water sources, difficulty settings, and whether needs progress during dialogue or other interruptions.

Do not assume constant meter depletion is enjoyable. Judge survival by the decisions it creates and the exploration it enables. Mode differences should preserve access to the core story; exact balancing remains open.

## Progression

**Proposed.** Progress can follow three paths:

- Knowledge: understand places, history, and potential routes toward Sol.
- Capability: improve equipment or access to reach further destinations.
- Relationships: establish selected trust, obligations, and opportunities.

The main story must provide credible advances toward locating home. Skill trees, character levels, currencies, unlock counts, and total game length are open.

## Character and roleplay

**Confirmed.** The player retains their identity and past. They do not begin with blanket amnesia. Their background and decisions should affect selected opportunities and relationships.

**Open:** fixed versus selectable background, character name and customization, profession, remembered relationships, dialogue choices, faction alignment, and whether returning home is compulsory or one possible ending.

**Proposed.** Roleplay comes from specific choices and recognizable responses. Avoid promising universal freedom or a world that reacts to every action.

## Inhabitants and continuity

**Confirmed.** Humans and aliens appear gradually. Important inhabitants should have distinct purposes and selected responses to the player; relevant changes persist on returning.

**Proposed.** A small number of purposeful activities and remembered events can convey daily life. Individuals can disagree through priorities and evidence without all being deceptive.

**Open:** first settlement population, routines, relationships between NPCs, dialogue structure, languages, alien cultures, faction behavior, and events occurring while the player is absent.

Behavior must remain understandable. A changed greeting, occupied workstation, repaired object, or new opportunity may be enough to show a consequence. Exact implementation belongs in the Technical & Production Plan.

## World and narrative rules

| Element | Status | Current rule or question |
| --- | --- | --- |
| Sol | Confirmed | Exists and represents the player's connection to home. Its playable extent is open. |
| Displacement | Confirmed premise | Player is beyond familiar routes; cause and mechanism are open. |
| Contradictory history | Confirmed direction | Local information may conflict with what the player knows; explanation is open. |
| Humans and aliens | Confirmed | Both exist in the explored setting and are introduced gradually. Their distribution is open. |
| Travel | Open rules | Speed, distances, fuel, navigation, and transitions remain undecided. |
| Time period | Open | No year, human expansion timeline, or political map has been chosen. |
| Tone | Open | No final balance of wonder, danger, humor, and political themes has been set. The earlier POTUS concept is not the current game premise. |

Do not create detailed lore that depends on an undecided travel model or chronology. Illustrative examples do not establish canon.

## No Man's Sky reference

No Man's Sky is the primary inspiration. This table records our design intentions and Liam's preferences, not a claim about all of NMS's systems or development history.

| Reference aspect | Our intention |
| --- | --- |
| Unexpected landscapes, life, and discoveries | Preserve the motivation to see what lies beyond the next ridge. |
| Freedom to explore | Provide optional paths and discoveries alongside the route-home story. |
| Environmental presentation | Aim for more grounded surfaces while retaining unfamiliar beauty. |
| Equipment and expedition preparation | Explore how capability can open destinations. |
| Character context | Provide an identifiable past and selected meaningful choices. |
| Inhabited places | Emphasize purposeful activities, distinct people, and consequences. |
| Repeated points of interest | Test differences in function and context before multiplying locations. |
| Enormous scale and seamless travel | Remain future possibilities requiring separate evidence, not inherited requirements. |

## First foundation experience

**Proposed test scenario.** Start in a bounded landscape. A partially concealed silhouette or sound invites investigation beyond a ridge. Walking reveals a visually distinct feature that rewards looking more closely. No quest, NPC, reward economy, or explanatory lore is required for this test.

The foundation must answer whether physical exploration and presentation can carry curiosity. Its exact size, assets, controls, and measurable acceptance criteria belong in the Technical & Production Plan.

The later technician-and-navigation-relay expedition remains a candidate for testing the larger loop, not an approved level or story event.

## Priority questions after the foundation

1. Which investigative interaction adds value: examination, scanning, physical manipulation, or another action?
2. What single environmental obstacle creates a meaningful exploration decision?
3. How does one equipment improvement change access without requiring a large crafting economy?
4. What observable activity makes one inhabitant feel purposeful?
5. Which consequence is worth preserving across visits?

Answer these sequentially through bounded experiments. Decisions may simplify or replace this draft.

## Revision record

- October 9, 2026: Initial minimal design draft; confirmed preferences separated from untested proposals and unresolved systems.

No code, content pipeline, gameplay validation, or completed milestone is implied by this document.
