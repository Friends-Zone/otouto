;; users.fnl
;; Stores usernames, IDs, and display names for users seen by the bot.
;; Worthless on its own but prerequisite for some plugins.

;; Copyright 2018 topkecleon <drew@otou.to>
;; This code is licensed under the GNU AGPLv3. See /LICENSE for details.

{
  :init (fn [self bot]
    (set self.triggers [""])
    (local users (or bot.database.userdata.info {}))
    (set bot.database.userdata.info users)
    (tset users (tostring bot.info.id) bot.info)
    (values))

  :action (fn [self bot msg]
    (local users bot.database.userdata.info)
    (tset users (tostring msg.from.id) msg.from)
    (if msg.entities
        (each [_ entity (ipairs msg.entities)]
            (if entity.user
                (tset users (tostring entity.user.id) entity.user))))
    (if
      msg.reply_to_message
        (tset users (tostring msg.reply_to_message.from.id) msg.reply_to_message.from)
      msg.forward_from
        (tset users (tostring msg.forward_from.id) msg.forward_from)
      msg.new_chat_member
        (tset users (tostring msg.new_chat_member.id) msg.new_chat_member)
      msg.left_chat_member
        (tset users (tostring msg.left_chat_member.id) msg.left_chat_member)
      ; else
        nil)
    :continue)
}
