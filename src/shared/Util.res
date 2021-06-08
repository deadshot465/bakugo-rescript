@scope("process") @val external env: Js.Dict.t<string> = "env"

let unwrap_or = opt => default => {
    switch opt {
        | None => default
        | Some(o) => o
    }
}