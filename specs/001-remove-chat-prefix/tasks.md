# Tasks: Remove Chat Prefix from Room Modules

**Input**: Design documents from `/specs/001-remove-chat-prefix/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Tests**: Per the project constitution (Principle II: Test Coverage for Changes), existing tests must be updated to match renamed modules and continue passing. This is a refactoring task where tests validate behavior preservation.

**Organization**: Tasks are organized by dependency-safe refactoring order to enable systematic module renaming with test validation at each step.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

## Path Conventions

- **Single Elixir project**: `lib/ex_chat/`, `test/ex_chat/` at repository root
- All paths in this document use absolute paths from repository root

---

## Phase 1: Setup (Prerequisite Verification)

**Purpose**: Verify clean state before refactoring

- [X] T001 Verify all existing tests pass with `mix test`
- [X] T002 Verify clean git working directory with `git status`
- [X] T003 Verify on correct branch: `001-remove-chat-prefix`

**Checkpoint**: Setup complete - ready to begin refactoring

---

## Phase 2: User Story 1 - Module Naming Simplification (Priority: P1) 🎯 MVP

**Goal**: Systematically rename all Chat-prefixed modules to remove redundancy, updating files, module definitions, and all references while maintaining zero regressions.

**Independent Test**: All tests pass after each atomic refactoring step, proving behavior is preserved.

### Step 1: Rename ChatRoom → Room (Leaf Module)

- [X] T004 [US1] Rename file using `git mv lib/ex_chat/chat_room.ex lib/ex_chat/room.ex`
- [X] T005 [US1] Update module definition from `defmodule ExChat.ChatRoom` to `defmodule ExChat.Room` in lib/ex_chat/room.ex
- [X] T006 [US1] Rename test file using `git mv test/ex_chat/chat_room_test.exs test/ex_chat/room_test.exs`
- [X] T007 [US1] Update test module definition from `ExChat.ChatRoomTest` to `ExChat.RoomTest` in test/ex_chat/room_test.exs
- [X] T008 [US1] Update all `ChatRoom` references to `Room` in test/ex_chat/room_test.exs
- [X] T009 [US1] Update `ChatRoomRegistry` references to `RoomRegistry` in test/ex_chat/room_test.exs
- [X] T010 [US1] Run `mix test` to verify Room module tests pass
- [X] T011 [US1] Commit with message: `refactor: rename ChatRoom module to Room`

**Checkpoint**: Room module renamed, tests passing

### Step 2: Rename ChatRooms → Rooms (Supervisor Module)

- [ ] T012 [US1] Rename file using `git mv lib/ex_chat/chat_rooms.ex lib/ex_chat/rooms.ex`
- [ ] T013 [US1] Update module definition from `defmodule ExChat.ChatRooms` to `defmodule ExChat.Rooms` in lib/ex_chat/rooms.ex
- [ ] T014 [US1] Update alias from `alias ExChat.{ChatRoom, ChatRoomRegistry}` to `alias ExChat.{Room, RoomRegistry}` in lib/ex_chat/rooms.ex
- [ ] T015 [US1] Update all `ChatRoom` function calls to `Room` in lib/ex_chat/rooms.ex
- [ ] T016 [US1] Update `ChatRoomRegistry` references to `RoomRegistry` in lib/ex_chat/rooms.ex
- [ ] T017 [US1] Update supervision tree: change `{ChatRooms, ...}` to `{Rooms, ...}` in lib/ex_chat/application.ex
- [ ] T018 [US1] Update registry definition: change `name: ChatRoomRegistry` to `name: RoomRegistry` in lib/ex_chat/application.ex
- [ ] T019 [US1] Update registry references from `ChatRoomRegistry` to `RoomRegistry` in lib/ex_chat/setup.ex
- [ ] T020 [US1] Run `mix test` to verify Rooms module and supervision tree work correctly
- [ ] T021 [US1] Commit with message: `refactor: rename ChatRooms module to Rooms and update registry`

**Checkpoint**: Rooms supervisor renamed, registry updated, tests passing

### Step 3: Rename Use Case - CreateChatRoom → CreateRoom

- [ ] T022 [US1] Rename file using `git mv lib/ex_chat/use_cases/create_chat_room.ex lib/ex_chat/use_cases/create_room.ex`
- [ ] T023 [US1] Update module definition from `defmodule ExChat.UseCases.CreateChatRoom` to `defmodule ExChat.UseCases.CreateRoom` in lib/ex_chat/use_cases/create_room.ex
- [ ] T024 [US1] Update alias from `alias ExChat.ChatRooms` to `alias ExChat.Rooms` in lib/ex_chat/use_cases/create_room.ex
- [ ] T025 [US1] Update all `ChatRooms` function calls to `Rooms` in lib/ex_chat/use_cases/create_room.ex
- [ ] T026 [US1] Rename test file using `git mv test/ex_chat/use_cases/create_chat_room_test.exs test/ex_chat/use_cases/create_room_test.exs`
- [ ] T027 [US1] Update test module definition from `ExChat.UseCases.CreateChatRoomTest` to `ExChat.UseCases.CreateRoomTest` in test/ex_chat/use_cases/create_room_test.exs
- [ ] T028 [US1] Update all `CreateChatRoom` references to `CreateRoom` in test/ex_chat/use_cases/create_room_test.exs
- [ ] T029 [US1] Run `mix test` to verify CreateRoom use case tests pass
- [ ] T030 [US1] Commit with message: `refactor: rename CreateChatRoom use case to CreateRoom`

**Checkpoint**: CreateRoom use case renamed, tests passing

### Step 4: Rename Use Case - JoinChatRoom → JoinRoom

- [ ] T031 [US1] Rename file using `git mv lib/ex_chat/use_cases/join_chat_room.ex lib/ex_chat/use_cases/join_room.ex`
- [ ] T032 [US1] Update module definition from `defmodule ExChat.UseCases.JoinChatRoom` to `defmodule ExChat.UseCases.JoinRoom` in lib/ex_chat/use_cases/join_room.ex
- [ ] T033 [US1] Update alias from `alias ExChat.ChatRooms` to `alias ExChat.Rooms` in lib/ex_chat/use_cases/join_room.ex
- [ ] T034 [US1] Update all `ChatRooms` function calls to `Rooms` in lib/ex_chat/use_cases/join_room.ex
- [ ] T035 [US1] Rename test file using `git mv test/ex_chat/use_cases/join_chat_room_test.exs test/ex_chat/use_cases/join_room_test.exs`
- [ ] T036 [US1] Update test module definition from `ExChat.UseCases.JoinChatRoomTest` to `ExChat.UseCases.JoinRoomTest` in test/ex_chat/use_cases/join_room_test.exs
- [ ] T037 [US1] Update all `JoinChatRoom` references to `JoinRoom` in test/ex_chat/use_cases/join_room_test.exs
- [ ] T038 [US1] Run `mix test` to verify JoinRoom use case tests pass
- [ ] T039 [US1] Commit with message: `refactor: rename JoinChatRoom use case to JoinRoom`

**Checkpoint**: JoinRoom use case renamed, tests passing

### Step 5: Rename Use Case - SendMessageToChatRoom → SendMessageToRoom

- [ ] T040 [US1] Rename file using `git mv lib/ex_chat/use_cases/send_message_to_chat_room.ex lib/ex_chat/use_cases/send_message_to_room.ex`
- [ ] T041 [US1] Update module definition from `defmodule ExChat.UseCases.SendMessageToChatRoom` to `defmodule ExChat.UseCases.SendMessageToRoom` in lib/ex_chat/use_cases/send_message_to_room.ex
- [ ] T042 [US1] Update alias from `alias ExChat.ChatRooms` to `alias ExChat.Rooms` in lib/ex_chat/use_cases/send_message_to_room.ex
- [ ] T043 [US1] Update all `ChatRooms` function calls to `Rooms` in lib/ex_chat/use_cases/send_message_to_room.ex
- [ ] T044 [US1] Rename test file using `git mv test/ex_chat/use_cases/send_message_to_chat_room_test.exs test/ex_chat/use_cases/send_message_to_room_test.exs`
- [ ] T045 [US1] Update test module definition from `ExChat.UseCases.SendMessageToChatRoomTest` to `ExChat.UseCases.SendMessageToRoomTest` in test/ex_chat/use_cases/send_message_to_room_test.exs
- [ ] T046 [US1] Update all `SendMessageToChatRoom` references to `SendMessageToRoom` in test/ex_chat/use_cases/send_message_to_room_test.exs
- [ ] T047 [US1] Run `mix test` to verify SendMessageToRoom use case tests pass
- [ ] T048 [US1] Commit with message: `refactor: rename SendMessageToChatRoom use case to SendMessageToRoom`

**Checkpoint**: SendMessageToRoom use case renamed, tests passing

### Step 6: Update WebSocket Controller

- [ ] T049 [US1] Update use case aliases in lib/ex_chat/web/websocket_controller.ex: `CreateChatRoom` → `CreateRoom`, `JoinChatRoom` → `JoinRoom`, `SendMessageToChatRoom` → `SendMessageToRoom`
- [ ] T050 [US1] Update all use case function calls to use new names in lib/ex_chat/web/websocket_controller.ex
- [ ] T051 [US1] Run `mix test` to verify WebSocket acceptance tests pass
- [ ] T052 [US1] Commit with message: `refactor: update WebSocketController to use renamed use cases`

**Checkpoint**: WebSocket controller updated, all tests passing

### Step 7: Final Verification

- [ ] T053 [US1] Run `mix clean && mix compile --warnings-as-errors` to verify clean compilation
- [ ] T054 [US1] Run `mix test` to verify entire test suite passes with zero failures
- [ ] T055 [US1] Verify no old names remain: `grep -r "ChatRoom" lib/ test/ | grep -v specs/ | wc -l` should return 0
- [ ] T056 [US1] Verify no old filenames remain: `find lib test -name "*chat_room*" -type f | wc -l` should return 0
- [ ] T057 [US1] Verify application starts without errors: `mix run --no-halt` (Ctrl+C to stop after verification)

**Checkpoint**: User Story 1 complete - all modules renamed, tests passing, zero regressions

---

## Phase 3: User Story 2 - Documentation and README Updates (Priority: P2)

**Goal**: Update documentation to reflect the new module naming conventions

**Independent Test**: Review of markdown files confirms no old module names remain

### Documentation Updates

- [ ] T058 [US2] Update README.md: Mark completed TODO item "Rename `ChatRoom`, `ChatRooms` and `Chatroom` to `Room`" as DONE or remove it
- [ ] T059 [US2] Review README.md for any other references to ChatRoom in documentation sections and update to Room
- [ ] T060 [US2] Commit with message: `docs: update README after Room module refactoring`

**Checkpoint**: Documentation updated to reflect new naming

---

## Phase 4: Polish & Final Validation

**Purpose**: Final checks and cleanup

- [ ] T061 Run full test suite one final time: `mix test`
- [ ] T062 Verify code compiles cleanly: `mix compile --warnings-as-errors`
- [ ] T063 Run application startup test: `iex -S mix` (verify modules load, then exit)
- [ ] T064 Verify success criteria SC-002: `grep -r "ChatRoom" lib/ test/ --exclude-dir=specs` returns zero results
- [ ] T065 Verify success criteria SC-003: `find lib test -name "*chat_room*"` returns zero results

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **User Story 1 (Phase 2)**: Depends on Setup completion
  - Must follow strict sequential order within steps (T004 → T011, then T012 → T021, etc.)
  - Use cases (Steps 3-5) must complete AFTER Rooms is renamed (Step 2)
  - WebSocket controller (Step 6) must complete AFTER all use cases are renamed
- **User Story 2 (Phase 3)**: Depends on User Story 1 completion
- **Polish (Phase 4)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Setup - No dependencies on other stories
- **User Story 2 (P2)**: Depends on User Story 1 completion (code must be refactored before docs updated)

### Within User Story 1 (CRITICAL - Sequential Execution Required)

**Step Order** (must follow this sequence):
1. Room module (T004-T011) - leaf module, no dependencies
2. Rooms module (T012-T021) - depends on Room being renamed
3. CreateRoom use case (T022-T030) - depends on Rooms being renamed
4. JoinRoom use case (T031-T039) - depends on Rooms being renamed
5. SendMessageToRoom use case (T040-T048) - depends on Rooms being renamed
6. WebSocketController (T049-T052) - depends on all use cases being renamed
7. Final verification (T053-T057)

**IMPORTANT**: Each step must complete (including test verification and commit) before the next step begins. This ensures:
- Git history is clean and atomic
- Tests pass at every commit (Constitution Principle IV)
- Each commit is independently reviewable

### Parallel Opportunities

**None** - This refactoring must be done sequentially because:
- Each module rename affects files that depend on it
- Module references must be updated atomically within each step
- Test verification gates prevent moving to next step until current step passes
- Git commits create atomic, reviewable checkpoints

---

## Implementation Strategy

### Sequential Refactoring (Required Approach)

This refactoring requires strict sequential execution due to module dependencies:

1. **Setup** (Phase 1) - Verify clean state
2. **User Story 1** (Phase 2) - Complete all 7 steps in order:
   - Step 1: Room module (leaf)
   - Step 2: Rooms module (supervisor)
   - Steps 3-5: Use cases (depend on Rooms)
   - Step 6: WebSocket controller (depends on use cases)
   - Step 7: Final verification
3. **User Story 2** (Phase 3) - Documentation updates
4. **Polish** (Phase 4) - Final validation

**Test Gates**: After every file rename and content update (Constitution Principle IV):
- Run `mix test`
- If tests pass → commit and proceed
- If tests fail → fix immediately before proceeding

**Commit Strategy** (Constitution Principles I & III):
- Use semantic commit prefixes: `refactor:`, `docs:`
- One logical change per commit (each step = one commit)
- Commit only when tests pass

---

## Notes

- All tasks follow dependency-safe order based on module dependency graph
- Each task includes exact file paths for clarity
- Test verification gates ensure zero regressions (Constitution Principle V)
- Atomic commits enable easy review and rollback if needed
- No parallel execution possible - all tasks are sequential due to dependencies
- Success criteria (SC-001 through SC-006) verified throughout and in final validation
