type client_user_t

@get external get_avatar: client_user_t => option<string> = "avatar"
@get external get_bot: client_user_t => bool = "bot"
@get external get_username: client_user_t => option<string> = "username"
@get external get_presence: client_user_t => Presence.presence_t = "presence"
@get external get_id: client_user_t => Snowflake.snowflake = "id"
@send external set_presence: client_user_t => PresenceData.presence_data => Js.Promise.t<Presence.presence_t> = "setPresence"