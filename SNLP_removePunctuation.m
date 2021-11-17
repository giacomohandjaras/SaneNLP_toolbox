function [strOut]=SNLP_removePunctuation(strIn);
%%%version 0.1. REMOVE: [''’,.:;?!"%()=+<>*«»-‘’“”\\/''['']{}''_$£€&©®™@]
strIn = regexprep(strIn,'[''’,.:;?!"%()=+<>*«»\-‘’“”\\/''['']{}''_$£€&©®™@]',' ');
strIn = regexprep(strIn,char(8192),' '); %en quad
strIn = regexprep(strIn,char(8193),' '); %em quad
strIn = regexprep(strIn,'•',' ');
strIn = regexprep(strIn,'·',' ');
strIn = regexprep(strIn,'♦',' ');
strIn = regexprep(strIn,'∧',' ');
strIn = regexprep(strIn,'∨',' ');
strIn = regexprep(strIn,'\|',' ');
strIn = regexprep(strIn,'♥',' ');
strIn = regexprep(strIn,'#',' ');
strIn = regexprep(strIn,'—',' ');
strIn = regexprep(strIn,'§',' ');
strIn = regexprep(strIn,'~',' ');
strIn = regexprep(strIn,'¿',' ');
strIn = regexprep(strIn,'¡',' ');
strIn = regexprep(strIn,'■',' ');
strIn = regexprep(strIn,'°',' ');
strIn = regexprep(strIn,'█',' ');
strIn = regexprep(strIn,'¬',' ');
strIn = regexprep(strIn,'\^',' ');
strIn = regexprep(strIn,'÷',' ');
strIn = regexprep(strIn,'¨',' ');
strIn = regexprep(strIn,'♣',' ');
strIn = regexprep(strIn,'¢',' ');
strIn = regexprep(strIn,'…',' ');
strIn = regexprep(strIn,'’',' ');
strIn = regexprep(strIn,'‹',' ');
strIn = regexprep(strIn,'›',' ');


for x=8204:8303
%char(x)
strIn = regexprep(strIn,char(x),' '); %remove extra punctuation
end
for x=8314:8319
%char(x)
strIn = regexprep(strIn,char(x),' '); %remove extra punctuation
end
strOut=strIn;
end
