--��Ҫ���ѣ����������λ�ö���MODULE_TYPE��PROJECT��VERSION����
--MODULE_TYPE��ģ���ͺţ�Ŀǰ��֧��Air201��Air202��Air800
--PROJECT��ascii string���ͣ�������㶨�壬ֻҪ��ʹ��,����
--VERSION��ascii string���ͣ����ʹ��Luat������ƽ̨�̼������Ĺ��ܣ����밴��"X.X.X"���壬X��ʾ1λ���֣��������㶨��
MODULE_TYPE = "Air202"
PROJECT = "USER_SERVER_UPDATE"
VERSION = "1.0.0"
require"sys"
--[[
���ʹ��UART���trace��������ע�͵Ĵ���"--sys.opntrace(true,1)"���ɣ���2������1��ʾUART1���trace�������Լ�����Ҫ�޸��������
�����������������trace�ڵĵط�������д��������Ա�֤UART�ھ����ܵ�����������ͳ��ֵĴ�����Ϣ��
���д�ں��������λ�ã����п����޷����������Ϣ���Ӷ����ӵ����Ѷ�
]]
--sys.opntrace(true,1)
--�û�ʹ���Լ����http������������������ʱ��ҲҪ����PRODUCT_KEY������������ֵ�����Լ�����Ŀ�������ж���
PRODUCT_KEY = "HJdJ7BGeQ3aUjMUetdYrUUuSMEDoAAZI"
--[[
ʹ���û��Լ�������������ʱ���������²������
1������updatehttpģ�� require"updatehttp"
2�������û��Լ���������������ַ���˿ں�GET�����URL������ updatehttp.setup("TCP","www.userserver.com",80,"/api/site/firmware_upgrade")
ִ���������������豸ÿ�ο���������׼�������󣬾ͻ��Զ���������������ִ����������
3�������Ҫ��ʱִ���������ܣ���--updatehttp.setperiod(3600)��ע�ͣ������Լ�����Ҫ�����ö�ʱ����
4�������Ҫʵʱִ���������ܣ��ο�--sys.timer_start(updatehttp.request,120000)�������Լ�����Ҫ������updatehttp.request()����
]]
require"updatehttp"
--[[
--��Ҫ���ѣ�
--updatehttp.setup�ӿڴ����urlֻ��GET�����URL��ǰ�벿�֣�updatehttp.lua�л��ں������������Ϣ
"?project_key="..base.PRODUCT_KEY
"&imei="..misc.getimei()
"&device_key="..misc.getsn()
"&firmware_name="..base.PROJECT.."_"..rtos.get_version()
"&version="..base.VERSION
]]
updatehttp.setup("tcp","www.userserver.com",80,"/api/site/firmware_upgrade")
--updatehttp.setperiod(3600)
--sys.timer_start(updatehttp.request,120000)
require"dbg"
sys.timer_start(dbg.setup,12000,"UDP","ota.airm2m.com",9072)
require"test"
if MODULE_TYPE=="Air201" then
require"wdt"
end

sys.init(0,0)
sys.run()
