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

type message_embedhumbnail = {
    url: string,
    proxyURL: string,
    height: int,
    width: int
}

type message_embed

@module("discord.js") @new external make: unit => message_embed = "MessageEmbed"

@get external get_author: message_embed => option<message_embed_author> = "author"
@get external get_color: message_embed => option<int> = "color"
@get external get_description: message_embed => option<string> = "description"
@get external get_fields: message_embed => array<embed_field> = "fields"
@get external get_footer: message_embed => option<message_embed_footer> = "footer"
@get external get_hex_color: message_embed => option<string> = "hexColor"
@get external get_image: message_embed => option<message_embed_image> = "image"
@get external get_length: message_embed => int = "length"
@get external get_thumbnail: message_embed => option<message_embedhumbnail> = "thumbnail"
@get external get_title: message_embed => option<string> = "title"
@get external get_url: message_embed => option<string> = "url"
@send external add_field: message_embed => string => string => bool => message_embed = "addField"
@send external add_fields: message_embed => array<embed_field> => message_embed = "addFields"
@send external set_author: message_embed => string => option<string> => option<string> => message_embed = "setAuthor"
@send external set_color: message_embed => int => message_embed = "setColor"
@send external set_description: message_embed => string => message_embed = "setDescription"
@send external set_footer: message_embed => string => option<string> => message_embed = "setFooter"
@send external set_image: message_embed => string => message_embed = "setImage"
@send external set_thumbnail: message_embed => string => message_embed = "setThumbnail"
@send external set_title: message_embed => string => message_embed = "setTitle"
@send external set_url: message_embed => string => message_embed = "setURL"