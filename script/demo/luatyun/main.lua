--���������λ�ö���PROJECT��VERSION����
--PROJECT��ascii string���ͣ�������㶨�壬ֻҪ��ʹ��,����
--VERSION��ascii string���ͣ����ʹ��Luat������ƽ̨�̼������Ĺ��ܣ����밴��"X.X.X"���壬X��ʾ1λ���֣��������㶨��
PROJECT = "LUATYUN"
VERSION = "1.0.0"
--[[
ʹ��Luat������ƽ̨����Ĺ��ܣ����밴�����²��������
1����Luat������ƽ̨ǰ��ҳ�棺https://iot.openluat.com/
2�����û���û�����ע���û�
3��ע���û�֮�����û�ж�Ӧ����Ŀ������һ������Ŀ
4�������Ӧ����Ŀ�������ߵ���Ŀ��Ϣ���ұ߻������Ϣ���ݣ��ҵ�ProductKey����ProductKey�����ݣ���ֵ��PRODUCT_KEY����
]]
PRODUCT_KEY = "GEAiu5GorLPe2pzZBCCwyYRJJQnW0XRb"
require"sys"
--[[
���ʹ��UART���trace��������ע�͵Ĵ���"--sys.opntrace(true,1)"���ɣ���2������1��ʾUART1���trace�������Լ�����Ҫ�޸��������
�����������������trace�ڵĵط�������д��������Ա�֤UART�ھ����ܵ�����������ͳ��ֵĴ�����Ϣ��
���д�ں��������λ�ã����п����޷����������Ϣ���Ӷ����ӵ����Ѷ�
]]
--sys.opntrace(true,1)
require"test"

sys.init(0,0)
ril.request("AT*EXASSERT=1")
ril.request("AT*TRACE=\"DSS\",1,0")
ril.request("AT*TRACE=\"RDA\",1,0")
ril.request("AT*TRACE=\"SXS\",1,0")
sys.run()
