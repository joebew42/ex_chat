# ExChat

This is a simple chat server built in Elixir with the goal to show a real life application of Websockets.

![the sketch](/sketch.png?raw=true)

## Features roadmap

- Multiple Rooms support
- A Websockets server implementation so that we can support web clients
- A minimal frontend to allow users to subscribe to each room, sending messages and receiving messages

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

_Check out the web client at `http://localhost:4000/index.html`_

## Scratchpad

### DOING

### TODO

- Expose a websocket endpoint to join a chatroom and receive messages

### DONE

- Put `how to run tests` and `how to start application` in the `README.md`
- Start the application
- Rename the test folder `exchat` to `ex_chat`
- As a client I can subscribe to a chat room so that I can receive all the messages sent
