function [textDataOut]=SNLP_removeShortWords(textDataIn,k);

textDataOut="";

strn = strsplit(textDataIn,' ','CollapseDelimiters',true);
words=numel(strn);

for word=1:words
strn_w=strn(word);
if strlength(strn_w)>k
textDataOut=strcat(textDataOut,{' '},strn_w);
end
end


end
