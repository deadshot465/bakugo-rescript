type timeout_id

@val external set_timeout: (unit => unit, int) => timeout_id = "setTimeout"