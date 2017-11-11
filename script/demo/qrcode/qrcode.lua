--[[
ģ�����ƣ���ά�����ɲ���ʾ����Ļ��
ģ������޸�ʱ�䣺2017.11.10
]]

module(...,package.seeall)
require"qrencode"
require"string"
--�����Լ���lcd�����Լ�ʹ�õ�spi���ţ������������һ���ļ����в��ԣ�
--������������������������������������������������
--�������������ļ���demo/ui Ŀ¼�����ã�����������
--������������������������������������������������
--mono��ʾ�ڰ�����color��ʾ����
--standard_spi��ʾʹ�ñ�׼��SPI���ţ�lcd_spi��ʾʹ��LCDר�õ�SPI����
--require"mono_standard_spi_ssd1306"
--require"mono_standard_spi_st7567"
require"color_standard_spi_st7735"
--require"mono_lcd_spi_ssd1306"
--require"mono_lcd_spi_st7567"
--require"color_lcd_spi_st7735"
--require"color_lcd_spi_gc9106"
--[[
��������print
����  ����ӡ�ӿڣ����ļ��е����д�ӡ�������testǰ׺
����  ����
����ֵ����
]]
local function print(...)
	_G.print("QR",...)
end

--[[
��������ArrayToBin
����  ��table����תstring
]]
function ArrayToBin(Array)
    if Len == nil or Len > #Array then
        Len = #Array
    end
	local buf = ""
	local deal_len,dummy_len = 0,0
	while deal_len < Len do
		if (Len - deal_len) > 5120 then
			dummy_len = 5120
		else
			dummy_len = Len - deal_len
		end
		buf = buf .. string.char(unpack(Array, 1 + deal_len, dummy_len + deal_len))
		deal_len = deal_len + dummy_len
	end
	return buf
end

--[[
��������create
����  �������û������Ķ�ά��������²����ͷ���ֵ��û��˵��ʱ����Ϊnumber��
����  ��data ��Ҫת���ɶ�ά������ݣ�string�ͣ�����������ʹ���ֱ�ӷ���nil nil nil 0
����  :	wide �û���Ļ���
����  :	high �û���Ļ�ĸ߶ȣ�bpp,wide,high����һ����������ȷʱ�����ԭʼ���󣬲����任
����ֵ��buf ��ά����� table�� w ��� h �߶� isfix �Ƿ񾭹��任��0Ϊû��
]]
function create(data, wide, high)
	--build��ʽ�����ģ��ǻҶȵ���ͼ��

	local isfix = 0
	local newbuf ={0}
	if (type(data) ~= "string") then
		return nil,nil,nil,0
	end
	local w,h,buf = qrencode.build(data)
    --print(wd, ht, #buf,)
	--����bpp��wide��high��ԭʼͼ��ת�����û���Ļ����ʾ��ͼ��
	if (type(wide) ~= "number" or type(high) ~= "number") then
		print(type(wide), type(high))
		return buf,w,h,isfix
	end

	if (wide < w or high < h) then
		print(wide,w,high,h)
		return buf,w,h,isfix
	end
	local x,y,d,dx,dy
	x = wide / w
	y = high / h
	d = (x > y) and y or x
	x = w * d
	y = h * d

	for i=1,x do
		for j=1,y do
			newbuf[i + (j - 1) * x] = 0xff
		end
	end
	for i=1,w do
		for j=1,h do
			if (buf[i + (j - 1) * w] ~= 0) then
				for m=i*d-(d-1), i*d do
					for n=j*d-(d-1), j*d do
						newbuf[m + (n - 1) * x] = 0
					end
				end
			end
		end
	end
	return newbuf,x,y,1
end


--[[
��������display
����  ����LCD����ʾ��ά��
����  ��data ��ʾ�Ķ�ά������ݣ���create�ӿڲ�����table��
����  :	wide ��ά����
����  :	high ��ά��߶ȣ�һ�����������һ��
����  :	startx ��ά����ʾ����ʼX���꣬0��ʼ
����  :	starty ��ά����ʾ����ʼY���꣬0��ʼ
����  :	force ��ά��ʣ��ռ��Ƿ�ǿ��ˢ�ף�0���ǣ�������
����ֵ��ʵ����ʾ�����ݳ��ȣ����Ϊ0�����ʾ�д���
]]
function display(data,wide,high,startx,starty,force)
	print(data,wide,high,startx,starty)
	return disp.putqrcode(ArrayToBin(data),wide,high,startx,starty,force)
end
