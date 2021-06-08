let submission_url = "https://judge0-ce.p.rapidapi.com/submissions?base64_encoded=true&fields=*"
let typescript_id = 74
let max_attempts = 5

let axios_client = () => Axios.create(Axios.axios, {
    baseURL: "https://judge0-ce.p.rapidapi.com",
    headers: Js.Dict.fromArray([("content-type", "application/json"), ("x-rapidapi-key", Util.env->Js.Dict.unsafeGet("RAPID_API_KEY")), ("x-rapidapi-host", "judge0-ce.p.rapidapi.com")])
})

open JudgeZero

let create_eval_request = client => (~b: judge_zero_request_body) => {
    let stringified = switch Js.Json.stringifyAny(b) {
        | None => ""
        | Some(s) => s
    }
    let response: Js.Promise.t<Axios.axios_response<JudgeZero.judge_zero_post_response>> = Axios.post(client, submission_url, stringified)
    let promise = Js.Promise.then_((p: Axios.axios_response<JudgeZero.judge_zero_post_response>) => Js.Promise.resolve(p.data), response)
    promise
}

let get_eval_result = client => token => {
    let response = Axios.get(client, `https://judge0-ce.p.rapidapi.com/submissions/${token}?base64_encoded=true&fields=*`)
    let data: Js.Promise.t<JudgeZero.judge_zero_get_response> = Js.Promise.then_((p: Axios.axios_response<JudgeZero.judge_zero_get_response>) => Js.Promise.resolve(p.data), response)
    let promise = Js.Promise.then_(d => {
        switch Js.Nullable.toOption(d.stdout) {
            | None => Js.Promise.resolve(d)
            | Some(out) when String.length(out) > 0 => {
                let buffer = JsBuffer.from(out, "base64")
                let str = JsBuffer.Buffer.to_string(buffer, ())
                d.stdout = Js.Nullable.fromOption(Some(str))
                Js.Promise.resolve(d)
            }
            | _ => Js.Promise.resolve(d)
        }
    }, data)

    let promise = Js.Promise.then_(d => {
        switch Js.Nullable.toOption(d.compile_output) {
            | None => Js.Promise.resolve(d)
            | Some(out) when String.length(out) > 0 => {
                let buffer = JsBuffer.from(out, "base64")
                let str = JsBuffer.Buffer.to_string(buffer, ())
                d.compile_output = Js.Nullable.fromOption(Some(str))
                Js.Promise.resolve(d)
            }
            | _ => Js.Promise.resolve(d)
        }
    }, promise)
    promise
}

let try_get_eval_result = (~max_attempts=max_attempts) => client => token => {
    let rec get = client' => token' => remains => {
        let response = get_eval_result(client', token')
        Js.Promise.then_(p => {
            switch remains {
                | 0 => if p.status_id == 2 {
                    Js.Promise.resolve(None)
                } else {
                    Js.Promise.resolve(Some(p))
                }
                | _ when p.status_id == 2 => get(client', token', remains - 1)
                | _ => Js.Promise.resolve(Some(p))
            }
        }, response)
    }
    get(client, token, max_attempts)
}

let generate_eval_embed = message => result => {
    switch Js.Nullable.toOption(result.stderr) {
        | Some(stderr) when String.length(stderr) > 0 => {
            let msg = j`アホか！貴様のコードにはエラーが出てきたんだよ：$stderr` ++ (if String.length(Util.unwrap_or(Js.Nullable.toOption(result.message), "")) > 0 {
                `\nまあ、無個性だったらしょうがないな！他のメッセージも送ってやるわ。感謝しろや！${Util.unwrap_or(Js.Nullable.toOption(result.message), "")}`
            } else {
                ""
            })
            let options: TextChannel.message_options = {
                content: Some(msg),
                embed: None
            }
            options
        }
        | _ => {
            switch Js.Nullable.toOption(result.stdout) {
                | None => {
                    switch Js.Nullable.toOption(result.compile_output) {
                        | Some(output) => {
                            let msg = j`無個性のくせにヒーローになるわけねぇだろう！屋上から飛び降りで死ね！：${output}`
                            let msg = if String.length(msg) > 2047 {
                                String.sub(msg, 0, 2000)
                            } else {
                                msg
                            }
                            let options: TextChannel.message_options = {
                                content: Some(msg),
                                embed: None
                            }
                            options
                        }
                        | None => {
                            let options: TextChannel.message_options = {
                                content: None,
                                embed: None
                            }
                            options
                        }
                    }
                }
                | Some(stdout) => {
                    switch Message.get_member(message) {
                        | Some(guild_member) => {
                            switch GuildMember.get_display_name(guild_member) {
                                | Some(display_name) => {
                                    let description = j`なんだこりゃ？ヴィランが言いそうなクソ痴話か、$display_name！\n\`\`\`bash\n$stdout\n\`\`\``
                                    let description = if String.length(description) > 2047 {
                                        String.sub(description, 0, 2000)
                                    } else {
                                        description
                                    }
                                    let embed = ref(MessageEmbed.make())
                                    let user = GuildMember.get_user(guild_member)
                                    let avatar_url = User.get_display_avatar(user, ())
                                    embed := MessageEmbed.set_author(embed.contents, display_name, Some(avatar_url), None)
                                    embed := MessageEmbed.set_description(embed.contents, description)
                                    embed := MessageEmbed.set_color(embed.contents, Constants.bakugo_color)
                                    embed := MessageEmbed.set_thumbnail(embed.contents, Constants.rescript_logo)
                                    embed := MessageEmbed.add_field(embed.contents, `費やす時間`, result.time ++ ` 秒`, true)
                                    embed := MessageEmbed.add_field(embed.contents, `メモリー`, Js.Float.toString(result.memory) ++ " KB", true)
                                    let options: TextChannel.message_options = {
                                        content: None,
                                        embed: Some(embed.contents)
                                    }
                                    options
                                }
                                | None => {
                                    let options: TextChannel.message_options = {
                                        content: None,
                                        embed: None
                                    }
                                    options
                                }
                            }
                        }
                        | None => {
                            let options: TextChannel.message_options = {
                                content: None,
                                embed: None
                            }
                            options
                        }
                    }
                }
            }
        }
    }
}

let evaluate = (message: Message.message) => {
    let client = axios_client()
    let code_block = switch message.content {
        | None => ""
        | Some(c) => {
            let first_index = String.index(c, '`')
            String.sub(c, first_index, String.length(c) - first_index) |> String.trim
        }
    }
    let actual_code = String.split_on_char('\n', code_block)
    |> List.filter(s => !Js.String.startsWith("```", s))
    |> String.concat("\n")
    let code_buffer = JsBuffer.from(actual_code, "utf-8")
    let body: JudgeZero.judge_zero_request_body = {
        language_id: typescript_id,
        source_code: JsBuffer.Buffer.to_encoded_string(code_buffer, "base64")
    }
    let response = create_eval_request(client, ~b=body)
    let _ = Js.Promise.then_(r => {
        let result = try_get_eval_result(client, r.token)
        Js.Promise.then_(r' => {
            switch r' {
                | None => Message.reply(message, Some(`こんなに簡単なコードでも書けねぇか？さっさと死ねや！`), None)
                | Some(r'') => Message.reply(message, None, Some(generate_eval_embed(message, r'')))
            }
        }, result)
    }, response)
}