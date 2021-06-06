type message = {
    content: option<string>,
    channel: TextChannel.text_channel
}

@send external reply: message => option<string> => option<TextChannel.message_options> => Js.Promise.t<'a> = "reply"
@send external edit: message => option<string> => option<TextChannel.message_options> => Js.Promise.t<'a> = "edit"