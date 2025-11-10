# Quickstart: Refactoring Execution Guide

**Feature**: Remove Chat Prefix from Room Modules
**Date**: 2025-11-10

## Prerequisites

- On branch: `001-remove-chat-prefix`
- All tests currently passing: `mix test`
- Clean working directory: `git status` shows no uncommitted changes

## Execution Workflow

This guide provides exact commands for each refactoring step. Follow the order precisely to maintain working state at each commit.

---

## Phase 1: Rename ChatRoom → Room

### Step 1.1: Rename module file and update contents

```bash
# Rename the file (preserves git history)
git mv lib/ex_chat/chat_room.ex lib/ex_chat/room.ex

# Edit the file to update module name
# Change: defmodule ExChat.ChatRoom do
# To:     defmodule ExChat.Room do
```

### Step 1.2: Rename test file and update contents

```bash
# Rename test file
git mv test/ex_chat/chat_room_test.exs test/ex_chat/room_test.exs

# Edit the test file to update module names
# Change: defmodule ExChat.ChatRoomTest do
# To:     defmodule ExChat.RoomTest do
# Change: alias ExChat.{ChatRoom, ChatRoomRegistry}
# To:     alias ExChat.{Room, RoomRegistry}
# Change: All references to ChatRoom in tests
# To:     Room
```

### Step 1.3: Test and commit

```bash
# Run tests
mix test

# If tests pass, commit
git add -A
git commit -m "refactor: rename ChatRoom module to Room"

# If tests fail, fix issues before committing
```

**Expected Test Status**: ⚠️ Some tests may fail because ChatRooms still references ChatRoom. This is expected - we'll fix it in the next phase.

---

## Phase 2: Rename ChatRooms → Rooms

### Step 2.1: Rename module file and update contents

```bash
# Rename the file
git mv lib/ex_chat/chat_rooms.ex lib/ex_chat/rooms.ex

# Edit the file to update module name and references
# Change: defmodule ExChat.ChatRooms do
# To:     defmodule ExChat.Rooms do
# Change: alias ExChat.{ChatRoom, ChatRoomRegistry}
# To:     alias ExChat.{Room, RoomRegistry}
# Change: All ChatRoom function calls
# To:     Room function calls
```

### Step 2.2: Update application.ex

```bash
# Edit lib/ex_chat/application.ex
# Change: {ChatRooms, ...}
# To:     {Rooms, ...}
# Change: {Registry, keys: :unique, name: ChatRoomRegistry}
# To:     {Registry, keys: :unique, name: RoomRegistry}
```

### Step 2.3: Test and commit

```bash
# Run tests
mix test

# Commit if tests pass
git add -A
git commit -m "refactor: rename ChatRooms module to Rooms"
```

**Expected Test Status**: ✅ Tests should pass now that Room and Rooms are consistently renamed.

---

## Phase 3: Rename Use Case - CreateChatRoom → CreateRoom

### Step 3.1: Rename file and update contents

```bash
# Rename the file
git mv lib/ex_chat/use_cases/create_chat_room.ex lib/ex_chat/use_cases/create_room.ex

# Edit the file
# Change: defmodule ExChat.UseCases.CreateChatRoom do
# To:     defmodule ExChat.UseCases.CreateRoom do
# Change: alias ExChat.ChatRooms
# To:     alias ExChat.Rooms
# Change: ChatRooms function calls
# To:     Rooms function calls
```

### Step 3.2: Rename test file and update contents

```bash
# Rename test file
git mv test/ex_chat/use_cases/create_chat_room_test.exs test/ex_chat/use_cases/create_room_test.exs

# Edit the test file
# Change: defmodule ExChat.UseCases.CreateChatRoomTest do
# To:     defmodule ExChat.UseCases.CreateRoomTest do
# Change: alias ExChat.UseCases.CreateChatRoom
# To:     alias ExChat.UseCases.CreateRoom
# Change: CreateChatRoom references
# To:     CreateRoom references
```

### Step 3.3: Test and commit

```bash
# Run tests
mix test

# Commit
git add -A
git commit -m "refactor: rename CreateChatRoom use case to CreateRoom"
```

---

## Phase 4: Rename Use Case - JoinChatRoom → JoinRoom

### Step 4.1: Rename file and update contents

```bash
# Rename the file
git mv lib/ex_chat/use_cases/join_chat_room.ex lib/ex_chat/use_cases/join_room.ex

# Edit the file
# Change: defmodule ExChat.UseCases.JoinChatRoom do
# To:     defmodule ExChat.UseCases.JoinRoom do
# Change: alias ExChat.ChatRooms
# To:     alias ExChat.Rooms
# Change: ChatRooms function calls
# To:     Rooms function calls
```

### Step 4.2: Rename test file and update contents

```bash
# Rename test file
git mv test/ex_chat/use_cases/join_chat_room_test.exs test/ex_chat/use_cases/join_room_test.exs

# Edit the test file
# Change: defmodule ExChat.UseCases.JoinChatRoomTest do
# To:     defmodule ExChat.UseCases.JoinRoomTest do
# Change: alias ExChat.UseCases.JoinChatRoom
# To:     alias ExChat.UseCases.JoinRoom
# Change: JoinChatRoom references
# To:     JoinRoom references
```

### Step 4.3: Test and commit

```bash
# Run tests
mix test

# Commit
git add -A
git commit -m "refactor: rename JoinChatRoom use case to JoinRoom"
```

---

## Phase 5: Rename Use Case - SendMessageToChatRoom → SendMessageToRoom

### Step 5.1: Rename file and update contents

```bash
# Rename the file
git mv lib/ex_chat/use_cases/send_message_to_chat_room.ex lib/ex_chat/use_cases/send_message_to_room.ex

# Edit the file
# Change: defmodule ExChat.UseCases.SendMessageToChatRoom do
# To:     defmodule ExChat.UseCases.SendMessageToRoom do
# Change: alias ExChat.ChatRooms
# To:     alias ExChat.Rooms
# Change: ChatRooms function calls
# To:     Rooms function calls
```

### Step 5.2: Rename test file and update contents

```bash
# Rename test file
git mv test/ex_chat/use_cases/send_message_to_chat_room_test.exs test/ex_chat/use_cases/send_message_to_room_test.exs

# Edit the test file
# Change: defmodule ExChat.UseCases.SendMessageToChatRoomTest do
# To:     defmodule ExChat.UseCases.SendMessageToRoomTest do
# Change: alias ExChat.UseCases.SendMessageToChatRoom
# To:     alias ExChat.UseCases.SendMessageToRoom
# Change: SendMessageToChatRoom references
# To:     SendMessageToRoom references
```

### Step 5.3: Test and commit

```bash
# Run tests
mix test

# Commit
git add -A
git commit -m "refactor: rename SendMessageToChatRoom use case to SendMessageToRoom"
```

---

## Phase 6: Update WebSocket Controller

### Step 6.1: Update use case references

```bash
# Edit lib/ex_chat/web/websocket_controller.ex
# Change: alias ExChat.UseCases.{..., CreateChatRoom, JoinChatRoom, SendMessageToChatRoom}
# To:     alias ExChat.UseCases.{..., CreateRoom, JoinRoom, SendMessageToRoom}
# Change: All use case function calls to use new names
```

### Step 6.2: Test and commit

```bash
# Run tests (including acceptance tests)
mix test

# Commit
git add -A
git commit -m "refactor: update WebSocketController to use renamed use cases"
```

---

## Phase 7: Update Setup

### Step 7.1: Update registry references

```bash
# Edit lib/ex_chat/setup.ex
# Change: ChatRoomRegistry references
# To:     RoomRegistry
```

### Step 7.2: Test and commit

```bash
# Run tests
mix test

# Commit
git add -A
git commit -m "refactor: update Setup to use RoomRegistry"
```

---

## Phase 8: Update Documentation

### Step 8.1: Update README.md

```bash
# Edit README.md
# Update TODO section:
# Change: "Rename `ChatRoom`, `ChatRooms` and `Chatroom` to `Room`"
# To:     Mark as DONE or remove line
```

### Step 8.2: Commit

```bash
# Commit
git add README.md
git commit -m "docs: update README after Room module refactoring"
```

---

## Final Verification

### Verify No Old Names Remain

```bash
# Search for any remaining ChatRoom references (should return nothing)
grep -r "ChatRoom" lib/ test/ --exclude-dir=.git

# Search for any chat_room file names (should return nothing)
find lib test -name "*chat_room*" -type f
```

### Verify Clean Compilation

```bash
# Clean build
mix clean
mix compile --warnings-as-errors
```

### Verify All Tests Pass

```bash
# Run full test suite
mix test

# Expected: All tests pass with 0 failures
```

### Verify Application Runs

```bash
# Start the application
iex -S mix

# In IEx, verify modules load:
# ExChat.Room
# ExChat.Rooms
# ExChat.UseCases.CreateRoom
# ... (should all be available)
```

---

## Success Criteria Checklist

After completing all phases, verify:

- ✅ SC-001: All tests pass with zero failures or regressions
- ✅ SC-002: `grep -r "ChatRoom" lib/ test/` returns zero results
- ✅ SC-003: `find lib test -name "*chat_room*"` returns zero results
- ✅ SC-004: Application starts without errors (`iex -S mix`)
- ✅ SC-005: All functionality unchanged (test suite validates this)
- ✅ SC-006: Consistent naming throughout (verification commands confirm)

---

## Rollback Procedure

If issues arise during refactoring:

```bash
# Reset to last good commit
git reset --hard HEAD

# Or reset to specific commit
git reset --hard <commit-sha>

# Re-run tests to verify
mix test
```

---

## PR Creation

After all commits are complete and verification passes:

```bash
# Push branch
git push origin 001-remove-chat-prefix

# Create PR using gh CLI (per constitution)
gh pr create --title "refactor: remove redundant Chat prefix from module names" --body "$(cat <<'EOF'
## Context

This refactoring addresses naming redundancy in the codebase. The modules `ChatRoom` and `ChatRooms` contain the prefix `Chat` which is redundant since the application is already a chat application. Removing this prefix simplifies the naming and improves code clarity.

## This PR

This PR removes the `Chat` prefix from the following modules and their associated files:
- `ChatRoom` → `Room`
- `ChatRooms` → `Rooms`
- `CreateChatRoom` → `CreateRoom`
- `JoinChatRoom` → `JoinRoom`
- `SendMessageToChatRoom` → `SendMessageToRoom`

All tests have been updated accordingly and continue to pass without any regressions.
EOF
)"
```

---

## Next Steps

After PR is merged:
1. Delete feature branch: `git branch -d 001-remove-chat-prefix`
2. Update main/master: `git checkout master && git pull`
3. Archive spec if needed
