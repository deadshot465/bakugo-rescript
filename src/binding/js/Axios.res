type axios_config = {
    baseURL: string,
    headers: Js.Dict.t<string>
}

type axios_static
type axios_instance

type axios_response<'a> = {
    data: 'a,
    status: int,
    statusText: string
}

@module("axios") external axios: axios_static = "default"
@send external create: axios_static => axios_config => axios_instance = "create"
@send external post: axios_instance => string => string => Js.Promise.t<axios_response<'a>> = "post"
@send external get: axios_instance => string => Js.Promise.t<axios_response<'a>> = "get"