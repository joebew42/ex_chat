# ExChat

This is a simple chat server built in Elixir with the goal to show a real life application of Websockets.

![the sketch](/sketch.png?raw=true)

## Features roadmap

- Introduce the concept of User
- ...

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

### DOING


### TODO

- promote the `ChatRooms` to be a `Supervisor` instead of being a `GenServer`
- As a client I want to connect with my username so that others can see the name of the user who send the messages
- BUG: Avoid that a subscribed client can subscribe twice to the same room
- Unsubscribe a client to receive messages once it leave the chat
- It seems that we have some flaky tests for "other clients" scenarios
- improve the way we make assertions on received messages (e.g. assert_receive wants pattern match and not functions or variables)
- handle invalid client messages
- Setup a continuous integration for the project (e.g. using TravisCI)
- try to write some acceptance test (e.g. gherkin/cucumber for elixir? or use ExUnit?)
- find a way to distribute the Chat, in order to use more than one nodes
- in `ChatRooms` there is not need of `:room` atom for the messages `{:join, client, :room, room}`, `{:send, message, :room, room}` and `{:create, :room, room}`
- try to expose the chat using the [IRC protocol](https://tools.ietf.org/html/rfc1459)

### DONE

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
