function [strOut]=SNLP_removeSpaces(strIn);
%temp2=strIn;
%temp1='';
%while ~strcmp(temp1,temp2)
%  temp1=temp2;
%  temp2=regexprep(temp1,' ','');
%end
%strOut=temp2;

strOut=regexprep(strIn,char(160),'');
strOut=regexprep(strOut,char(8194),'');
strOut=regexprep(strOut,char(8195),'');
strOut=regexprep(strOut,char(8196),'');
strOut=regexprep(strOut,char(8197),'');
strOut=regexprep(strOut,char(8198),'');
strOut=regexprep(strOut,char(8199),'');
strOut=regexprep(strOut,char(8200),'');
strOut=regexprep(strOut,char(8201),'');
strOut=regexprep(strOut,char(8202),'');
strOut=regexprep(strOut,char(8203),'');
strOut=regexprep(strOut,char(8239),'');
strOut=regexprep(strOut,char(8287),'');
strOut=regexprep(strOut,'[ ]+','');

end
