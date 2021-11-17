function [strOut]=SNLP_removeExtraGarbage(strIn);
%%%remove ASCII code <= 31
temp=str2mat(strIn);
temp_mask=double(temp);
temp(temp_mask<=31)=[];

strOut=temp;
end
