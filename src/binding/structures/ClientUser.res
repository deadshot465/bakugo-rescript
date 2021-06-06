type client_user

@get external get_avatar: client_user => option<string> = "avatar"
@get external get_bot: client_user => bool = "bot"
@get external get_username: client_user => option<string> = "username"
@get external get_presence: client_user => Presence.presence = "presence"
@get external get_id: client_user => Snowflake.snowflake = "id"
@send external set_presence: client_user => PresenceData.presence_data => Js.Promise.t<Presence.presence> = "setPresence"