type judge_zero_request_body = {
    language_id: int,
    source_code: string
}

type judge_zero_post_response = {
    token: string
}

type judge_zero_get_response = {
    status_id: int,
    mutable stdout: Js.Nullable.t<string>,
    stderr: Js.Nullable.t<string>,
    message: Js.Nullable.t<string>,
    memory: float,
    time: string,
    mutable compile_output: Js.Nullable.t<string>
}