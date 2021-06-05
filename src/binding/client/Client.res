open ClientOptions

type client_t

module Client = {
    @module("discord.js") @new external make: option<client_options> => client_t = "Client"
    
    @send external on: (client_t, @string [
        | #ready(unit => unit)
        | #message(Message.message => unit)
    ]) => unit = "on"

    @send external once: (client_t, @string [
        | #ready(unit => unit)
        | #message(Message.message => unit)
    ]) => unit = "once"

    @get external get_user: client_t => option<ClientUser.client_user_t> = "user"

    @send external login: client_t => string => Js.Promise.t<string> = "login"
}