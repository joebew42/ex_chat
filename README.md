# ExChat

This is a simple chat server built in Elixir with the goal to show a real life application of Websockets.

![the sketch](/sketch.png?raw=true)

## Features roadmap

- As a client I want to be associated to a user so that other client can see who send messages
- As a user I can send a private message to an existing user to that I can talk directly without using an existing room

## Run tests

```
$ mix deps.get
$ mix test
```

## Run application

```
$ mix deps.get
$ iex -S mix
```

_Check out the chat web client at `http://localhost:4000/chat.html`_

## Scratchpad

Feature:

As a client I want to be associated to a user so that other client can see who send messages

### DOING

- Try to find a way to remove the shared state (the `UserSessionRegistry`) from the `UserSessions` Tests
 - Try to investigate this strange issue:

```
 ** (exit) exited in: GenServer.call(:user_session_supervisor, {:start_child, [{:via, Registry, {ExChat.TestRegistry, "xxx"}}]}, :infinity)
         ** (EXIT) no process: the process is not alive or there's no process currently associated with the given name, possibly because its application isn't started
```

When run `mix test`

### TODO

- Maybe the `UserSessions` and `UserSessionSupervisor` can be merged in a single module named `AllUserSessions`
- rename `user_session_id` with `user_id`
- think to rename `clients` in `subscribers` in both `UserSession` and `ChatRoom` process
- as a `UserSession` I can join a chatroom
- as a `UserSession` I can send messages to a chatroom
- Think about to rename or remove `UserSessions.send` (it could be renamed in `UserSessions.notify` ???)
- Rename `ExChat.Registry` in `ExChat.ChatRoomRegistry`
- We may have to think to store the `user_id` of the user in the `state` of the `ChatRoomsWebSocketHandler`
- When I join a chat room as an identified user I want to read my user name in the welcome message
- We read in the console "Application logger stopped temporary" every time we run tests
- unsubscribe a client to receive messages once it leaves the chat
- improve the way we make assertions on received messages (e.g. assert_receive wants pattern match and not functions or variables) in the `websocket_test.exs`
- in `ChatRooms` there is no need of `:room` atom for the messages `{:join, client, :room, room}`, `{:send, message, :room, room}` and `{:create, :room, room}`
- find a way to distribute the Chat, in order to use more than one nodes
  - we have to think to introduce [`gproc`](https://github.com/uwiger/gproc) for distribute the lookup processes across different nodes
- try to write some acceptance test (e.g. gherkin/cucumber for elixir? or use ExUnit?)
- setup a continuous integration for the project (e.g. using TravisCI)
- try to expose the chat using the [IRC protocol](https://tools.ietf.org/html/rfc1459)
- it seems that we have some flaky tests for "other clients" scenarios

### DONE

- remove the `UserSession.exists?` function in favor of the `UserSession.find` function
- Refactor the `UserSessions` module in order to achieve the obvious implementation with Supervisors, UserSession Processes, etc, ...
- Start writing test from the point of view of the `Client` who tries to subscribe to `UserSessions`
- `ExChat.ChatRooms` could be a "simple" module and not a process
- remove the empty file `ex_chat_test.exs`
- Issue during run the tests: It seems that `Elixir.ExChat.Supervisor` is already started
- handle invalid command
- handle invalid client messages
- rename `subscribers` to `clients` in `ChatRoom`
- bug: avoid that a client can join twice to a room
- add a `Supervisor` to supervise all the `ChatRoom` processes
- use a [registry](https://hexdocs.pm/elixir/master/Registry.html) to name all the `ChatRoom` processes
- think to rename the websocket endpoint (`ws://localhost:4000/room`), maybe `/chat` or others
- handle the welcome message in the `ChatRoom` itself and not in the `chatroom_websocket_handler`
- handle the case when we try to send a message to an unexisting chat room
- update the roadmap features in the readme
- maybe `ExChat.Web.Router` is not a good name for the web sockets delivery mechanism (maybe `Web.WebSocket`)
- rename `chatroom_websocket_handler.ex` to `chat_rooms_websocket_handler.ex`
- think to separate the two actions `create chatroom` and `join chatroom` (at the moment the chatroom creation happens when a client try to join an unexisting chatroom, look at the `ChatRooms.create_and_join_chatroom/3` function)
- update the UI so that it can support the create command
- Handle multiple chat rooms
- adapt the UI to handle the room name
- handle the chat room creation when client wants to join to an unexisting chat room
- rename `subscriber` to `client` in `ChatRooms`
- change the format of the response for other tests (add the room name)
- Rename `web.http` to `web.router`
- Remove the `/echo` endpoint just because it is no longer needed
- Allow web clients to receive messages
- Allow web clients to write and send messages
  - We have to create a better web UI to allows user to write and send messages
- Replace the `plug-web-socket` with the default `cowboy_websocket_handler`
- Allow web clients to join a chatroom
- How to test the websocket endpoint in Elixir
- Put `how to run tests` and `how to start application` in the `README.md`
- Start the application
- Rename the test folder `exchat` to `ex_chat`
- As a client I can subscribe to a chat room so that I can receive all the messages sent
