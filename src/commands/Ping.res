let ping = (message: Message.message) => {
    let start_time = Js.Date.now()
    let msg: Js.Promise.t<Message.message> = Message.reply(message, Some(`π γγ³γ°δΈ­`), None)
    let _ = Js.Promise.then_(inner_msg => {
        let end_time = Js.Date.now()
        let diff = end_time -. start_time
        Message.edit(inner_msg, Some(j`π γγ³οΌ\n$diffγγͺη§γγγ£γ¦γγ οΌγ―γ½γοΌ`), None)
    }, msg)
}