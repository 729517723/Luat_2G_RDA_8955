module(...,package.seeall)
--https://wenku.baidu.com/view/16ad716df8c75fbfc67db231.html
local function init()
	local para =
	{
		width = 128,
		height = 64,
		bpp = 1,
		--xoffset = 32,
		--yoffset = 64,
		bus = disp.BUS_SPI,
		hwfillcolor = 0xFFFF,
		pinrst = pio.P0_2,
		pinrs = pio.P0_12,
		initcmd =
		{
			0xE2, --soft reset
			0xA3, --����ƫѹ�ȣ�  0XA2��BIAS=1/9 (����) 0XA3��BIAS=1/7 
			0xA0, --��ʾ�е�ַ������  0xA0�����棺�е�ַ�����ң� 0xA1����ת���е�ַ���ҵ���
			0xC8, --��ɨ��˳��ѡ��  0XC0:��ͨɨ��˳�򣺴��ϵ��� 0XC8:��תɨ��˳�򣺴��µ���
			0xA6, --��ʾ����/����: 0xA6�����棺���� 0xA7������ 
			0x2F, --ѡ���ڲ���ѹ��Ӧ����ģʽ ͨ���� 0x2C,0x2E,0x2F ���� ָ�˳�������д����ʾ���δ��ڲ���ѹ����ѹ������·����ѹ��������Ҳ���Ե���д0x2F��һ���Դ������ֵ�·
			0x23, --ѡ���ڲ����������Rb/Ra��:�������Ϊ�ֵ��Աȶ�ֵ�������÷�ΧΪ��0x20��0x27�� ��ֵԽ��Աȶ�ԽŨ��ԽСԽ��
			0x81, --�����ڲ�����΢�����������Ϊ΢���Աȶ�ֵ��������ָ���������ʹ�á�����һ��ָ��0x81�ǲ��ĵģ�����һ��ָ������÷�ΧΪ��0x00��0x3F,��ֵԽ��Աȶ�ԽŨ��ԽСԽ��
			0x2E,
			0x60, --������ʾ�洢������ʾ��ʼ��,������ֵΪ0X40~0X7F,�ֱ�����0��63�У���Ը�Һ����һ������Ϊ0x60
			0xAF, --��ʾ��/��: 0XAE:�أ�0XAF����
		},
		sleepcmd = {
			0xAE,
		},
		wakecmd = {
			0xAF,
		}
	}
	print("lcd init")
	disp.init(para)
	disp.clear()
	disp.puttext("��ӭʹ��Luat",16,24)
	disp.update()
end

local function displogo()
	disp.clear()
	disp.putimage("/ldata/logo.bmp",0,0)
	disp.update()
end

pmd.ldoset(6,pmd.LDO_VMMC)
init()
sys.timer_start(displogo,3000)
