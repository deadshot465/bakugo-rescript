type guild_member

@get external get_display_name: guild_member => option<string> = "displayName"
@get external get_user: guild_member => User.user = "user"