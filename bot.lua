JSON = (loadfile "JSON.lua")()
socket = require"socket"
socket.unix = require"socket.unix"

now = os.time()

function on_msg_receive (msg)
	if msg.date < now then
		return
	end
	if msg.out then
		return
	end

	print(msg)

	if msg.text then
		c = socket.unix()
		c:connect("socket")
		c:send(JSON:encode(msg) .. "\r\n\r\n")

		while 1 do
			data = ""
			while 1 do
				if string.find(data, "\r\n\r\n") then
					break
				end

				tmp = c:receive(1)
				if (tmp == "") or tmp == nil then
					break
				end

				data = data .. tmp
			end
			data = JSON:decode(data)

			print ('action : ' .. data['action'])
			if (data['action'] == 'send_msg') then
				send_msg(get_receiver(msg), data['arg'], ok_cb, false)
			end

			if (data['action'] == 'send_img') then
				send_photo(get_receiver(msg), data['arg'], ok_cb, false)
			end

			if (data['action'] == 'bye') then
				break
			end
		end

		c:close()
	end

	mark_read(get_receiver(msg))
end
 
function on_our_id (id)
end
 
function on_secret_chat_created (peer)
end
 
function on_user_update (user)
end
 
function on_chat_update (user)
end
 
function on_get_difference_end ()
end
 
function on_binlog_replay_end ()
end

function get_receiver(msg)
  if msg.to.type == 'user' then
    return 'user#id'..msg.from.id
  end
  if msg.to.type == 'chat' then
    return 'chat#id'..msg.to.id
  end
end

function ok_cb(extra, success, result)
end
