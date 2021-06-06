type text_channel

type message_options = {
    content: option<string>,
    embed: option<MessageEmbed.message_embed>
}

@module("discord.js") @new external make: unit => text_channel = "TextChannel"

@send external send: text_channel => option<string> => option<message_options> => Js.Promise.t<'a> = "send"