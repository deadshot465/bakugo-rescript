open MessageEmbed

let about = (message: Message.message) => {
    let embed = ref(MessageEmbed.make())
    embed := MessageEmbed.set_color(embed.contents, Constants.bakugo_color)

    let description = `ザ・ランド・オブ・キュート・ボイズの爆豪勝己。
爆豪勝己はアニメ・マンガ・ゲーム「[僕のヒーローアカデミア](https://heroaca.com/)」の一人の主人公です。
爆豪バージョン0.3.0の開発者：
**Tetsuki Syu#1250、Kirito#9286**
制作言語・フレームワーク：
[ReScript](https://rescript-lang.org/)と[Discord.js](https://discord.js.org/)ライブラリ。`

    embed := MessageEmbed.set_description(embed.contents, description)
    embed := MessageEmbed.set_footer(embed.contents, `爆豪ボット：リリース 0.3.0 | 2021-06-05`, None)
    embed := MessageEmbed.set_thumbnail(embed.contents, Constants.rescript_logo)
    embed := MessageEmbed.set_author(embed.contents, `僕のヒーローアカデミアの爆豪勝己`, Some(Constants.bakugo_icon), None)

    let _ = TextChannel.TextChannel.send(message.channel, None, Some({
        content: None,
        embed: Some(embed.contents)
    }))
}