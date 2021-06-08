open ClientOptions
open WebSocketOptions

type interval_id

@module("DotEnv") external config_env: unit => unit = "config"
@val external set_interval: (unit => unit, int) => interval_id = "setInterval"

let options = {
    ws: {
        intents: Intents.all
    },
    fetchAllMembers: true
}

let cmds = Js.Dict.fromArray([("about", About.about), ("ping", Ping.ping),
("response", Response.response), ("eval", Eval.evaluate)])

let () = {
    Random.self_init()
    config_env()
    let token = Util.env->Js.Dict.unsafeGet("TOKEN")
    let prefix = Util.env->Js.Dict.unsafeGet("PREFIX")
    let c = Client.make(Some(options))
    c->Client.once(#ready(() => {
        Js.log("Connected.")
        let user = Client.get_user(c)
        switch user {
            | None => ()
            | Some(u) => {
                let id = ClientUser.get_id(u)
                let username = switch ClientUser.get_username(u) {
                    | None => ""
                    | Some(n) => n
                }
                Js.log(j`Logged in as: $username - ($id)`)
                Js.log(j`Hello, $username is now online.`)
                
                let update_presence = () => {
                    Js.log("Setting presence...")
                    let index = Random.int(Array.length(Constants.presences))
                    let activity = Constants.presences[index]
                    let _ = ClientUser.set_presence(u, {
                        status: "online",
                        activity: {
                            "name": activity,
                            "type": "PLAYING"
                        },
                        afk: false
                    })
                }

                let _ = set_interval(update_presence, 3600 * 1000)
                update_presence()
            }
        }
    }))

    c->Client.on(#message(msg => {
        switch msg.content {
            | None => ()
            | Some(m) => {
                if Js.String.startsWith(prefix, m) {
                    let prefix_length = String.length(prefix)
                    let args = String.sub(m, prefix_length, String.length(m) - prefix_length)
                    |> String.trim |> String.split_on_char(' ')
                    |> Array.of_list
                    
                    if Array.length(args) == 0 {
                        ()
                    } else {
                        let cmd = String.lowercase_ascii(args[0])
                        switch Js.Dict.get(cmds, cmd) {
                            | None => {
                                if Js.String.startsWith("eval", cmd) {
                                    Js.Dict.unsafeGet(cmds, "eval")(msg)
                                } else {
                                    ()
                                }
                            }
                            | Some(inner_cmd) => inner_cmd(msg)
                        }
                    }
                }
            }
        }
    }))
    
    
    let _ = Client.login(c, token)
}