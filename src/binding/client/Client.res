open ClientOptions

type client

@module("discord.js") @new external make: option<client_options> => client = "Client"
    
@send external on: (client, @string [
    | #ready(unit => unit)
    | #message(Message.message => unit)
]) => unit = "on"

@send external once: (client, @string [
    | #ready(unit => unit)
    | #message(Message.message => unit)
]) => unit = "once"

@get external get_user: client => option<ClientUser.client_user> = "user"
@send external login: client => string => Js.Promise.t<string> = "login"