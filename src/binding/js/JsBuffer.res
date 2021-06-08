type buffer

@scope("Buffer") @val external from: string => string => buffer = "from"


module Buffer = {
    @new external make: string => buffer = "Buffer"
    @send external to_encoded_string: buffer => string => string = "toString"
    @send external to_string: buffer => unit => string = "toString"
}