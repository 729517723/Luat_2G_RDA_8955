module(...,package.seeall)
require"misc"
require"http"
require"common"

local ssub,schar,smatch,sbyte,slen = string.sub,string.char,string.match,string.byte,string.len
--����ʱ����д��IP��ַ�Ͷ˿ڣ�������д���ײ�Ҫ�������hostһ�£������ֵ����Ĭ�ϵ�ֵ
local ADDR,PORT ="www.linuxhub.org",80
--����POST����ʱ���õ�ַ
--local ADDR,PORT ="www.luam2m.com",80
local httpclient

--[[
��������print
����  ����ӡ�ӿڣ����ļ��е����д�ӡ�������testǰ׺
����  ����
����ֵ����
]]
local function print(...)
	_G.print("test",...)
end


--[[
��������rcvcb
����  �����ջص�����
����  ��result�����ݽ��ս��(�˲���Ϊ0ʱ������ļ���������������)
				0:�ɹ�
				2:��ʾʵ�峬��ʵ��ʵ�壬���󣬲����ʵ������
				3:���ճ�ʱ
		statuscode��httpӦ���״̬�룬string���ͻ���nil
		head��httpӦ���ͷ�����ݣ�table���ͻ���nil
		body��httpӦ���ʵ�����ݣ�string���ͻ���nil
����ֵ����
]]
local function rcvcb(result,statuscode,head,body)
	print("rcvcb",result,statuscode,head,slen(body))
	
	if result==0 then
		if head then
			print("rcvcb head:")
			--������ӡ������ͷ������Ϊ�ײ����֣�������Ӧ��ֵΪ�ײ����ֶ�ֵ
			for k,v in pairs(head) do		
				print(k..": "..v)
			end
		end
		print("rcvcb body:")
		print(body)
	end
	
	httpclient:disconnect(discb)
end


--[[
��������connectedcb
����  ��SOCKET connected �ɹ��ص�����
����  ��
����ֵ��
]]
local function connectedcb()
	--���ô˺����Żᷢ�ͱ���,request(cmdtyp,url,head,body,rcvcb),�ص�����rcvcb(result,statuscode,head,body)
    httpclient:request("GET","/",{},"",rcvcb)
end 

--[[
��������sckerrcb
����  ��SOCKETʧ�ܻص�����
����  ��
		r��string���ͣ�ʧ��ԭ��ֵ
		CONNECT: socketһֱ����ʧ�ܣ����ٳ����Զ�����
����ֵ����
]]
local function sckerrcb(r)
	print("sckerrcb",r)
end
--[[
��������connect
���ܣ����ӷ�����
������
	 connectedcb:���ӳɹ��ص�����
	 sckerrcb��http lib��socketһֱ����ʧ��ʱ�������Զ�������������ǵ���sckerrcb����
���أ�
]]
local function connect()
	httpclient:connect(connectedcb,sckerrcb)
end
--[[
��������discb
����  ��HTTP���ӶϿ���Ļص�
����  ����		
����ֵ����
]]
function discb()
	print("http discb")
	--20������½���HTTP����
	sys.timer_start(connect,20000)
end

--[[
��������http_run
����  ������http�ͻ��ˣ�����������
����  ����		
����ֵ����
]]
function http_run()
	--��ΪhttpЭ�������ڡ�TCP��Э�飬���Բ��ش���PROT����
	httpclient=http.create(ADDR,PORT)
	--httpclient:setconnectionmode(true)
	--����http����
	connect()	
end


--���ú�������
http_run()



