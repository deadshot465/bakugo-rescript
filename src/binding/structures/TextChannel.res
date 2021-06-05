type text_channel_t

type message_options = {
    content: option<string>,
    embed: option<MessageEmbed.message_embed_t>
}

module TextChannel = {
    @module("discord.js") @new external make: unit => text_channel_t = "TextChannel"

    @send external send: text_channel_t => option<string> => option<message_options> => Js.Promise.t<'a> = "send"
}