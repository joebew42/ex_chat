# Research: Module Refactoring Strategy

**Feature**: Remove Chat Prefix from Room Modules
**Date**: 2025-11-10
**Status**: Complete

## Overview

This document captures research findings for safely refactoring Elixir modules to remove redundant naming prefixes while preserving git history, maintaining test coverage, and ensuring zero regressions.

## Research Questions & Findings

### 1. Elixir Module Renaming Best Practices

**Question**: What is the safest approach to rename Elixir modules across a codebase?

**Findings**:
- Elixir modules are compile-time constructs represented as atoms
- All references must be updated atomically within a single commit to avoid compilation errors
- Use `git mv` for file renames to preserve blame/history
- After `git mv`, update file contents before committing
- Run `mix compile` to catch any missed references immediately

**Decision**: Use atomic commits where each commit includes:
1. File rename via `git mv`
2. Module definition update in renamed file
3. All reference updates across codebase
4. Test file rename and updates
5. Verification via `mix test`

**Rationale**: This approach ensures the codebase compiles and tests pass at every commit, aligning with Constitution Principles III (Atomic Commits) and IV (Test Execution Gate).

**Alternatives Considered**:
- ❌ Rename all files first, then update references: Would create intermediate broken states
- ❌ Update references first, then rename files: Wouldn't match Elixir naming conventions during intermediate state
- ✅ Atomic per-module commits: Chosen for clean history and testability at each step

---

### 2. Git History Preservation

**Question**: How do we preserve git blame history when renaming files?

**Findings**:
- `git mv old_name new_name` preserves history automatically
- Git uses similarity index to track renames (default threshold 50%)
- `git log --follow new_name` will show pre-rename history
- `git blame` automatically follows renames

**Decision**: Use `git mv` for all file renames.

**Rationale**: Preserves developer context and makes future debugging easier by maintaining complete file history.

**Verification Command**:
```bash
git log --follow --oneline lib/ex_chat/room.ex
# Should show history from when it was chat_room.ex
```

---

### 3. Registry Impact Analysis

**Question**: Does renaming `ChatRoomRegistry` to `RoomRegistry` affect runtime behavior?

**Findings**:
- Registry is started in `application.ex` with name as an atom: `{Registry, keys: :unique, name: ChatRoomRegistry}`
- Registry lookups use the atom: `Registry.lookup(ChatRoomRegistry, room_name)`
- Changing the atom requires:
  - Update in `application.ex` supervision tree
  - Update in all lookup calls (`chat_rooms.ex`, `setup.ex`)
- No runtime migration needed - registries are empty at startup

**Decision**: Rename `ChatRoomRegistry` to `RoomRegistry` by updating all references in a single atomic commit after the Room module is renamed.

**Rationale**: Registry name is purely a code-level identifier with no persistence. Atomic update prevents any mismatch between registration and lookup.

**Files to Update**:
- `lib/ex_chat/application.ex` - Registry supervision
- `lib/ex_chat/rooms.ex` - Lookup calls
- `lib/ex_chat/setup.ex` - Initial room creation

---

### 4. Module Dependency Graph

**Question**: What is the optimal order to refactor modules to minimize intermediate breakage?

**Dependency Analysis**:

```text
ExChat.Room (leaf - no deps on other room modules)
  ├─ used by → ExChat.Rooms
  └─ used by → ExChat.UseCases.{CreateRoom, JoinRoom, SendMessageToRoom}

ExChat.Rooms (supervisor - depends on Room)
  ├─ depends on → ExChat.Room
  ├─ depends on → RoomRegistry
  └─ used by → ExChat.UseCases.{CreateRoom, JoinRoom, SendMessageToRoom}

ExChat.UseCases.CreateRoom
  └─ depends on → ExChat.Rooms

ExChat.UseCases.JoinRoom
  └─ depends on → ExChat.Rooms

ExChat.UseCases.SendMessageToRoom
  └─ depends on → ExChat.Rooms

ExChat.Web.WebSocketController
  └─ depends on → All use cases

ChatRoomRegistry (used by Rooms and Setup)
  └─ referenced in → application.ex, rooms.ex, setup.ex
```

**Decision**: Refactor in this order:
1. `ExChat.ChatRoom` → `ExChat.Room` (no dependencies)
2. `ExChat.ChatRooms` → `ExChat.Rooms` (depends on Room, already renamed)
3. `ChatRoomRegistry` → `RoomRegistry` (after Rooms is renamed)
4. Use cases in any order (all depend on Rooms, already renamed)
5. WebSocketController (after use cases renamed)
6. Documentation (last)

**Rationale**: Bottom-up refactoring (leaves first, root last) ensures dependencies are already updated when a module is refactored.

---

### 5. Test Strategy

**Question**: How do we ensure zero regressions during refactoring?

**Findings**:
- ExChat uses ExUnit for testing
- Test command: `mix test --no-start` (per mix.exs alias)
- Tests cover: Unit tests for modules, use case tests, acceptance tests for WebSocket
- All tests must pass before and after refactoring

**Decision**: Execute `mix test` after each atomic commit. Block progress if any test fails.

**Test Update Strategy**:
- Rename test files to match source files (e.g., `chat_room_test.exs` → `room_test.exs`)
- Update test module names (e.g., `ExChat.ChatRoomTest` → `ExChat.RoomTest`)
- Update test references to renamed modules
- Keep test behavior identical - only names change

**Verification Commands**:
```bash
# After each commit
mix test

# Final verification
mix test --trace                          # Detailed output
mix compile --warnings-as-errors          # Clean compilation
grep -r "ChatRoom" lib/ test/             # Should return nothing
find lib test -name "*chat_room*"         # Should return nothing
```

---

### 6. Edge Cases & Risk Mitigation

**Edge Case: String literals in code**

Some tests or runtime code might use string literals like `"chatroom"` for room names. These should NOT be changed as they represent user-visible data, not code identifiers.

**Example to preserve**:
```elixir
# In tests - room names are user data, not module references
ChatRooms.create("lobby")  # "lobby" is a room name, keep as-is
```

**Edge Case: Comments and documentation**

Update comments that reference old module names to maintain documentation accuracy.

**Example**:
```elixir
# Before:
# Subscribes a client to the ChatRoom process

# After:
# Subscribes a client to the Room process
```

**Risk: Incomplete reference updates**

**Mitigation**:
- Use `grep -r "ChatRoom" lib/ test/` before committing
- Use `mix compile --warnings-as-errors` to catch any missed references
- Run full test suite to catch runtime errors

---

## Summary of Decisions

| Area | Decision | Rationale |
|------|----------|-----------|
| **Refactoring Approach** | Atomic per-module commits | Clean history, testable at each step |
| **File Renaming** | Use `git mv` | Preserves blame history |
| **Refactoring Order** | Bottom-up (leaves → root) | Dependencies already updated |
| **Registry Rename** | Atomic update after modules | Prevents registration/lookup mismatch |
| **Testing** | `mix test` after each commit | Zero regressions (Constitution V) |
| **Verification** | grep + compile + test | Catch all missed references |
| **String Literals** | Keep user-visible strings | Not code identifiers |

---

## Next Phase

Proceed to Phase 1 (data-model.md) to document the module dependency graph in detail.
