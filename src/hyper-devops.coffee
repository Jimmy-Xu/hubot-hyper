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
  run_gntp_cmd = (roomName, senderName, message, cb) ->
    appName = "hubot-hyper-devops"
    defaultPort = "23053"
    if robot.adapterName is "slack"
      title = "From Slack[\##{roomName} #{senderName}]"
    else
      title = "From #{robot.adapterName}"

    server = process.env.HUBOT_GNTP_SERVER
    if server? and server isnt ""
      if (server.split ":").length is 1
        server = server + ":" + defaultPort
      else if (server.split ":").length > 2
        console.log "'#{server}' is invalid server, skip execute gntp-send"
        return
    else
      console.log "no gntp server specified, skip execute gntp-send"
      return

    # prepare args
    args = ["-s", server, "-p", process.env.HUBOT_GNTP_PASSWORD, "-a", appName, title, message]
    console.debug "[run_gntp_cmd] spawn: gntp-send ", args
    # exec gntp-send
    spawn = require("child_process").spawn
    child = spawn("gntp-send", args)
    result = []
    child.stdout.on "data", (buffer) -> result.push buffer.toString()
    child.stderr.on "data", (buffer) -> result.push buffer.toString()
    child.stdout.on "end", -> cb result

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


  ###################################################
  # watch keyword
  ###################################################
  robot.hear /(error|alert|warn|fail).*/i, (data) ->
    text = data.message.text
    senderName = data.message.user.name
    if robot.adapterName is "slack"
      room = robot.adapter.client.rtm.dataStore.getChannelGroupOrDMById data.message.user.room
      roomName = room.name
      console.log "[Heard from Slack] room:[\##{roomName}], sender:[#{senderName}], message:[#{text}]"
    else
      roomName = data.message.user.room
      console.log "[Heard from #{robot.adapterName}] room:[#{roomName}], sender:[#{senderName}], message:[#{text}]"

    run_gntp_cmd roomName, senderName, text, (text) ->
      console.log "gntp result:", text