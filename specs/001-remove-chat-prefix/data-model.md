# Data Model: Module Dependency Graph

**Feature**: Remove Chat Prefix from Room Modules
**Date**: 2025-11-10

## Overview

This document maps the module dependencies and renaming impact for the ExChat refactoring. Since this is a refactoring task (not a new feature), the "data model" here refers to the **module architecture** and how modules depend on each other.

## Module Dependency Graph (Current State)

```text
┌─────────────────────────────────────────────────────────────────┐
│                      ExChat.Application                         │
│  (Supervises ChatRoomRegistry, ChatRooms, UserSessions)        │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ├──► ChatRoomRegistry (Registry)
                        │
                        ├──► ExChat.ChatRooms (DynamicSupervisor)
                        │         │
                        │         ├──► spawns → ExChat.ChatRoom (GenServer)
                        │         └──► looks up via → ChatRoomRegistry
                        │
                        └──► ExChat.UserSessions (DynamicSupervisor)
                                  └──► spawns → ExChat.UserSession (GenServer)

┌─────────────────────────────────────────────────────────────────┐
│                    Use Case Layer                               │
├─────────────────────────────────────────────────────────────────┤
│  ExChat.UseCases.CreateChatRoom                                │
│      └──► calls → ExChat.ChatRooms.create/1                    │
│                                                                 │
│  ExChat.UseCases.JoinChatRoom                                  │
│      └──► calls → ExChat.ChatRooms.join/2                      │
│                                                                 │
│  ExChat.UseCases.SendMessageToChatRoom                         │
│      └──► calls → ExChat.ChatRooms.send/2                      │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    Web Layer                                    │
├─────────────────────────────────────────────────────────────────┤
│  ExChat.Web.WebSocketController                                │
│      ├──► calls → ExChat.UseCases.CreateChatRoom               │
│      ├──► calls → ExChat.UseCases.JoinChatRoom                 │
│      └──► calls → ExChat.UseCases.SendMessageToChatRoom        │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    Setup/Initialization                         │
├─────────────────────────────────────────────────────────────────┤
│  ExChat.Setup                                                   │
│      └──► registers → ChatRoomRegistry (initial rooms)         │
└─────────────────────────────────────────────────────────────────┘
```

## Module Renaming Map

### Core Modules

| Current Name | New Name | Type | Dependencies |
|--------------|----------|------|--------------|
| `ExChat.ChatRoom` | `ExChat.Room` | GenServer | None (leaf module) |
| `ExChat.ChatRooms` | `ExChat.Rooms` | DynamicSupervisor | Room, RoomRegistry |
| `ChatRoomRegistry` | `RoomRegistry` | Registry (atom) | None |

### Use Case Modules

| Current Name | New Name | Dependencies |
|--------------|----------|--------------|
| `ExChat.UseCases.CreateChatRoom` | `ExChat.UseCases.CreateRoom` | Rooms |
| `ExChat.UseCases.JoinChatRoom` | `ExChat.UseCases.JoinRoom` | Rooms |
| `ExChat.UseCases.SendMessageToChatRoom` | `ExChat.UseCases.SendMessageToRoom` | Rooms |

### Supporting Modules (References Only - Not Renamed)

| Module | References to Update |
|--------|---------------------|
| `ExChat.Application` | ChatRoomRegistry → RoomRegistry, ChatRooms → Rooms |
| `ExChat.Setup` | ChatRoomRegistry → RoomRegistry |
| `ExChat.Web.WebSocketController` | Use case names (all three) |

## File Impact Radius

### Files with Direct Module Definitions (RENAME + UPDATE)

1. **lib/ex_chat/chat_room.ex** → **lib/ex_chat/room.ex**
   - Module: `ExChat.ChatRoom` → `ExChat.Room`
   - Aliases: None (leaf module)
   - Impact: 1 file to rename + content update

2. **lib/ex_chat/chat_rooms.ex** → **lib/ex_chat/rooms.ex**
   - Module: `ExChat.ChatRooms` → `ExChat.Rooms`
   - Aliases: `alias ExChat.{ChatRoom, ChatRoomRegistry}` → `alias ExChat.{Room, RoomRegistry}`
   - Impact: 1 file to rename + content update

3. **lib/ex_chat/use_cases/create_chat_room.ex** → **lib/ex_chat/use_cases/create_room.ex**
   - Module: `ExChat.UseCases.CreateChatRoom` → `ExChat.UseCases.CreateRoom`
   - Aliases: `alias ExChat.ChatRooms` → `alias ExChat.Rooms`
   - Impact: 1 file to rename + content update

4. **lib/ex_chat/use_cases/join_chat_room.ex** → **lib/ex_chat/use_cases/join_room.ex**
   - Module: `ExChat.UseCases.JoinChatRoom` → `ExChat.UseCases.JoinRoom`
   - Aliases: `alias ExChat.ChatRooms` → `alias ExChat.Rooms`
   - Impact: 1 file to rename + content update

5. **lib/ex_chat/use_cases/send_message_to_chat_room.ex** → **lib/ex_chat/use_cases/send_message_to_room.ex**
   - Module: `ExChat.UseCases.SendMessageToChatRoom` → `ExChat.UseCases.SendMessageToRoom`
   - Aliases: `alias ExChat.ChatRooms` → `alias ExChat.Rooms`
   - Impact: 1 file to rename + content update

### Files with References Only (UPDATE ONLY)

6. **lib/ex_chat/application.ex**
   - Updates: `{ChatRooms, ...}` → `{Rooms, ...}`, `ChatRoomRegistry` → `RoomRegistry`
   - Impact: Aliases/references update

7. **lib/ex_chat/setup.ex**
   - Updates: `ChatRoomRegistry` → `RoomRegistry`
   - Impact: Registry reference update

8. **lib/ex_chat/web/websocket_controller.ex**
   - Updates: Use case aliases (CreateChatRoom → CreateRoom, etc.)
   - Impact: Aliases update

### Test Files (RENAME + UPDATE)

9. **test/ex_chat/chat_room_test.exs** → **test/ex_chat/room_test.exs**
   - Module: `ExChat.ChatRoomTest` → `ExChat.RoomTest`
   - References: `ExChat.ChatRoom` → `ExChat.Room`, `ChatRoomRegistry` → `RoomRegistry`
   - Impact: 1 file to rename + content update

10. **test/ex_chat/use_cases/create_chat_room_test.exs** → **test/ex_chat/use_cases/create_room_test.exs**
    - Module: `ExChat.UseCases.CreateChatRoomTest` → `ExChat.UseCases.CreateRoomTest`
    - References: Use case module name
    - Impact: 1 file to rename + content update

11. **test/ex_chat/use_cases/join_chat_room_test.exs** → **test/ex_chat/use_cases/join_room_test.exs**
    - Module: `ExChat.UseCases.JoinChatRoomTest` → `ExChat.UseCases.JoinRoomTest`
    - References: Use case module name
    - Impact: 1 file to rename + content update

12. **test/ex_chat/use_cases/send_message_to_chat_room_test.exs** → **test/ex_chat/use_cases/send_message_to_room_test.exs**
    - Module: `ExChat.UseCases.SendMessageToChatRoomTest` → `ExChat.UseCases.SendMessageToRoomTest`
    - References: Use case module name
    - Impact: 1 file to rename + content update

### Documentation Files (UPDATE ONLY)

13. **README.md**
    - Updates: Any references to ChatRoom in TODO or documentation
    - Impact: Text updates

## Refactoring Order (Dependency-Safe)

Based on the dependency graph, refactor in this order to ensure dependencies are already updated when a module is refactored:

### Phase 1: Core Module (Leaf Node)
1. ✅ Rename `ChatRoom` → `Room` (no dependencies on other room modules)
   - Files: lib/ex_chat/chat_room.ex, test/ex_chat/chat_room_test.exs

### Phase 2: Supervisor Module
2. ✅ Rename `ChatRooms` → `Rooms` (depends on Room - already renamed)
   - Files: lib/ex_chat/chat_rooms.ex
   - Update: lib/ex_chat/application.ex (supervision tree)

### Phase 3: Registry
3. ✅ Rename `ChatRoomRegistry` → `RoomRegistry`
   - Files: lib/ex_chat/application.ex, lib/ex_chat/setup.ex
   - Already updated in Rooms during Phase 2

### Phase 4: Use Cases (Can Be Done in Parallel)
4. ✅ Rename `CreateChatRoom` → `CreateRoom`
   - Files: lib/ex_chat/use_cases/create_chat_room.ex, test/...
5. ✅ Rename `JoinChatRoom` → `JoinRoom`
   - Files: lib/ex_chat/use_cases/join_chat_room.ex, test/...
6. ✅ Rename `SendMessageToChatRoom` → `SendMessageToRoom`
   - Files: lib/ex_chat/use_cases/send_message_to_chat_room.ex, test/...

### Phase 5: Web Layer
7. ✅ Update `WebSocketController` (depends on use cases - already renamed)
   - Files: lib/ex_chat/web/websocket_controller.ex

### Phase 6: Documentation
8. ✅ Update `README.md`
   - Files: README.md

## Impact Summary

| Category | Files Affected | Modules Renamed | References Updated |
|----------|----------------|-----------------|-------------------|
| Core Modules | 2 | 2 | ~20 |
| Use Cases | 3 | 3 | ~15 |
| Supporting Files | 3 | 0 | ~10 |
| Test Files | 4 | 4 | ~20 |
| Documentation | 1 | 0 | ~5 |
| **TOTAL** | **13** | **9** | **~70** |

## Verification Queries

After refactoring, these queries should return zero results:

```bash
# No module references to old names
grep -r "ChatRoom" lib/ test/ --exclude-dir=.git

# No file names with old pattern
find lib test -name "*chat_room*" -type f

# Clean compilation
mix compile --warnings-as-errors

# All tests pass
mix test
```

## Next Phase

Proceed to quickstart.md for step-by-step execution commands.
