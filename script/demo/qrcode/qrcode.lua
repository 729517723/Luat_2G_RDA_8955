--[[
ģ�����ƣ���ά�����ɲ���ʾ����Ļ��
ģ������޸�ʱ�䣺2017.11.10
]]

module(...,package.seeall)

--- qrencode.encode(string) ������ά����Ϣ
-- @param string ��ά���ַ���
-- @return width ���ɵĶ�ά����Ϣ���
-- @return data ���ɵĶ�ά������
-- @usage local width, data = qrencode.encode("http://www.openluat.com")
local width, data = qrencode.encode('http://www.openluat.com')

--- disp.putqrcode(data, width, display_width, x, y) ��ʾ��ά��
-- @param data ��qrencode.encode���صĶ�ά������
-- @param width ��ά�����ݵ�ʵ�ʿ��
-- @param display_width ��ά��ʵ����ʾ���
-- @param x ��ά����ʾ��ʼ����x
-- @param y ��ά����ʾ��ʼ����y

--- ��ά����ʾ����
local function appQRCode()
    disp.clear()
    disp.drawrect(10, 10, 117, 117, WHITE)
    disp.putqrcode(data, width, 100, 14, 14)
    disp.update()
end

appQRCode()
