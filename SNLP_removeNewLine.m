function [strOut]=SNLP_removeNewLine(strIn);

strOut = regexprep(strIn,'\n',' ');
strOut = regexprep(strOut,'\r',' ');

end
