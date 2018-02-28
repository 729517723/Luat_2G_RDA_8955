module(...,package.seeall)

require"aliyuniotssl"
require"misc"

--�����ƻ���2վ���ϴ����Ĳ�Ʒ��ProductKey���û�����ʵ��ֵ�����޸�
local PRODUCT_KEY = "b0FMK1Ga5cp"
--���������PRODUCT_KEY�⣬����Ҫ�豸���ƺ��豸֤��
--�豸����ʹ�ú���getDeviceName�ķ���ֵ��Ĭ��Ϊ�豸��IMEI
--�豸֤��ʹ�ú���getDeviceSecret�ķ���ֵ��Ĭ��Ϊ�豸��SN
--�������ʱ������ֱ���޸�getDeviceName��getDeviceSecret�ķ���ֵ
--��������ʱ��ʹ���豸��IMEI��SN������������ģ�飬����Ψһ��IMEI���û��������Լ��Ĳ�������д���IMEI���豸���ƣ���Ӧ��SN���豸֤�飩
--�����û��Խ�һ�����������豸�ϱ�IMEI�������������������ض�Ӧ���豸֤�飬Ȼ�����misc.setsn�ӿ�д���豸��SN��

--[[
��������getDeviceName
����  ����ȡ�豸����
����  ����
����ֵ���豸����
]]
local function getDeviceName()
	--Ĭ��ʹ���豸��IMEI��Ϊ�豸����
	return misc.getimei()
end

--[[
��������getDeviceSecret
����  ����ȡ�豸֤��
����  ����
����ֵ���豸֤��
]]
local function getDeviceSecret()
	--Ĭ��ʹ���豸��SN��Ϊ�豸֤��
	--�û��������ʱ�������ڴ˴�ֱ�ӷ��ذ����Ƶ�iot����̨�����ɵ��豸֤�飬����return "Pa0EaHDiOB8s18KwtpdOmdrWP2EGD1Mt"
	--return "Pa0EaHDiOB8s18KwtpdOmdrWP2EGD1Mt"
	return misc.getsn()
end


local qos1cnt = 1

--[[
��������print
����  ����ӡ�ӿڣ����ļ��е����д�ӡ�������aliyuniotǰ׺
����  ����
����ֵ����
]]
local function print(...)
	_G.print("test",...)
end

--[[
��������pubqos1testackcb
����  ������1��qosΪ1����Ϣ���յ�PUBACK�Ļص�����
����  ��
		usertag������mqttclient:publishʱ�����usertag
		result��true��ʾ�����ɹ���false����nil��ʾʧ��
����ֵ����
]]
local function pubqos1testackcb(usertag,result)
	print("pubqos1testackcb",usertag,result)
	sys.timer_start(pubqos1test,20000)
	qos1cnt = qos1cnt+1
end

--[[
��������pubqos1test
����  ������1��qosΪ1����Ϣ
����  ����
����ֵ����
]]
function pubqos1test()
	--ע�⣺�ڴ˴��Լ�ȥ����payload�����ݱ��룬aliyuniot���в����payload���������κα���ת��
	aliyuniotssl.publish("/"..PRODUCT_KEY.."/"..getDeviceName().."/update","qos1data",1,pubqos1testackcb,"publish1test_"..qos1cnt)
end

--[[
��������subackcb
����  ��MQTT SUBSCRIBE֮���յ�SUBACK�Ļص�����
����  ��
		usertag������mqttclient:subscribeʱ�����usertag
		result��true��ʾ���ĳɹ���false����nil��ʾʧ��
����ֵ����
]]
local function subackcb(usertag,result)
	print("subackcb",usertag,result)
end

--[[
��������rcvmessage
����  ���յ�PUBLISH��Ϣʱ�Ļص�����
����  ��
		topic����Ϣ���⣨gb2312���룩
		payload����Ϣ���أ�ԭʼ���룬�յ���payload��ʲô���ݣ�����ʲô���ݣ�û�����κα���ת����
		qos����Ϣ�����ȼ�
����ֵ����
]]
local function rcvmessagecb(topic,payload,qos)
	print("rcvmessagecb",topic,payload,qos)
	aliyuniotssl.publish("/"..PRODUCT_KEY.."/"..getDeviceName().."/update","device receive:"..payload,qos)
end

--[[
��������connectedcb
����  ��MQTT CONNECT�ɹ��ص�����
����  ����		
����ֵ����
]]
local function connectedcb()
	print("connectedcb")
	--��������
	aliyuniotssl.subscribe({{topic="/"..PRODUCT_KEY.."/"..getDeviceName().."/get",qos=0}, {topic="/"..PRODUCT_KEY.."/"..getDeviceName().."/get",qos=1}}, subackcb, "subscribegetopic")
	--ע���¼��Ļص�������MESSAGE�¼���ʾ�յ���PUBLISH��Ϣ
	aliyuniotssl.regevtcb({MESSAGE=rcvmessagecb})
	--����һ��qosΪ1����Ϣ
	pubqos1test()
end

--[[
��������connecterrcb
����  ��MQTT CONNECTʧ�ܻص�����
����  ��
		r��ʧ��ԭ��ֵ
			1��Connection Refused: unacceptable protocol version
			2��Connection Refused: identifier rejected
			3��Connection Refused: server unavailable
			4��Connection Refused: bad user name or password
			5��Connection Refused: not authorized
����ֵ����
]]
local function connecterrcb(r)
	print("connecterrcb",r)
end

--���ò�Ʒkey���豸���ƺ��豸֤�飻�ڶ����������봫��nil���˲�����Ϊ�˼��ݰ����ƺ���վ�㣩
aliyuniotssl.config(PRODUCT_KEY,nil,getDeviceName,getDeviceSecret)
aliyuniotssl.regcb(connectedcb,connecterrcb)


--Ҫʹ�ð�����OTA���ܣ�����ο����ļ�136��aliyuniotssl.config(PRODUCT_KEY,nil,getDeviceName,getDeviceSecret)ȥ���ò�Ʒkey���豸���ƺ��豸֤��
--Ȼ����ذ�����OTA����ģ��(������Ĵ���ע��)
--require"aliyuniotota"
--������ð�����OTA����ȥ������������ģ����¹̼���Ĭ�ϵĹ̼��汾�Ÿ�ʽΪ��_G.PROJECT.."_".._G.VERSION.."_"..sys.getcorever()���򵽴�Ϊֹ������Ҫ�ٿ�����˵��


--������ð�����OTA����ȥ��������������������ģ����ӵ�MCU�������������ʵ�������������Ĵ���ע�ͣ��������ýӿڽ������úʹ���
--����MCU��ǰ���еĹ̼��汾��
--aliyuniotota.setVer("MCU_VERSION_1.0.0")
--�����¹̼����غ󱣴���ļ���
--aliyuniotota.setName("MCU_FIRMWARE.bin")

--[[
��������otaCb
����  ���¹̼��ļ����ؽ�����Ļص�����
����  ��
		result�����ؽ����trueΪ�ɹ���falseΪʧ��
		filePath���¹̼��ļ����������·����ֻ��resultΪtrueʱ���˲�����������
����ֵ����
]]
--[[
local function otaCb(result,filePath)
	print("otaCb",result,filePath)

	--�����Լ�������ȥʹ���ļ�filePath
	local fileHandle = io.open(filePath,"rb")
	if not fileHandle then print("otaCb open file error") return end
	local current = fileHandle:seek()
	local size = fileHandle:seek("end")
	fileHandle:seek("set",current)
	--����ļ�����
	print("otaCb size",size)
	
	--����ļ����ݣ�����ļ�̫��һ���Զ����ļ����ݿ��ܻ�����ڴ治�㣬�ִζ������Ա��������
	if size<=4096 then
		print(fileHandle:read("*all"))
	else
		--�ֶζ�ȡ�ļ�����
	end
	
	fileHandle:close()
	
	--�ļ�ʹ����֮������Ժ���������Ҫ����ɾ��
	if filePath then os.remove(filePath) end
end
]]

--�����¹̼����ؽ���Ļص�����
--aliyuniotota.setCb(otaCb)
