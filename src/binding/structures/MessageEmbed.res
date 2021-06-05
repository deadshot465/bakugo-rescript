type message_embed_author = {
    name: string,
    url: string,
    iconURL: string,
    proxyIconURL: string
}

type embed_field = {
    name: string,
    value: string,
    inline: bool
}

type message_embed_footer = {
    text: string,
    iconURL: string,
    proxyIconURL: string
}

type message_embed_image = {
    url: string,
    proxyURL: string,
    height: int,
    width: int
}

type message_embed_thumbnail = {
    url: string,
    proxyURL: string,
    height: int,
    width: int
}

type message_embed_t

module MessageEmbed = {
    @module("discord.js") @new external make: unit => message_embed_t = "MessageEmbed"

    @get external get_author: message_embed_t => option<message_embed_author> = "author"
    @get external get_color: message_embed_t => option<int> = "color"
    @get external get_description: message_embed_t => option<string> = "description"
    @get external get_fields: message_embed_t => array<embed_field> = "fields"
    @get external get_footer: message_embed_t => option<message_embed_footer> = "footer"
    @get external get_hex_color: message_embed_t => option<string> = "hexColor"
    @get external get_image: message_embed_t => option<message_embed_image> = "image"
    @get external get_length: message_embed_t => int = "length"
    @get external get_thumbnail: message_embed_t => option<message_embed_thumbnail> = "thumbnail"
    @get external get_title: message_embed_t => option<string> = "title"
    @get external get_url: message_embed_t => option<string> = "url"

    @send external add_field: message_embed_t => string => string => bool => message_embed_t = "addField"
    @send external add_fields: message_embed_t => array<embed_field> => message_embed_t = "addFields"
    @send external set_author: message_embed_t => string => option<string> => option<string> => message_embed_t = "setAuthor"
    @send external set_color: message_embed_t => int => message_embed_t = "setColor"
    @send external set_description: message_embed_t => string => message_embed_t = "setDescription"
    @send external set_footer: message_embed_t => string => option<string> => message_embed_t = "setFooter"
    @send external set_image: message_embed_t => string => message_embed_t = "setImage"
    @send external set_thumbnail: message_embed_t => string => message_embed_t = "setThumbnail"
    @send external set_title: message_embed_t => string => message_embed_t = "setTitle"
    @send external set_url: message_embed_t => string => message_embed_t = "setURL"
}