type response

module Response = {
    @send external json: response => unit => Js.Promise.t<'a> = "json"
}