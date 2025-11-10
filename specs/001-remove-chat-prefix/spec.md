# Feature Specification: Remove Chat Prefix from Room Modules

**Feature Branch**: `001-remove-chat-prefix`
**Created**: 2025-11-10
**Status**: Draft
**Input**: User description: "I want to rename `ChatRoom`, `ChatRooms` and `Chatroom` to `Room` (basically remove prefix `Chat`)"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Module Naming Simplification (Priority: P1)

As a developer working on the ExChat codebase, I want the room-related modules to use simpler names without the redundant "Chat" prefix, so that the code is clearer and less verbose since the entire application is already a chat system.

**Why this priority**: This is the core refactoring task that addresses naming redundancy throughout the codebase. All other changes depend on this foundational renaming being complete and correct.

**Independent Test**: Can be fully tested by running the entire test suite after renaming all modules, files, and references. The system should behave identically to before the refactoring, with all tests passing.

**Acceptance Scenarios**:

1. **Given** the codebase contains `ChatRoom` module, **When** refactoring is complete, **Then** the module is renamed to `Room` and all references are updated
2. **Given** the codebase contains `ChatRooms` module, **When** refactoring is complete, **Then** the module is renamed to `Rooms` and all references are updated
3. **Given** files are named with `chat_room` prefix, **When** refactoring is complete, **Then** files are renamed to use `room` prefix instead
4. **Given** use cases reference `ChatRoom` in their names, **When** refactoring is complete, **Then** use cases are renamed to reference `Room` instead
5. **Given** all tests reference old module names, **When** refactoring is complete, **Then** tests are updated to use new module names and continue to pass

---

### User Story 2 - Documentation and README Updates (Priority: P2)

As a developer reading the project documentation, I want all references to `ChatRoom` to be updated to `Room`, so that the documentation accurately reflects the current codebase structure.

**Why this priority**: Documentation consistency is important for maintainability but is not blocking for functionality. It can be done after the code refactoring is complete.

**Independent Test**: Can be tested by reviewing all markdown files and documentation to verify no old module names remain, and that all examples reference the updated naming conventions.

**Acceptance Scenarios**:

1. **Given** README.md contains references to old module names, **When** refactoring is complete, **Then** all references are updated to use the new names
2. **Given** TODO items in scratchpad mention old names, **When** refactoring is complete, **Then** TODO items are updated or removed if completed

---

### Edge Cases

- What happens if registry names reference `ChatRoom` and need to be updated without breaking compatibility?
- How do we handle any persisted data or configuration that might reference the old module names?
- Are there any external systems or APIs that reference these module names that would need coordination?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST rename module `ExChat.ChatRoom` to `ExChat.Room` throughout the codebase
- **FR-002**: System MUST rename module `ExChat.ChatRooms` to `ExChat.Rooms` throughout the codebase
- **FR-003**: System MUST rename registry `ChatRoomRegistry` to `RoomRegistry`
- **FR-004**: System MUST rename use case modules to remove "Chat" prefix:
  - `CreateChatRoom` → `CreateRoom`
  - `JoinChatRoom` → `JoinRoom`
  - `SendMessageToChatRoom` → `SendMessageToRoom`
- **FR-005**: System MUST rename all file paths to remove "chat_room" prefix:
  - `lib/ex_chat/chat_room.ex` → `lib/ex_chat/room.ex`
  - `lib/ex_chat/chat_rooms.ex` → `lib/ex_chat/rooms.ex`
  - `lib/ex_chat/use_cases/create_chat_room.ex` → `lib/ex_chat/use_cases/create_room.ex`
  - `lib/ex_chat/use_cases/join_chat_room.ex` → `lib/ex_chat/use_cases/join_room.ex`
  - `lib/ex_chat/use_cases/send_message_to_chat_room.ex` → `lib/ex_chat/use_cases/send_message_to_room.ex`
- **FR-006**: System MUST rename all test files to reflect new module names:
  - `test/ex_chat/chat_room_test.exs` → `test/ex_chat/room_test.exs`
  - `test/ex_chat/use_cases/create_chat_room_test.exs` → `test/ex_chat/use_cases/create_room_test.exs`
  - `test/ex_chat/use_cases/join_chat_room_test.exs` → `test/ex_chat/use_cases/join_room_test.exs`
  - `test/ex_chat/use_cases/send_message_to_chat_room_test.exs` → `test/ex_chat/use_cases/send_message_to_room_test.exs`
- **FR-007**: System MUST update all module references in all Elixir source files (aliases, imports, function calls)
- **FR-008**: System MUST update all references in configuration files, setup files, and application supervision tree
- **FR-009**: System MUST maintain all existing functionality without behavioral changes
- **FR-010**: System MUST pass all existing tests after refactoring with zero regressions
- **FR-011**: System MUST update README.md to reflect the new module names
- **FR-012**: System MUST update or remove completed TODO items in scratchpad that reference old names

### Key Entities

- **Room** (formerly ChatRoom): Represents a chat room GenServer process that manages participant sessions and message broadcasting
- **Rooms** (formerly ChatRooms): Module acting as a DynamicSupervisor managing the lifecycle of Room processes
- **RoomRegistry** (formerly ChatRoomRegistry): Registry for looking up Room processes by name
- **CreateRoom** (formerly CreateChatRoom): Use case for creating new rooms
- **JoinRoom** (formerly JoinChatRoom): Use case for users joining existing rooms
- **SendMessageToRoom** (formerly SendMessageToChatRoom): Use case for sending messages to room participants

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All tests pass after refactoring with zero failures or regressions
- **SC-002**: Codebase search for "ChatRoom" (case-sensitive) returns zero results in source files after refactoring (excluding git history and this spec)
- **SC-003**: Codebase search for "chat_room" returns zero results in file names after refactoring (excluding git history and specs)
- **SC-004**: Application starts and runs without errors after refactoring
- **SC-005**: All existing functionality remains unchanged - users can create rooms, join rooms, and send messages exactly as before
- **SC-006**: Code review confirms consistent naming throughout - all instances of the old names have been systematically replaced

## Assumptions

- The refactoring is purely a naming change and does not involve functional modifications
- There are no external systems or databases that persist the old module names in a way that would require migration
- The Registry uses atoms for lookups, and updating the registry name won't affect runtime behavior
- All references to these modules are within the codebase and can be updated via search-and-replace with proper testing
- The WebSocket protocol and client-side code do not expose module names, so no client changes are needed
