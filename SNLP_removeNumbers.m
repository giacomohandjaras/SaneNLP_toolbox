function [strOut]=SNLP_removeNumbers(strIn);

%%%non gestisce i numeri romani
strIn = regexprep(strIn, '[0-9]+', '');
strIn = regexprep(strIn,char(185),' '); %superscript 1
strIn = regexprep(strIn,char(178),' '); %superscript 2
strIn = regexprep(strIn,char(179),' '); %superscript 3
strIn = regexprep(strIn,char(8304),' '); %superscript 0

strIn = regexprep(strIn,'',' '); %subscript 
strIn = regexprep(strIn,'',' '); %subscript 
strIn = regexprep(strIn,'',' '); %subscript 
strIn = regexprep(strIn,'',' '); %subscript 
strIn = regexprep(strIn,'',' '); %subscript 
strIn = regexprep(strIn,'',' '); %subscript 
strIn = regexprep(strIn,'',' '); %subscript 
strIn = regexprep(strIn,'',' '); %subscript 
strIn = regexprep(strIn,'',' '); %subscript 
strIn = regexprep(strIn,'',' '); %subscript 


for x=8308:8313
%char(x)
strIn = regexprep(strIn,char(x),' '); %remove extra superscript number
end
for x=8320:8329
%char(x)
strIn = regexprep(strIn,char(x),' '); %remove extra subscript number
end
strOut=strIn;
end
