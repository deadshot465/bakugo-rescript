@scope("JSON") @val external parse_random_responses: string => array<string> = "parse"
@module("fs") external read_file_sync: string => string => string = "readFileSync"
@module("fs") external write_file_sync: string => string => string => unit = "writeFileSync"

let random_response_path = "./assets/randomResponses.json"

let random_responses = {
    let content = read_file_sync(random_response_path, "utf8")
    ref(parse_random_responses(content))
}

let add_response = context => {
    random_responses := Array.append([context], random_responses.contents)
    switch Js.Json.stringifyAny(random_responses.contents) {
        | None => ()
        | Some(s) => write_file_sync(random_response_path, s, "utf8")
    }
}

let remove_response = context => {
    if Array.mem(context, random_responses.contents) {
        random_responses := Array.to_list(random_responses.contents)
        |> List.filter(s => s != context)
        |> Array.of_list
        switch Js.Json.stringifyAny(random_responses.contents) {
            | None => ()
            | Some(s) => write_file_sync(random_response_path, s, "utf8")
        }
        true
    } else {
        false
    }
}

let response = (message: Message.message) => {
    let prefix = Util.env->Js.Dict.unsafeGet("PREFIX") ++ "response "
    let prefix_length = String.length(prefix)
    let content = switch message.content {
        | None => ""
        | Some(s) => String.sub(s, prefix_length, String.length(s) - prefix_length) |> String.trim
    }
    let split = String.split_on_char(' ', content)
    let cmd = List.hd(split) |> String.lowercase_ascii
    let context = List.tl(split) |> String.concat(" ")
    switch cmd {
        | "add" => {
            add_response(context)
            let _ = Message.reply(message, Some(`ちっ、面倒臭いけどやってやろう。`), None)
        }
        | "remove" => {
            if remove_response(context) {
                let _ = Message.reply(message, Some(`うるせぇ。もうしねぇよ。`), None)
            } else {
                let _ = Message.reply(message, Some(`クソか！俺様がこんなことを言うと思ってやがってんの？`), None)
            }
        }
        | _ => ()
    }
}