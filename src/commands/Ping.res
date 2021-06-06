let ping = (message: Message.message) => {
    let start_time = Js.Date.now()
    let msg: Js.Promise.t<Message.message> = Message.reply(message, Some(`🏓 ピング中`), None)
    let _ = Js.Promise.then_(inner_msg => {
        let end_time = Js.Date.now()
        let diff = end_time -. start_time
        Message.edit(inner_msg, Some(j`🏓 ポン！\n$diffミリ秒かかってんだ！クソか！`), None)
    }, msg)
}