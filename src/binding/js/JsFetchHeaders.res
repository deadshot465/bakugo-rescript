type headers

module Headers = {
    @new external make: unit => headers = "Headers"
    
    @send external append: headers => string => string => unit = "append"
}