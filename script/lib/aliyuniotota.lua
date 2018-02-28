--����ģ��,����������
require"aliyuniotssl"
require"https"
module(...,package.seeall)

--gVersion���̼��汾���ַ���������û�û�е��ñ��ļ���setVer�ӿ����ã���Ĭ��Ϊ_G.PROJECT.."_".._G.VERSION.."_"..sys.getcorever()
--gPath��������iot��վ�����õ��¹̼��ļ����غ���ģ���еı���·��������û�û�е��ñ��ļ���setName�ӿ����ã���Ĭ��Ϊ/luazip/update.bin
--gCb���¹̼����سɹ���Ҫִ�еĻص�����
local gVersion,gPath,gCb = _G.PROJECT.."_".._G.VERSION.."_"..sys.getcorever(),"/luazip/update.bin"

--productKey����Ʒ��ʶ
--deviceName���豸����
local productKey,deviceName

--verRpted���汾���Ƿ��Ѿ��ϱ�
local verRpted

--httpClient�������¹̼���http client
--httpUrl��get�����е�url�ֶ�
local httpClient,httpUrl

--lastStep�����һ���ϱ��������¹̼��Ľ���
local lastStep


--[[
��������print
����  ����ӡ�ӿڣ����ļ��е����д�ӡ�������aliyuniototaǰ׺
����  ����
����ֵ����
]]
local function print(...)
	_G.print("aliyuniotota",...)
end

--[[
��������verRptCb
����  ���ϱ��̼��汾�Ÿ��ƶ˺��յ�PUBACKʱ�Ļص�����
����  ��
		tag���˴�������
		result��true��ʾ�ϱ��ɹ���false����nil��ʾʧ��
����ֵ����
]]
local function verRptCb(tag,result)
	print("verRptCb",result)
	verRpted = result
	if not result then sys.timer_start(verRpt,20000) end
end

--[[
��������verRpt
����  ���ϱ��̼��汾�Ÿ��ƶ�
����  ����
����ֵ����
]]
function verRpt()
	print("verRpt",gVersion)
	aliyuniotssl.publish("/ota/device/inform/"..productKey.."/"..deviceName,"{\"id\":1,\"params\":{\"version\":\""..gVersion.."\"}}",1,verRptCb)
end

--[[
��������connectedCb
����  ��MQTT CONNECT�ɹ��ص�����
����  ��
		key��ProductKey
		name���豸����
����ֵ����
]]
function connectedCb(key,name)
	print("connectedCb",verRpted)
	productKey,deviceName = key,name
	--��������
	aliyuniotssl.subscribe({{topic="/ota/device/upgrade/"..key.."/"..name,qos=0}, {topic="/ota/device/upgrade/"..key.."/"..name,qos=1}})
	if not verRpted then		
		--�ϱ��̼��汾�Ÿ��ƶ�
		verRpt()
	end
end

--[[
��������upgradeStepRpt
����  ���¹̼��ļ����ؽ����ϱ�
����  ��
		step��1��100�������ؽ��ȱȣ�-2��������ʧ��
		desc��������Ϣ����Ϊ�ջ���nil
����ֵ����
]]
local function upgradeStepRpt(step,desc)
	print("upgradeStepRpt",step,desc)
	if step<=0 or step==100 then sys.timer_stop(getPercent) end
	lastStep = step
	aliyuniotssl.publish("/ota/device/progress/"..productKey.."/"..deviceName,"{\"id\":1,\"params\":{\"step\":\""..step.."\",\"desc\":\""..(desc or "").."\"}}")
end

--[[
��������downloadCb
����  ���¹̼��ļ����ؽ�����Ĵ�����
����  ��
		result�����ؽ����trueΪ�ɹ���falseΪʧ��
		filePath���¹̼��ļ����������·����ֻ��resultΪtrueʱ���˲�����������
����ֵ����
]]
local function downloadCb(result,filePath)
	print("downloadCb",gCb,result,filePath)
	sys.setrestart(true,4)
	sys.timer_stop(sys.setrestart,true,4)
	if gCb then
		gCb(result,filePath)
	else
		if result then sys.restart("ALIYUN_OTA") end
	end
end

--[[
��������httpRcvCb
����  �����ջص������������ļ���
����  ��result�����ݽ��ս��(�˲���Ϊ0ʱ������ļ���������������)
				0:�ɹ�
				2:��ʾʵ�峬��ʵ��ʵ�壬���󣬲����ʵ������
				3:���ճ�ʱ
		statuscode��httpӦ���״̬�룬string���ͻ���nil
		head��httpӦ���ͷ�����ݣ�table���ͻ���nil
		filename: �����ļ�������·����
����ֵ����
]]
local function httpRcvCb(result,statuscode,head,filename)
	print("httpRcvCb",result,statuscode,head,filename)
	upgradeStepRpt(result==0 and 100 or -2,result)
	sys.timer_start(downloadCb,3000,result==0,filename)
	httpClient:destroy()	
end

--[[
��������getPercent
����  ����ȡ�ļ����ذٷֱ�
����  ��
����ֵ��
]]
function getPercent()
	local step = httpClient:getrcvpercent()
	if step~=0 and step~=lastStep then
		upgradeStepRpt(step)
	end
	sys.timer_start(getPercent,5000)
end

--[[
��������httpConnectedCb
����  ��SOCKET connected �ɹ��ص�����
����  ��
����ֵ��
]]
local function httpConnectedCb()
	httpClient:request("GET",httpUrl,{},"",httpRcvCb,gPath)
	sys.timer_start(getPercent,5000)
end 

--[[
��������httpErrCb
����  ��SOCKETʧ�ܻص�����
����  ��
		r��string���ͣ�ʧ��ԭ��ֵ
		CONNECT: socketһֱ����ʧ�ܣ����ٳ����Զ�����
		SEND��socket��������ʧ�ܣ����ٳ����Զ�����
����ֵ����
]]
local function httpErrCb(r)
	print("httpErrCb",r)
	upgradeStepRpt(-2,r)
	downloadCb(false)
	httpClient:destroy()	
end

--[[
��������upgrade
����  ���յ��ƶ˹̼�����֪ͨ��Ϣʱ�Ļص�����
����  ��
		payload����Ϣ���أ�ԭʼ���룬�յ���payload��ʲô���ݣ�����ʲô���ݣ�û�����κα���ת����
����ֵ����
]]
function upgrade(payload)	
	local res,jsonData = pcall(json.decode,payload)
	print("upgrade",res,payload)
	if res then
		if jsonData.data and jsonData.data.url then
			print("url",jsonData.data.url)
			local host,url = string.match(jsonData.data.url,"https://(.-)/(.+)")
			print("httpUrl",url)
			if host and url then
				httpUrl = "/"..url
				httpClient=https.create(host,443)
				httpClient:connect(httpConnectedCb,httpErrCb)
			end
			
		end
	end
end

--[[
��������setVer
����  �����ù̼��汾��
����  ��
		version��string���ͣ��̼��汾��
����ֵ����
]]
function setVer(version)
	gVersion = version
end

--[[
��������setName
����  �������¹̼�������ļ���
����  ��
		name��string���ͣ��¹̼��ļ���
����ֵ����
]]
function setName(name)
	gPath = name
end

--[[
��������setCb
����  �������¹̼����غ�Ļص�����
����  ��
		cb��function���ͣ��¹̼����غ�Ļص�����
����ֵ����
]]
function setCb(cb)
	gCb = cb
end

sys.setrestart(false,4)
sys.timer_start(sys.setrestart,300000,true,4)
