# Implementation Plan: Remove Chat Prefix from Room Modules

**Branch**: `001-remove-chat-prefix` | **Date**: 2025-11-10 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-remove-chat-prefix/spec.md`

## Summary

This is a systematic refactoring to remove the redundant "Chat" prefix from room-related modules throughout the ExChat codebase. The refactoring will rename `ChatRoom` → `Room`, `ChatRooms` → `Rooms`, and all associated use cases, files, and references. The technical approach involves using git mv for file renames to preserve history, systematic text replacement for module references, and comprehensive test execution after each change to ensure zero regressions per the constitution.

## Technical Context

**Language/Version**: Elixir ~> 1.6
**Primary Dependencies**: Cowboy ~> 2.4 (WebSocket), Plug ~> 1.6, Poison ~> 3.1 (JSON)
**Storage**: N/A (in-memory GenServer processes with Registry)
**Testing**: ExUnit (built-in), WebSockex ~> 0.4.0 (test client), Mock ~> 0.3.3 (mocking)
**Target Platform**: Erlang/OTP BEAM VM
**Project Type**: Single Elixir application
**Performance Goals**: N/A (refactoring preserves existing performance)
**Constraints**: Zero regressions - all existing tests must pass, no functional changes allowed
**Scale/Scope**: 13 files affected, 6 modules renamed, ~100-150 references updated

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### ✅ I. Semantic Commits
**Status**: PASS
**Compliance**: Each file rename and each module reference update will be committed separately with semantic prefixes:
- `refactor: rename ChatRoom module to Room`
- `refactor: rename ChatRooms module to Rooms`
- `refactor: update use case CreateChatRoom to CreateRoom`
- `test: update tests after Room module rename`
- `docs: update README to reflect Room naming`

### ✅ II. Test Coverage for Changes
**Status**: PASS
**Compliance**: This is a refactoring task. Existing tests verify that behavior is preserved. Tests will be updated in each commit to match the renamed modules and must pass before proceeding.

### ✅ III. Atomic Commits
**Status**: PASS
**Compliance**: Implementation will follow atomic commit strategy:
1. Rename core module file + update its contents + update its tests
2. Rename supervisor module file + update its contents + update its tests
3. Rename each use case file + update contents + update tests
4. Update remaining references in other files
5. Update documentation

Each commit is independently reviewable and testable.

### ✅ IV. Test Execution Gate
**Status**: PASS
**Compliance**: After each commit, `mix test` will be executed. No commit proceeds until tests pass.

### ✅ V. Zero Regressions
**Status**: PASS
**Compliance**: Final verification runs entire test suite. Success criteria SC-001 requires all tests pass with zero failures.

### Constitutional Compliance Summary
**Overall**: ✅ COMPLIANT - No violations detected. Refactoring approach aligns with all constitutional principles.

## Project Structure

### Documentation (this feature)

```text
specs/001-remove-chat-prefix/
├── plan.md              # This file
├── research.md          # Refactoring strategy and naming conventions
├── data-model.md        # Module dependency graph (before/after)
├── quickstart.md        # Step-by-step refactoring guide
└── checklists/
    └── requirements.md  # Quality checklist (already complete)
```

### Source Code (repository root)

```text
lib/ex_chat/
├── room.ex                              # Renamed from chat_room.ex
├── rooms.ex                             # Renamed from chat_rooms.ex
├── user_session.ex
├── user_sessions.ex
├── access_token_repository.ex
├── application.ex                        # References Rooms supervisor
├── setup.ex                              # References RoomRegistry
├── use_cases/
│   ├── create_room.ex                   # Renamed from create_chat_room.ex
│   ├── join_room.ex                     # Renamed from join_chat_room.ex
│   ├── send_message_to_room.ex          # Renamed from send_message_to_chat_room.ex
│   ├── subscribe_to_user_session.ex
│   └── validate_access_token.ex
└── web/
    ├── router.ex
    └── websocket_controller.ex           # References use cases

test/ex_chat/
├── room_test.exs                         # Renamed from chat_room_test.exs
├── user_session_test.exs
├── access_token_repository_test.exs
├── use_cases/
│   ├── create_room_test.exs             # Renamed from create_chat_room_test.exs
│   ├── join_room_test.exs               # Renamed from join_chat_room_test.exs
│   ├── send_message_to_room_test.exs    # Renamed from send_message_to_chat_room_test.exs
│   ├── subscribe_to_user_session_test.exs
│   └── validate_access_token_test.exs
└── web/
    └── websocket_acceptance_test.exs
```

**Structure Decision**: This is a single Elixir OTP application with standard lib/test structure. The refactoring affects modules in the main namespace (ExChat.Room, ExChat.Rooms) and use case modules. No structural changes are required beyond file renames.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

N/A - No constitutional violations. This refactoring is straightforward and compliant.

---

## Phase 0: Research & Strategy

**Status**: Complete (see research.md)

### Research Objectives

1. **Elixir Module Renaming Best Practices**: Document the safe approach to renaming modules in Elixir
2. **Git History Preservation**: Confirm `git mv` preserves file history for renames
3. **Registry Impact Analysis**: Verify that renaming `ChatRoomRegistry` to `RoomRegistry` won't affect runtime lookups
4. **Dependency Graph**: Map all module dependencies to determine optimal refactoring order

### Key Findings

- **Module References**: Elixir modules are atoms - renaming requires updating all `alias`, `import`, `use`, and direct module references
- **File Naming**: Elixir convention is snake_case filenames matching module names (ChatRoom → chat_room.ex, Room → room.ex)
- **Registry**: Registry names are atoms registered at application startup - renaming requires updating application.ex and setup.ex
- **Test Order**: Refactor from leaf modules up to supervisor to minimize test failures between commits
- **Git Best Practice**: Use `git mv` to preserve blame history, then update contents in the same commit

---

## Phase 1: Design & Refactoring Strategy

**Prerequisites**: research.md complete

### Refactoring Order (Dependency-Driven)

Based on module dependency analysis, refactor in this order to minimize breaking changes:

1. **ChatRoom** (leaf module - no dependencies on other room modules)
2. **Use Cases** (depend on ChatRoom/ChatRooms but are independently updatable)
3. **ChatRooms** (supervisor - depends on ChatRoom)
4. **Registry** (referenced by ChatRooms and setup)
5. **Supporting Files** (application.ex, setup.ex, websocket_controller.ex)
6. **Documentation** (README.md)

### Module Mapping

| Old Module | New Module | File Rename |
|------------|------------|-------------|
| ExChat.ChatRoom | ExChat.Room | lib/ex_chat/chat_room.ex → lib/ex_chat/room.ex |
| ExChat.ChatRooms | ExChat.Rooms | lib/ex_chat/chat_rooms.ex → lib/ex_chat/rooms.ex |
| ExChat.ChatRoomRegistry | ExChat.RoomRegistry | Referenced in application.ex and setup.ex (not a file) |
| ExChat.UseCases.CreateChatRoom | ExChat.UseCases.CreateRoom | lib/ex_chat/use_cases/create_chat_room.ex → create_room.ex |
| ExChat.UseCases.JoinChatRoom | ExChat.UseCases.JoinRoom | lib/ex_chat/use_cases/join_chat_room.ex → join_room.ex |
| ExChat.UseCases.SendMessageToChatRoom | ExChat.UseCases.SendMessageToRoom | lib/ex_chat/use_cases/send_message_to_chat_room.ex → send_message_to_room.ex |

### Reference Update Strategy

For each renamed module, update:
- **Module definition**: `defmodule ExChat.ChatRoom` → `defmodule ExChat.Room`
- **Aliases**: `alias ExChat.ChatRoom` → `alias ExChat.Room`
- **Direct references**: `ExChat.ChatRoom.join(pid, ...)` → `ExChat.Room.join(pid, ...)`
- **Registry tuples**: `{ChatRoomRegistry, name}` → `{RoomRegistry, name}`
- **Test modules**: `defmodule ExChat.ChatRoomTest` → `defmodule ExChat.RoomTest`
- **String references in tests**: `"chatroom"` → maintain (these are user-visible room names, not code)

### Testing Strategy

After each file rename and content update:
1. Run `mix test` to verify no regressions
2. If tests fail, fix immediately before proceeding
3. Commit only when tests pass (per Constitution Principle IV)

**Final Verification**:
- `mix test` - all tests pass
- `mix compile --warnings-as-errors` - clean compilation
- `grep -r "ChatRoom" lib/ test/` - returns zero results (excluding specs/)
- `find . -name "*chat_room*"` - returns zero results (excluding specs/, .git/)

---

## Artifacts Generated

This plan does not require traditional artifacts (data-model.md, contracts/, quickstart.md) in the same way a feature implementation would. Instead, we generate:

### research.md
Documents refactoring strategy, Elixir module conventions, and dependency analysis.

### data-model.md
Module dependency graph showing:
- Current dependencies (who imports/calls whom)
- Refactoring order (based on dependency direction)
- Impact radius (which files reference each module)

### quickstart.md
Step-by-step refactoring execution guide with exact commands:
- Each git mv command
- Test execution checkpoints
- Verification commands

---

## Next Steps

1. Review this plan with stakeholders
2. Execute `/speckit.tasks` to generate atomic task list from this plan
3. Execute tasks following the constitutional workflow (atomic commits, test gates, semantic commits)
4. Create PR with Context + This PR sections per constitution
