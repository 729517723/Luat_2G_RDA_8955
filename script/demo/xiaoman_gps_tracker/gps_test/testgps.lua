--[[
ģ�����ƣ���GPSӦ�á�����
ģ�鹦�ܣ�����gpsapp.lua�Ľӿ�
ģ������޸�ʱ�䣺2017.02.16
]]
require"gps"
require"agps"
module(...,package.seeall)

--[[
��������print
����  ����ӡ�ӿڣ����ļ��е����д�ӡ�������gpsappǰ׺
����  ����
����ֵ����
]]
local function print(...)
	_G.print("testgps",...)
end

local function test1cb(cause)
	--gps.isfix()���Ƿ�λ�ɹ�
	--gps.getgpslocation()����γ����Ϣ
	print("test1cb",cause,gps.isfix(),gps.getgpslocation())
end

local function test2cb(cause)
	--gps.isfix()���Ƿ�λ�ɹ�
	--gps.getgpslocation()����γ����Ϣ
	print("test2cb",cause,gps.isfix(),gps.getgpslocation())
end

local function test3cb(cause)
	--gps.isfix()���Ƿ�λ�ɹ�
	--gps.getgpslocation()����γ����Ϣ
	print("test3cb",cause,gps.isfix(),gps.getgpslocation())
end

--UART2���UBLOX GPSģ��
gps.init(nil,nil,true,1000,2,9600,8,uart.PAR_NONE,uart.STOP_1)

--[[
sys.timer_start(gps.writegpscmd,1000,true,"B56206010600F00000000000FD15",true) --�ر�GGA
sys.timer_start(gps.writegpscmd,1000,true,"B56206010600F00100000000FE1A",true) --�ر�GLL
sys.timer_start(gps.writegpscmd,1000,true,"B56206010600F00200000000FF1F",true) --�ر�GSA
sys.timer_start(gps.writegpscmd,1000,true,"B56206010600F003000000000024",true) --�ر�GSV
sys.timer_start(gps.writegpscmd,1000,true,"B56206010600F00500000000022E",true) --�ر�VTG
]]
--sys.timer_start(gps.writegpscmd,1000,true,"B562060806006400010001007A12",true) --100ms

--���Դ��뿪�أ�ȡֵ1,2
local testidx = 1

--��1�ֲ��Դ���
if testidx==1 then
	--ִ�����������д����GPS�ͻ�һֱ��������Զ����ر�
	--��Ϊgps.open(gps.DEFAULT,{cause="TEST1",cb=test1cb})�����������û�е���gps.close�ر�
	gps.open(gps.DEFAULT,{cause="TEST1",cb=test1cb})
	
	--10���ڣ����gps��λ�ɹ�������������test2cb��Ȼ���Զ��ر������GPSӦ�á�
	--10��ʱ�䵽��û�ж�λ�ɹ�������������test2cb��Ȼ���Զ��ر������GPSӦ�á�
	gps.open(gps.TIMERORSUC,{cause="TEST2",val=10,cb=test2cb})
	
	--300��ʱ�䵽������������test3cb��Ȼ���Զ��ر������GPSӦ�á�
	gps.open(gps.TIMER,{cause="TEST3",val=300,cb=test3cb})
--��2�ֲ��Դ���
elseif testidx==2 then
	gps.open(gps.DEFAULT,{cause="TEST1",cb=test1cb})
	sys.timer_start(gps.close,30000,gps.DEFAULT,{cause="TEST1"})
	gps.open(gps.TIMERORSUC,{cause="TEST2",val=10,cb=test2cb})
	gps.open(gps.TIMER,{cause="TEST3",val=60,cb=test3cb})	
end
