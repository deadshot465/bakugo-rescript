type activity = {
    "name": string,
    "type": string
}

type presence_data = {
    status: PresenceStatusData.presence_status_data,
    afk: bool,
    activity: activity
}