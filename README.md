# ExChat

This is a simple chat server built in Elixir with the goal to show a real life application of Websockets.

![the sketch](/sketch.png?raw=true)

## Features roadmap

- As a client I want to create a user so that I can use the chat system
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

## How to use the chat

The web client will be available at `http://localhost:4000/chat.html`

At the moment there are two users in the system. You can use two different URLs in order to get associated to them:

- `http://localhost:4000/chat.html?access_token=foo_token` to enter as _foo_user_
- `http://localhost:4000/chat.html?access_token=bar_token` to enter as _bar_user_

## Scratchpad

### DOING



### TODO

See [open issues](https://github.com/joebew42/ex_chat/issues) for the full list of planned work.

### DONE

- Try to decouple the `WebSocketController` from the Application Domain by introducing the Use Cases:
- Extract a use case for `SubscribeToUserSession`
- Extract a use case for `JoinChatRoom`
- Extract a use case for `CreateChatRoom`
- Extract a use case for `SendMessageToChatRoom`
- Extract a use case for `ValidateAccessToken`
- Should the `WebSocketClient` be renamed in [`WebSocketController`](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html) ?
- As a client I want to be associated to a user so that other clients can see who send messages
- Prepare the system with some initial data:
  - `foo_user` associated to the token `foo_token`
  - `bar_user` associated to the token `bar_token`
- Maybe the `AuthenticationService` is a "Repository" instead. Consider to rename it
- Provide a real implementation of the `AuthenticationService`
- Extract a collaborator for the `WebSocketClient` that will be responsible to understand if there is an existing user_session for a given access_token
- Update the UI in order to handle the user id
- It seems that we have a [websocket idle timeout issue](https://ninenines.eu/docs/en/cowboy/2.4/guide/ws_handlers/#_keeping_the_connection_alive). Increase the idle timeout to 10 minutes
- Handle the connection when the provided access token is empty or not valid (no user session associated)
- what happen when we try to connect to the chat with an invalid access token
  - 1) the token not exist or is not valid [DONE]
  - 2) no token provided [DONE]
- Bump to version 2.4 to fix the issue of cowboy 1.0 about the [`cowboy_clock badarg`](https://github.com/ninenines/cowboy/issues/820)
- When I join a chat room as an identified user I want to read my user name in the welcome message
- Extract the websocket chat URL in the `WebSocketAcceptanceTests`
- Rename `ws_client` to `client` in the `WebSocketAcceptanceTests`
- Try to remove all the setup duplication in the `WebSocketAcceptanceTests`
- Review all the acceptance tests in order to align it with the User Feature
- Use the access_token to open websocket connection from the UI
- Try to associate a WebSocketClient to a UserSession
- Draw the actual application architecture sketch
- Think about to rename `ExChat.Supervisor` in `ExChat.Application`
- Rename `ExChat.Init` to `ExChat.Setup`
- Put the `user-session-id` as a state of `WebSocketClient`
- Find a better name for the websocket tests
- Rename `ExChat.Web.WebSocket` to `ExChat.Web.Router`
- Rename `ChatRoomsWebSocketHandler` to `WebSocketClient`
- `ChatRooms.send` should use the `user-session-id`
- The module `ChatRooms` should be reorganized like the `UserSessions`
- As a `ChatRoom` I can notify of new messages to all the subscribed `UserSession`s
- rename the `UserSessions.send` to `UserSessions.notify`
- think to rename `clients` to `session_ids` in the `ChatRoom` process
- Rename `ExChat.Registry` in `ExChat.ChatRoomRegistry`
- rename `user_session_id` to `session_id`
- Maybe the `UserSessions` and `UserSessionSupervisor` could be merged in a single module named `UserSessions`
- Fix the names used for the user sessions in the `UserSessionsTest`
- Try to find a way to remove the shared state (the `UserSessionRegistry`) from the `UserSessions` Tests
- do not start the application when run all the tests
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
