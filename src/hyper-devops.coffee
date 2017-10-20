# Description:
#   hyper.sh devops
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot hyper <arguments> - Run hyper cli command line
#
# Author:
#   Jimmy Xu <xjimmyshcn@gmail.com>
#

module.exports = (robot) ->

###################################################
# func
###################################################
  run_hyper_cmd = (cmd, args, cb) ->
    console.log "[run_hyper_cmd] adapter:", robot.adapterName
    prefix = suffix = ""
    if robot.adapterName is "slack"
      prefix = "```\n"
      suffix = "\n```"

    console.info "[hubot-hyper] spawn:", cmd, args
    spawn = require("child_process").spawn
    child = spawn(cmd, args)
    result = []
    child.stdout.on "data", (buffer) -> result.push buffer.toString()
    child.stderr.on "data", (buffer) -> result.push buffer.toString()
    child.stdout.on "end", -> cb prefix + result + suffix


  ###################################################
  # watch hyper cli command line
  ###################################################
  robot.respond /hyper (.*)/, (data) ->
    args = data.message.text
    senderName = data.message.user.name
    if robot.adapterName is "slack"
      room = robot.adapter.client.rtm.dataStore.getChannelGroupOrDMById data.message.user.room
      roomName = room.name
    else
      roomName = data.message.user.room
      console.log "[Respond from #{robot.adapterName}] room:[\##{roomName}], sender:[#{sendeName}], command args:[#{args}]"
    run_hyper_cmd 'hyper', data.match[1].split(" "), (text) ->
      data.send text
